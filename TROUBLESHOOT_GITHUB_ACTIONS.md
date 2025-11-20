# Troubleshooting GitHub Actions Failures

## Current Status
Your GitHub Actions are failing. Let's fix them step by step.

## Quick Fix: Deploy Without GitHub Actions

While we fix the Actions, deploy directly:

```powershell
# Option 1: Direct deployment (no ECR needed)
.\deploy-direct-to-ec2.ps1

# Option 2: Test locally first
.\test-local-deployment.ps1
```

## Fix GitHub Actions

### Step 1: Verify All 6 Secrets Are Set

Go to: https://github.com/KhotKeys/EduConnect-Africa/settings/secrets/actions

You should see exactly these 6 secrets:

1. **AWS_ACCESS_KEY_ID**
2. **AWS_SECRET_ACCESS_KEY**
3. **AWS_REGION**
4. **ECR_REPO**
5. **EC2_HOST**
6. **SSH_PRIVATE_KEY_EC2**

### Step 2: Get Correct Values

#### AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY

1. Go to AWS Console
2. IAM → Users → changemakers
3. Security credentials tab
4. Click "Create access key"
5. Choose "Command Line Interface (CLI)"
6. Copy both keys
7. Add to GitHub Secrets

#### AWS_REGION

Value: `eu-north-1`

#### ECR_REPO

Format: `ACCOUNT_ID.dkr.ecr.eu-north-1.amazonaws.com/educate-generation`

To get your account ID:
```powershell
aws sts get-caller-identity --query Account --output text
```

Example: `123456789012.dkr.ecr.eu-north-1.amazonaws.com/educate-generation`

#### EC2_HOST

Value: `16.171.136.183`

#### SSH_PRIVATE_KEY_EC2

1. Open `edu-access.pem` file in notepad
2. Copy ENTIRE content including:
   ```
   -----BEGIN RSA PRIVATE KEY-----
   ...all the lines...
   -----END RSA PRIVATE KEY-----
   ```
3. Paste into GitHub Secret

### Step 3: Check EC2 Security Group

Your EC2 must allow:
- Port 22 (SSH) from GitHub Actions IPs
- Port 80 (HTTP) from anywhere

To allow GitHub Actions:
1. Go to EC2 → Security Groups
2. Find security group for edu-server
3. Inbound rules → Edit
4. Add rule: SSH (22) from 0.0.0.0/0 (or specific GitHub IPs)
5. Add rule: HTTP (80) from 0.0.0.0/0

### Step 4: Verify ECR Repository Exists

```powershell
aws ecr describe-repositories --repository-names educate-generation --region eu-north-1
```

If it doesn't exist:
```powershell
aws ecr create-repository --repository-name educate-generation --region eu-north-1
```

### Step 5: Re-run Failed Workflow

1. Go to: https://github.com/KhotKeys/EduConnect-Africa/actions
2. Click on the failed workflow
3. Click "Re-run all jobs"

## Common Errors and Fixes

### Error: "MISSING: AWS_ACCESS_KEY_ID"
**Fix**: Add AWS_ACCESS_KEY_ID secret in GitHub

### Error: "Permission denied (publickey)"
**Fix**: 
- Verify SSH_PRIVATE_KEY_EC2 secret contains full key
- Check EC2 security group allows SSH from 0.0.0.0/0

### Error: "Could not read from remote repository"
**Fix**: Check EC2_HOST is correct IP: 16.171.136.183

### Error: "docker: command not found"
**Fix**: SSH to EC2 and install Docker:
```bash
ssh -i edu-access.pem ubuntu@16.171.136.183
sudo apt update
sudo apt install -y docker.io docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
```

### Error: "ECR login failed"
**Fix**: 
- Verify AWS credentials are correct
- Check ECR_REPO format is correct
- Ensure IAM user has ECR permissions

## Manual Deployment (Bypass GitHub Actions)

If Actions keep failing, deploy manually:

### Method 1: Direct Docker Deployment

```powershell
# Run this script
.\deploy-direct-to-ec2.ps1
```

### Method 2: SSH and Deploy

```powershell
# SSH to EC2
ssh -i edu-access.pem ubuntu@16.171.136.183

# On EC2, run:
sudo apt update
sudo apt install -y docker.io

# Pull your code
git clone https://github.com/KhotKeys/EduConnect-Africa.git
cd EduConnect-Africa

# Build and run
sudo docker build -t edulearn:latest .
sudo docker run -d -p 80:80 --name edulearn --restart unless-stopped edulearn:latest

# Check status
sudo docker ps
```

### Method 3: Use Docker Compose

```powershell
# SSH to EC2
ssh -i edu-access.pem ubuntu@16.171.136.183

# On EC2:
cd EduConnect-Africa
sudo docker compose up -d --build
```

## Verify Deployment

After deployment (manual or automated):

```powershell
# Test from your machine
curl http://16.171.136.183

# Or open browser
start http://16.171.136.183
```

## Debug GitHub Actions

To see detailed error:

1. Go to: https://github.com/KhotKeys/EduConnect-Africa/actions
2. Click on failed workflow run
3. Click on failed job (e.g., "Deploy to EC2 via SSH")
4. Expand each step to see error messages
5. Look for specific error and match to fixes above

## Quick Checklist

- [ ] All 6 GitHub Secrets configured
- [ ] AWS credentials are valid (test with `aws sts get-caller-identity`)
- [ ] ECR repository exists
- [ ] EC2 security group allows SSH (22) and HTTP (80)
- [ ] SSH key file (edu-access.pem) is correct
- [ ] Docker is installed on EC2
- [ ] EC2 instance is running

## Still Not Working?

Use the direct deployment script:

```powershell
.\deploy-direct-to-ec2.ps1
```

This bypasses GitHub Actions and ECR entirely, deploying directly to your EC2 instance.

Your application will be live at: http://16.171.136.183
