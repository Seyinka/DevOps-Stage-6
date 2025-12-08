# AWS region to deploy resources
aws_region = "us-west-1"

# EC2 instance type
instance_type = "t2.small"

# Application domain name
app_domain = "seyitan.mooo.com"

# SSH key paths (these are local paths for Terraform / Ansible)
# The private key path is used by Ansible to connect to the instance
ssh_private_key_path = "/home/seyitan/hng/hng-key.pem"
ssh_public_key_path  = "/home/seyitan/hng/hng-key.pem.pub"

# CIDR block allowed for SSH access
ssh_allowed_cidr = "0.0.0.0/0"

# Application name
app_name = "todo-app"

# Git repository URL for the application
app_repo_url = "https://github.com/Seyinka/DevOps-Stage-6.git"

# AWS key pair name (must exist in your AWS console)
key_name = "hng-key"

# Email for drift detection / alerts
email_alerts = "syinka44@gmail.com"
