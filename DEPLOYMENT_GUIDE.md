# EduConnect Deployment Guide

## Overview
This guide provides step-by-step instructions for deploying EduConnect to AWS using Terraform, GitHub Actions, and Ansible.

## Prerequisites Setup

### 1. AWS Account Setup
1. **Create AWS Account**: Go to https://aws.amazon.com/
2. **Create IAM User**:
   - Navigate to IAM Console → Users → Create User
   - Attach policies: `AmazonEC2FullAccess`, `AmazonECRFullAccess`, `IAMFullAccess`
   - Create access keys and save them securely

### 2. Terraform Setup
1. **Install Terraform**: https://terraform.io/downloads
2. **Navigate to terraform directory**: `cd terraform/`
3. **Configure variables**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```
4. **Deploy infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

### 3. GitHub Repository Secrets
Navigate to your GitHub repository → Settings → Secrets and variables → Actions

Add these secrets:
- `AWS_ACCESS_KEY_ID`: Your IAM user access key
- `AWS_SECRET_ACCESS_KEY`: Your IAM user secret key
- `AWS_REGION`: e.g., `us-east-1`
- `ECR_REPO`: Format: `123456789012.dkr.ecr.us-east-1.amazonaws.com/educonnect`
- `EC2_HOST`: Your EC2 public IP address
- `SSH_PRIVATE_KEY_EC2`: Content of your EC2 private key file

## Deployment Process

### Method 1: Automated (GitHub Actions)
1. Push code to `main` branch
2. GitHub Actions will automatically:
   - Build Docker image
   - Push to ECR
   - Deploy to EC2

### Method 2: Manual (Ansible)
1. **Install Ansible**:
   ```bash
   pip install ansible
   cd ansible/
   ansible-galaxy collection install -r requirements.yml
   ```

2. **Set environment variables**:
   ```bash
   export EC2_HOST="your-ec2-ip"
   export ECR_REPO="your-ecr-repo-url"
   export AWS_REGION="us-east-1"
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   ```

3. **Deploy**:
   ```bash
   ansible-playbook -i inventory/dynamic_hosts.py deploy.yml
   ```

## Navigation Links

### AWS Console Links
- **EC2 Dashboard**: https://console.aws.amazon.com/ec2/
- **ECR Repositories**: https://console.aws.amazon.com/ecr/repositories
- **IAM Users**: https://console.aws.amazon.com/iam/home#/users
- **CloudFormation**: https://console.aws.amazon.com/cloudformation/

### Terraform Cloud (Optional)
- **Sign up**: https://app.terraform.io/signup
- **Connect to GitHub**: Use VCS workflow for automated Terraform runs

### Ansible Resources
- **Ansible Galaxy**: https://galaxy.ansible.com/
- **AWS Collection**: https://galaxy.ansible.com/amazon/aws
- **Docker Collection**: https://galaxy.ansible.com/community/docker

## Verification Steps

1. **Check EC2 Instance**: Ensure it's running in AWS Console
2. **Verify ECR Image**: Check if Docker image was pushed successfully
3. **Test Application**: Access your application at `http://your-ec2-ip`
4. **Check Logs**: SSH to EC2 and run `docker logs <container-name>`

## Troubleshooting

### Common Issues
1. **SSH Connection Failed**: Check security groups allow port 22
2. **Application Not Accessible**: Check security groups allow port 80
3. **ECR Authentication Failed**: Verify AWS credentials and ECR permissions
4. **Docker Build Failed**: Check Dockerfile syntax and dependencies

### Useful Commands
```bash
# SSH to EC2
ssh -i ~/.ssh/educonnect-key.pem ubuntu@your-ec2-ip

# Check running containers
docker ps

# View application logs
docker logs educonnect-app

# Restart application
docker-compose down && docker-compose up -d
```

## Security Best Practices

1. **Rotate AWS Keys**: Regularly rotate IAM access keys
2. **Use IAM Roles**: Consider using IAM roles instead of access keys
3. **Secure SSH Keys**: Keep SSH private keys secure and use proper permissions
4. **Update Security Groups**: Only allow necessary ports and IP ranges
5. **Enable CloudTrail**: Monitor AWS API calls for security auditing

## Cost Optimization

1. **Use t3.micro**: For development/testing (eligible for free tier)
2. **Stop Instances**: Stop EC2 instances when not in use
3. **Monitor Costs**: Set up AWS billing alerts
4. **Clean Up**: Remove unused resources with `terraform destroy`