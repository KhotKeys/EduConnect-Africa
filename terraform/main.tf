terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "EduConnect-Africa"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# VPC and Networking
module "network" {
  source = "./modules/network"
  
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment         = var.environment
  project_name        = var.project_name
}

# Security Groups
module "security" {
  source = "./modules/security"
  
  vpc_id       = module.network.vpc_id
  environment  = var.environment
  project_name = var.project_name
}

# ECR Repository
module "ecr" {
  source = "./modules/ecr"
  
  repository_name = var.ecr_repository_name
  environment     = var.environment
}

# RDS Database
module "database" {
  source = "./modules/database"
  
  vpc_id              = module.network.vpc_id
  private_subnet_ids  = module.network.private_subnet_ids
  db_security_group_id = module.security.db_security_group_id
  
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  environment = var.environment
}

# Bastion Host
module "bastion" {
  source = "./modules/compute"
  
  instance_type        = var.bastion_instance_type
  subnet_id           = module.network.public_subnet_ids[0]
  security_group_ids  = [module.security.bastion_security_group_id]
  key_name            = var.key_pair_name
  
  instance_name = "${var.project_name}-bastion"
  environment   = var.environment
  user_data     = ""
}

# Application Server
module "app_server" {
  source = "./modules/compute"
  
  instance_type       = var.app_instance_type
  subnet_id          = module.network.private_subnet_ids[0]
  security_group_ids = [module.security.app_security_group_id]
  key_name           = var.key_pair_name
  
  instance_name = "${var.project_name}-app"
  environment   = var.environment
  user_data     = templatefile("${path.module}/user_data/app_server.sh", {
    ecr_repo = module.ecr.repository_url
    region   = var.aws_region
  })
}