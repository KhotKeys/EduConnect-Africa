# EduLearn Deployment Guide

## Prerequisites

- AWS Account with appropriate permissions
- GitHub repository with secrets configured
- AWS CLI installed locally
- Terraform >= 1.0
- Ansible >= 2.9
- SSH key pair created in AWS

## Step 1: Configure GitHub Secrets

Add these secrets in GitHub (Settings → Secrets and variables → Actions):

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
ECR_REPO (will be created by Terraform)
EC2_HOST (will be output by Terraform)
SSH_PRIVATE_KEY_EC2
```

## Step 2: Deploy Infrastructure with Terraform

```bash
cd terraform

# Create terraform.tfvars
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# Initialize Terraform
terraform init

# Plan infrastructure
terraform plan

# Apply infrastructure
terraform apply

# Save outputs
terraform output > ../outputs.txt
```

## Step 3: Update GitHub Secrets with Terraform Outputs

After Terraform completes:

1. Get ECR repository URL:
   ```bash
   terraform output ecr_repository_url
   ```
   Add to GitHub secret: `ECR_REPO`

2. Get bastion public IP:
   ```bash
   terraform output bastion_public_ip
   ```
   Use for SSH access

3. Get app server private IP:
   ```bash
   terraform output app_server_private_ip
   ```
   Update in `ansible/inventory/production.ini`

## Step 4: Configure Ansible Inventory

Edit `ansible/inventory/production.ini`:

```ini
[app_servers]
app-server ansible_host=<APP_SERVER_PRIVATE_IP>

[app_servers:vars]
ansible_user=ubuntu
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q ubuntu@<BASTION_PUBLIC_IP>"'
```

## Step 5: Test Ansible Connection

```bash
cd ansible
ansible app_servers -m ping
```

## Step 6: Initial Manual Deployment

```bash
ansible-playbook deploy.yml \
  -e "ecr_repo=<YOUR_ECR_REPO>" \
  -e "image_tag=latest" \
  -e "aws_region=us-east-1"
```

## Step 7: Push to GitHub and Trigger CI/CD

```bash
git add .
git commit -m "feat: complete summative infrastructure"
git push origin main
```

The CD pipeline will automatically:
1. Run security scans
2. Build Docker image
3. Push to ECR
4. Deploy via Ansible

## Step 8: Verify Deployment

1. Get app server public IP (if assigned) or use bastion to access
2. Open browser: `http://<EC2_PUBLIC_IP>`
3. Verify application is running

## Step 9: Test Git-to-Production Flow

```bash
# Make a small change
echo "<!-- CI/CD Test -->" >> frontend/index.html

# Create feature branch
git checkout -b test-cicd

# Commit and push
git add .
git commit -m "test: verify CI/CD pipeline"
git push origin test-cicd

# Create PR on GitHub
# Watch CI checks run
# Merge PR
# Watch CD deploy automatically
```

## Troubleshooting

### Terraform Issues

**Error: Key pair not found**
```bash
aws ec2 create-key-pair --key-name edulearn-key --query 'KeyMaterial' --output text > edulearn-key.pem
chmod 400 edulearn-key.pem
```

**Error: S3 backend doesn't exist**
```bash
# Create S3 bucket for state
aws s3 mb s3://edulearn-terraform-state --region us-east-1

# Create DynamoDB table for locks
aws dynamodb create-table \
  --table-name edulearn-terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

### Ansible Issues

**SSH Connection Failed**
```bash
# Test bastion connection
ssh -i ~/.ssh/edulearn-key.pem ubuntu@<BASTION_IP>

# Test app server via bastion
ssh -i ~/.ssh/edulearn-key.pem -J ubuntu@<BASTION_IP> ubuntu@<APP_PRIVATE_IP>
```

**Docker Permission Denied**
```bash
# SSH to server and add user to docker group
sudo usermod -aG docker ubuntu
# Logout and login again
```

### CI/CD Issues

**ECR Push Failed**
- Verify AWS credentials in GitHub secrets
- Check IAM permissions for ECR

**Ansible Deploy Failed**
- Verify SSH key in GitHub secrets
- Check security group allows SSH from GitHub Actions IPs

## Cleanup

To destroy all infrastructure:

```bash
cd terraform
terraform destroy
```

## Monitoring

Check application logs:
```bash
ssh -J ubuntu@<BASTION_IP> ubuntu@<APP_PRIVATE_IP>
cd /opt/edulearn
docker compose logs -f
```
