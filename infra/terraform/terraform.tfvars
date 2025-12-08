# AWS region to deploy resources
aws_region = "us-west-1"

# EC2 instance type
instance_type = "t2.small"

# Application domain name
app_domain = "seyitan.mooo.com"

# SSH key paths
ssh_private_key_path = "~/.ssh/todo-app-deployer"
ssh_public_key_path  = "~/.ssh/todo-app-deployer.pub"

# CIDR block allowed for SSH access
ssh_allowed_cidr = "0.0.0.0/0"

# Application name 
app_name = "todo-app"

# Git repository URL for the application
app_repo_url = "https://github.com/Seyinka/DevOps-Stage-6.git"

# AWS key pair name
key_name = "todo-app-deployer"

# Email for drift detection / alerts
email_alerts = "syinka44@gmail.com"
