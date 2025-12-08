# EC2 instance ID
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.todo_app_server.id
}

# EC2 instance public IP
output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.todo_app_server.public_ip
}

# EC2 instance public DNS
output "instance_public_dns" {
  description = "Public DNS name of EC2 instance"
  value       = aws_instance.todo_app_server.public_dns
}

# Security group ID
output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.todo_app.id
}

# Application URL
output "application_url" {
  description = "Application URL"
  value       = "https://${var.app_domain}"
}
