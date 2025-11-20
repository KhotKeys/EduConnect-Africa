# Deployment with Your Existing AWS Resources

## Your AWS Resources

- **ECR Repository**: educate-generation
- **IAM User**: changemakers
- **IAM Role**: impact-onwards
- **EC2 Instance**: edu-server
- **Key Pair**: edu-access
- **Public IP**: 16.171.136.183

## Step 1: Configure AWS CLI Locally

```bash
aws configure
```

Enter your AWS credentials (get from AWS Console → IAM → Security Credentials):
- AWS Access Key ID: [Create new access key in IAM]
- AWS Secret Access Key: [From new access key]
- Default region: eu-north-1 (based on your IP)
- Default output format: json

## Step 2: Update Terraform to Use Existing Resources

Since you already have AWS resources, we'll skip Terraform and deploy directly to your existing EC2 instance.

## Step 3: Update Ansible Inventory

Edit `ansible/inventory/production.ini`:

```ini
[app_servers]
edu-server ansible_host=16.171.136.183

[app_servers:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/edu-access.pem
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

## Step 4: Configure GitHub Secrets

Go to: https://github.com/KhotKeys/EduConnect-Africa/settings/secrets/actions

Add these secrets:

1. **AWS_ACCESS_KEY_ID** - From IAM user "changemakers"
2. **AWS_SECRET_ACCESS_KEY** - From IAM user "changemakers"
3. **AWS_REGION** - eu-north-1
4. **ECR_REPO** - Full ECR URI (e.g., 123456789.dkr.ecr.eu-north-1.amazonaws.com/educate-generation)
5. **EC2_HOST** - 16.171.136.183
6. **SSH_PRIVATE_KEY_EC2** - Content of edu-access.pem file

## Step 5: Build and Push Docker Image to ECR

```bash
# Get your AWS account ID
aws sts get-caller-identity --query Account --output text

# Set variables
AWS_ACCOUNT_ID=<your-account-id>
AWS_REGION=eu-north-1
ECR_REPO=educate-generation

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Build image
docker build -t $ECR_REPO:latest .

# Tag image
docker tag $ECR_REPO:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest

# Push to ECR
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
```

## Step 6: Deploy to EC2 with Ansible

```bash
cd ansible

# Test connection
ansible app_servers -m ping -i inventory/production.ini

# Deploy
ansible-playbook deploy.yml -i inventory/production.ini \
  -e "ecr_repo=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO" \
  -e "image_tag=latest" \
  -e "aws_region=$AWS_REGION"
```

## Step 7: Verify Deployment

```bash
# SSH to server
ssh -i ~/edu-access.pem ubuntu@16.171.136.183

# Check Docker
docker ps

# Check application
curl http://localhost
```

Open browser: http://16.171.136.183

## Fix GitHub Actions Failures

The actions are failing because GitHub secrets are not configured. After adding the 6 secrets above, re-run the failed workflows.

## Quick Deploy Script

Save this as `deploy.sh`:

```bash
#!/bin/bash
set -e

# Variables
AWS_REGION=eu-north-1
ECR_REPO=educate-generation
EC2_IP=16.171.136.183

# Get AWS account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO"

echo "Building and pushing Docker image..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
docker build -t $ECR_REPO:latest .
docker tag $ECR_REPO:latest $ECR_URI:latest
docker push $ECR_URI:latest

echo "Deploying to EC2..."
cd ansible
ansible-playbook deploy.yml -i inventory/production.ini \
  -e "ecr_repo=$ECR_URI" \
  -e "image_tag=latest" \
  -e "aws_region=$AWS_REGION"

echo "Deployment complete! Visit http://$EC2_IP"
```

Run: `bash deploy.sh`
