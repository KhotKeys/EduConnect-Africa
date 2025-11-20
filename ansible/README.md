# Ansible Deployment for EduConnect

This directory contains Ansible playbooks for deploying the EduConnect application to AWS EC2.

## Prerequisites

- Ansible installed: `pip install ansible`
- AWS CLI configured with appropriate permissions
- EC2 instance running Ubuntu 20.04/22.04
- SSH key pair for EC2 access
- Docker image pushed to ECR

## Setup Instructions

### 1. Install Ansible Collections
```bash
ansible-galaxy collection install -r requirements.yml
```

### 2. Configure Environment Variables
Set these environment variables or create a `.env` file:
```bash
export EC2_HOST="your-ec2-public-ip"
export ECR_REPO="123456789012.dkr.ecr.us-east-1.amazonaws.com/educonnect"
export AWS_REGION="us-east-1"
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
```

### 3. Prepare SSH Key
Ensure your EC2 SSH private key is at `~/.ssh/educonnect-key.pem` with correct permissions:
```bash
chmod 600 ~/.ssh/educonnect-key.pem
```

## Deployment Options

### Option 1: Using Dynamic Inventory (Recommended)
```bash
ansible-playbook -i inventory/dynamic_hosts.py deploy.yml
```

### Option 2: Using Static Inventory
1. Update `inventory/hosts.ini` with your actual values
2. Run: `ansible-playbook -i inventory/hosts.ini deploy.yml`

## What the Playbook Does

1. Installs Docker and AWS CLI on EC2
2. Configures Docker daemon
3. Authenticates with ECR
4. Pulls the latest Docker image
5. Deploys using docker-compose
6. Configures auto-restart policies

## Troubleshooting

- **SSH Connection Issues**: Verify EC2 security groups allow SSH (port 22)
- **Docker Permission Issues**: The playbook adds ubuntu user to docker group
- **ECR Authentication**: Ensure AWS credentials have ECR permissions
- **Port Access**: Verify security groups allow HTTP (port 80)

## Variables

- `ecr_repo`: ECR repository URL
- `image_tag`: Docker image tag (default: latest)
- `aws_region`: AWS region
- `app_dir`: Application directory on EC2 (default: /opt/app)