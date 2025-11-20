# Manual Deployment Steps (No Terraform Needed)

Since you already have AWS resources set up, follow these simplified steps:

## Prerequisites Checklist

- [x] EC2 instance running: edu-server (16.171.136.183)
- [x] ECR repository: educate-generation
- [x] Key pair: edu-access.pem
- [x] Docker Desktop running on your machine
- [ ] AWS CLI configured
- [ ] GitHub Secrets configured

## Step 1: Configure AWS CLI (5 minutes)

```powershell
# Run this command
aws configure

# You'll be prompted for:
# AWS Access Key ID: [Get from AWS Console → IAM → Users → changemakers → Security credentials → Create access key]
# AWS Secret Access Key: [From the access key you just created]
# Default region name: eu-north-1
# Default output format: json
```

**To create access key:**
1. Go to AWS Console
2. IAM → Users → changemakers
3. Security credentials tab
4. Create access key → CLI
5. Copy both keys

## Step 2: Build and Push Docker Image (10 minutes)

```powershell
# Run the PowerShell script
.\deploy-to-existing-ec2.ps1
```

This will:
- Login to your ECR
- Build Docker image
- Push to ECR repository

## Step 3: Configure GitHub Secrets (5 minutes)

Go to: https://github.com/KhotKeys/EduConnect-Africa/settings/secrets/actions

Click "New repository secret" for each:

| Secret Name | Value | How to Get |
|-------------|-------|------------|
| AWS_ACCESS_KEY_ID | Your access key ID | From Step 1 |
| AWS_SECRET_ACCESS_KEY | Your secret key | From Step 1 |
| AWS_REGION | eu-north-1 | Fixed value |
| ECR_REPO | ACCOUNT_ID.dkr.ecr.eu-north-1.amazonaws.com/educate-generation | From script output |
| EC2_HOST | 16.171.136.183 | Your EC2 IP |
| SSH_PRIVATE_KEY_EC2 | Content of edu-access.pem | Open file, copy all |

## Step 4: Deploy to EC2 Manually (10 minutes)

### Option A: SSH and Deploy Manually

```powershell
# SSH to your EC2 instance
ssh -i edu-access.pem ubuntu@16.171.136.183

# On the EC2 instance, run:
sudo apt update
sudo apt install -y docker.io docker-compose-plugin awscli

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

# Login to ECR (replace ACCOUNT_ID)
aws ecr get-login-password --region eu-north-1 | sudo docker login --username AWS --password-stdin ACCOUNT_ID.dkr.ecr.eu-north-1.amazonaws.com

# Create app directory
sudo mkdir -p /opt/edulearn
cd /opt/edulearn

# Create docker-compose.yml
sudo tee docker-compose.yml > /dev/null <<EOF
version: '3.8'
services:
  app:
    image: ACCOUNT_ID.dkr.ecr.eu-north-1.amazonaws.com/educate-generation:latest
    ports:
      - "80:80"
    environment:
      - NODE_ENV=production
    restart: unless-stopped
EOF

# Pull and run
sudo docker compose pull
sudo docker compose up -d

# Check status
sudo docker compose ps
sudo docker compose logs
```

### Option B: Use Ansible (if installed)

```powershell
cd ansible
ansible-playbook deploy.yml -i inventory/production.ini
```

## Step 5: Verify Deployment (2 minutes)

Open browser: http://16.171.136.183

You should see the EduLearn application!

## Step 6: Fix GitHub Actions (5 minutes)

After adding GitHub secrets:

1. Go to: https://github.com/KhotKeys/EduConnect-Africa/actions
2. Click on failed workflow
3. Click "Re-run all jobs"

The workflows should now pass!

## Step 7: Test CI/CD Pipeline (10 minutes)

```powershell
# Make a small change
echo "<!-- Test CI/CD -->" >> frontend/index.html

# Create branch
git checkout -b test-deployment
git add .
git commit -m "test: verify deployment pipeline"
git push origin test-deployment

# Create PR on GitHub
# Merge PR
# Watch CD pipeline deploy automatically
```

## Troubleshooting

### AWS CLI not configured
```powershell
aws configure
# Enter your credentials
```

### Docker not running
- Open Docker Desktop
- Wait for it to start
- Try again

### ECR login fails
```powershell
# Get your account ID
aws sts get-caller-identity

# Login manually
aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin ACCOUNT_ID.dkr.ecr.eu-north-1.amazonaws.com
```

### SSH connection fails
```powershell
# Check security group allows SSH (port 22)
# Check key file permissions
icacls edu-access.pem /inheritance:r
icacls edu-access.pem /grant:r "%USERNAME%:R"
```

### Application not accessible
```powershell
# SSH to EC2
ssh -i edu-access.pem ubuntu@16.171.136.183

# Check Docker
sudo docker ps
sudo docker compose logs

# Check if port 80 is open in security group
```

## Quick Commands Reference

```powershell
# Check AWS configuration
aws sts get-caller-identity

# Build and push image
.\deploy-to-existing-ec2.ps1

# SSH to EC2
ssh -i edu-access.pem ubuntu@16.171.136.183

# Check application logs
ssh -i edu-access.pem ubuntu@16.171.136.183 "cd /opt/edulearn && sudo docker compose logs"

# Restart application
ssh -i edu-access.pem ubuntu@16.171.136.183 "cd /opt/edulearn && sudo docker compose restart"
```

## Success Criteria

- [ ] Docker image in ECR
- [ ] Application running on EC2
- [ ] Accessible at http://16.171.136.183
- [ ] GitHub Actions passing
- [ ] CI/CD pipeline working

## Estimated Time

- Total: 45 minutes
- AWS setup: 5 min
- Docker build/push: 10 min
- GitHub secrets: 5 min
- EC2 deployment: 10 min
- Verification: 5 min
- CI/CD test: 10 min
