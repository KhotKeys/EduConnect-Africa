# Quick Start Guide

## 🚀 Deploy in 5 Steps

### Step 1: Prerequisites (5 minutes)

Install required tools:
```bash
# Terraform
https://www.terraform.io/downloads

# Ansible
pip install ansible

# AWS CLI
https://aws.amazon.com/cli/
```

### Step 2: AWS Setup (10 minutes)

```bash
# Configure AWS CLI
aws configure

# Create key pair
aws ec2 create-key-pair --key-name edulearn-key --query 'KeyMaterial' --output text > edulearn-key.pem
chmod 400 edulearn-key.pem

# Create S3 bucket for Terraform state
aws s3 mb s3://edulearn-terraform-state --region us-east-1

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name edulearn-terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

### Step 3: Deploy Infrastructure (15 minutes)

```bash
cd terraform

# Create config file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars - set:
# - key_pair_name = "edulearn-key"
# - db_password = "YourSecurePassword123!"

# Deploy
terraform init
terraform plan
terraform apply -auto-approve

# Save outputs
terraform output > ../outputs.txt
cat ../outputs.txt
```

### Step 4: Configure GitHub Secrets (5 minutes)

Go to GitHub repo → Settings → Secrets and variables → Actions

Add these secrets:
- `AWS_ACCESS_KEY_ID` - Your AWS access key
- `AWS_SECRET_ACCESS_KEY` - Your AWS secret key
- `AWS_REGION` - us-east-1
- `ECR_REPO` - Copy from Terraform output: `ecr_repository_url`
- `EC2_HOST` - Copy from Terraform output: `bastion_public_ip`
- `SSH_PRIVATE_KEY_EC2` - Content of edulearn-key.pem file

### Step 5: Deploy Application (10 minutes)

```bash
# Update Ansible inventory
cd ansible
nano inventory/production.ini

# Replace:
# - YOUR_EC2_PRIVATE_IP with app_server_private_ip from Terraform output
# - YOUR_BASTION_IP with bastion_public_ip from Terraform output

# Test connection
ansible app_servers -m ping

# Deploy
ansible-playbook deploy.yml \
  -e "ecr_repo=<YOUR_ECR_REPO>" \
  -e "image_tag=latest" \
  -e "aws_region=us-east-1"
```

## ✅ Verify Deployment

```bash
# Get bastion IP
terraform output bastion_public_ip

# SSH to bastion
ssh -i edulearn-key.pem ubuntu@<BASTION_IP>

# From bastion, check app server
ssh ubuntu@<APP_PRIVATE_IP>
cd /opt/edulearn
docker compose ps
```

Open browser: `http://<BASTION_IP>` (or configure load balancer)

## 🔄 Test CI/CD Pipeline

```bash
# Make a change
echo "<!-- Test CI/CD -->" >> frontend/index.html

# Create branch and push
git checkout -b test-cicd
git add .
git commit -m "test: verify CI/CD pipeline"
git push origin test-cicd

# Create PR on GitHub
# Watch CI run
# Merge PR
# Watch CD deploy automatically
```

## 🎥 Record Demo Video

Record your screen showing:
1. Current live application
2. Make code change (e.g., edit button text)
3. Create Pull Request
4. Show CI pipeline running (security scans)
5. Merge PR
6. Show CD pipeline deploying
7. Refresh browser - see change live

## 🧹 Cleanup

```bash
cd terraform
terraform destroy -auto-approve

aws s3 rb s3://edulearn-terraform-state --force
aws dynamodb delete-table --table-name edulearn-terraform-locks
```

## 📞 Troubleshooting

**Terraform fails:**
- Check AWS credentials: `aws sts get-caller-identity`
- Verify key pair exists: `aws ec2 describe-key-pairs`

**Ansible connection fails:**
- Test bastion SSH: `ssh -i edulearn-key.pem ubuntu@<BASTION_IP>`
- Check security groups allow SSH

**CI/CD fails:**
- Verify all GitHub secrets are set
- Check Actions logs for specific errors
- Ensure ECR repository exists

**Application not accessible:**
- Check security group allows port 80
- Verify Docker container is running: `docker compose ps`
- Check logs: `docker compose logs`

## 📚 Full Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) - System architecture
- [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Detailed deployment
- [SUMMATIVE_CHECKLIST.md](SUMMATIVE_CHECKLIST.md) - Project checklist
- [README_SUMMATIVE.md](README_SUMMATIVE.md) - Complete overview
