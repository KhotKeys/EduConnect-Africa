output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "bastion_public_ip" {
  description = "Public IP of bastion host"
  value       = module.bastion.public_ip
}

output "app_private_ip" {
  description = "Private IP of application server"
  value       = module.app_server.private_ip
}

output "database_endpoint" {
  description = "RDS instance endpoint"
  value       = module.database.endpoint
  sensitive   = true
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}