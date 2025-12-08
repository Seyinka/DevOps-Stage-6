# AWS Region to deploy resources
variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-west-1"
}

# EC2 Instance Type
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.small"
}

# AWS Key Pair Name
variable "key_name" {
  description = "AWS key pair name"
  type        = string
}

# Application Name
variable "app_name" {
  description = "Application name"
  type        = string
  default     = "todo-app"
}

# Application Domain
variable "app_domain" {
  description = "Application domain name"
  type        = string
  default     = "seyitan.mooo.com"
}

# SSH Private Key Path
variable "ssh_private_key_path" {
  description = "Path to SSH private key"
  type        = string
  default     = "~/.ssh/id_rsa"
}

# Allowed CIDR for SSH
variable "ssh_allowed_cidr" {
  description = "CIDR allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}

# Application Repository URL
variable "app_repo_url" {
  description = "Git repository URL for the application"
  type        = string
}

# Email for drift detection / alerts
variable "email_alerts" {
  description = "Email for drift detection"
  type        = string
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 20
}

