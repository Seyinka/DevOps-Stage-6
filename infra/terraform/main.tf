terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
} 

# AWS Provider
provider "aws" {
  region = var.aws_region
}

# SSH Key Pair
resource "aws_key_pair" "ssh_key" {
  key_name   = var.key_name
 # public_key = var.ssh_public_key  

  lifecycle {
    create_before_destroy = true
  }
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"  
}


# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group for App
resource "aws_security_group" "todo_app" {
  name        = "${var.app_name}-sg"
  description = "Allow SSH, HTTP, HTTPS"
  vpc_id      = data.aws_vpc.default.id

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_key_pair" "ssh_key" {
  key_name = "hng-key"
}


# EC2 Instance for App
resource "aws_instance" "todo_app_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = data.aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.todo_app.id]

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = var.app_name
    App  = var.app_name
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [user_data]
  }
}

# Generate Ansible Inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory_template.tpl", {
    server_ip       = aws_instance.todo_app_server.public_ip
    ssh_key_path    = var.ssh_private_key_path
    domain_name     = var.app_domain
    github_repo_url = var.app_repo_url
  })
  filename = "${path.module}/../ansible/inventory.ini"

  depends_on = [aws_instance.todo_app_server]
}

# Wait for Instance to be ready
resource "null_resource" "wait_for_instance" {
  depends_on = [aws_instance.todo_app_server, local_file.ansible_inventory]

  provisioner "local-exec" {
    command = "sleep 60"
  }

  triggers = {
    instance_id = aws_instance.todo_app_server.id
  }
}

# Run Ansible Playbook
resource "null_resource" "run_ansible" {
  depends_on = [null_resource.wait_for_instance]

  provisioner "local-exec" {
    command = <<-EOT
      cd ${path.module}/../ansible && \
      ansible-playbook -i inventory.ini playbook.yml
    EOT
  }

  triggers = {
    instance_id       = aws_instance.todo_app_server.id
    inventory_content = local_file.ansible_inventory.content
  }
}

# Outputs
output "server_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.todo_app_server.public_ip
}

output "app_domain" {
  description = "Application domain name"
  value       = var.app_domain
}
