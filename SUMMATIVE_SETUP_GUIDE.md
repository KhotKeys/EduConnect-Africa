# 🎓 SUMMATIVE PROJECT - Complete Setup Guide

## Current Status: 90% Complete ✅

Your project is **code-complete** and you already have a live application at http://16.171.136.183

However, to meet ALL summative requirements, you need to set up the FULL automated pipeline.

---

## 📋 SUMMATIVE REQUIREMENTS CHECKLIST

### ✅ Already Complete:
- [x] Infrastructure as Code (Terraform modules in `terraform/`)
- [x] Configuration Management (Ansible playbooks in `ansible/`)
- [x] DevSecOps Integration (Trivy + tfsec in workflows)
- [x] CI Pipeline (`.github/workflows/ci-security.yml`)
- [x] CD Pipeline (`.github/workflows/cd.yml`)
- [x] Docker containerization
- [x] Complete documentation
- [x] Live application running

### ⏳ Needs Configuration:
- [ ] AWS credentials configured locally
- [ ] Terraform deployed (or verify existing infrastructure)
- [ ] GitHub Secrets configured (6 secrets)
- [ ] Ansible collections installed
- [ ] Full Git-to-Production demo
- [ ] Demo video (10-15 minutes)

---

## 🚀 STEP-BY-STEP SETUP (30 Minutes)

### STEP 1: Configure AWS Credentials (5 minutes)

You need AWS credentials to deploy infrastructure. Two options:

#### Option A: Use Existing AWS Account
```powershell
# Run this command and follow prompts
aws configure

# Enter when prompted:
# AWS Access Key ID: [Get from AWS Console → IAM → Users → Security credentials]
# AWS Secret Access Key: [From same location]
# Default region: eu-north-1  (or us-east-1)
# Default output format: json
```

#### Option B: Create New AWS Account (if needed)
1. Go to https://aws.amazon.com/free/
2. Click "Create a Free Account"
3. Follow registration (requires credit card, but free tier available)
4. After registration:
   - Go to IAM Console: https://console.aws.amazon.com/iam/
   - Click "Users" → "Create user"
   - Username: `edulearn-deployer`
   - Attach policies: `AmazonEC2FullAccess`, `AmazonECRFullAccess`, `AmazonRDSFullAccess`, `AmazonVPCFullAccess`
   - Create access key → Save credentials
   - Run `aws configure` with these credentials

**Verify AWS is configured:**
```powershell
aws sts get-caller-identity
# Should show your AWS account info
```

---

### STEP 2: Fix Ansible PATH (2 minutes)

```powershell
# Close and reopen PowerShell, then test:
ansible --version

# If still not working, use full path:
C:\Users\HP\AppData\Roaming\Python\Python313\Scripts\ansible-galaxy.exe --version
```

**Install Ansible collections:**
```powershell
cd C:\Users\HP\OneDrive\Desktop\EduConnect-Africa-main\ansible

# Use full path if ansible-galaxy not in PATH:
C:\Users\HP\AppData\Roaming\Python\Python313\Scripts\ansible-galaxy.exe collection install -r requirements.yml
```

---

### STEP 3: Deploy Infrastructure with Terraform (10 minutes)

```powershell
cd C:\Users\HP\OneDrive\Desktop\EduConnect-Africa-main\terraform

# Create configuration file
copy terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars (use notepad or VS Code):
# Change these values:
# - aws_region = "eu-north-1"  (or your preferred region)
# - key_pair_name = "edulearn-key"
# - db_password = "YourSecurePassword123!"
```

**Create EC2 Key Pair:**
```powershell
# Create key pair in AWS
aws ec2 create-key-pair --key-name edulearn-key --query 'KeyMaterial' --output text > edulearn-key.pem

# Or use existing key if you already have one
```

**Deploy Infrastructure:**
```powershell
# Initialize Terraform
terraform init

# Preview what will be created
terraform plan

# Deploy (takes 5-10 minutes)
terraform apply -auto-approve

# Save outputs for later
terraform output > outputs.txt
type outputs.txt
```

**Important Outputs to Save:**
- `ecr_repository_url` - For GitHub secret ECR_REPO
- `bastion_public_ip` - For GitHub secret EC2_HOST
- `app_server_private_ip` - For Ansible inventory

---

### STEP 4: Configure GitHub Secrets (5 minutes)

Go to: https://github.com/KhotKeys/EduConnect-Africa/settings/secrets/actions

Click "New repository secret" and add these 6 secrets:

| Secret Name | Value | Where to Get It |
|-------------|-------|-----------------|
| `AWS_ACCESS_KEY_ID` | Your AWS access key | From `aws configure list` or IAM Console |
| `AWS_SECRET_ACCESS_KEY` | Your AWS secret key | From IAM Console (when you created user) |
| `AWS_REGION` | `eu-north-1` | Same region you used in terraform.tfvars |
| `ECR_REPO` | Full ECR URL | From `terraform output ecr_repository_url` |
| `EC2_HOST` | Bastion IP address | From `terraform output bastion_public_ip` |
| `SSH_PRIVATE_KEY_EC2` | Content of .pem file | From `type edulearn-key.pem` |

**To get AWS credentials:**
```powershell
# Get Access Key ID
aws configure get aws_access_key_id

# Secret key is not retrievable - use the one you saved when creating IAM user
# If lost, create new access key in IAM Console
```

---

### STEP 5: Update Ansible Inventory (3 minutes)

```powershell
cd C:\Users\HP\OneDrive\Desktop\EduConnect-Africa-main\ansible

# Edit inventory/production.ini
# Replace placeholders with actual IPs from terraform output
```

Edit `inventory/production.ini`:
```ini
[app_servers]
app-server ansible_host=<APP_SERVER_PRIVATE_IP>

[bastion]
bastion ansible_host=<BASTION_PUBLIC_IP>

[app_servers:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=../terraform/edulearn-key.pem
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q ubuntu@<BASTION_PUBLIC_IP> -i ../terraform/edulearn-key.pem"'
```

---

### STEP 6: Test the Full Pipeline (5 minutes)

#### Test 1: Verify Infrastructure
```powershell
# Check if EC2 instances are running
aws ec2 describe-instances --filters "Name=tag:Project,Values=edulearn" --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' --output table
```

#### Test 2: Test Ansible Connection
```powershell
cd ansible
C:\Users\HP\AppData\Roaming\Python\Python313\Scripts\ansible.exe -i inventory/production.ini app_servers -m ping
```

#### Test 3: Deploy Application
```powershell
cd ansible
C:\Users\HP\AppData\Roaming\Python\Python313\Scripts\ansible-playbook.exe -i inventory/production.ini deploy.yml
```

#### Test 4: Verify Application
```powershell
# Get bastion IP
cd ..\terraform
terraform output bastion_public_ip

# SSH to bastion (replace <BASTION_IP>)
ssh -i edulearn-key.pem ubuntu@<BASTION_IP>

# Once connected, check app
curl http://localhost
exit
```

---

### STEP 7: Test Git-to-Production Workflow (Required for Demo)

This is what you'll record for your video:

```powershell
# 1. Create a test branch
git checkout -b test-pipeline

# 2. Make a visible change
# Edit frontend/index.html - add a comment or change text
echo "<!-- Pipeline Test -->" >> frontend/index.html

# 3. Commit and push
git add .
git commit -m "test: verify automated pipeline"
git push origin test-pipeline

# 4. Go to GitHub and create Pull Request
# URL: https://github.com/KhotKeys/EduConnect-Africa/compare/test-pipeline

# 5. Watch CI pipeline run (should see security scans)

# 6. Merge the PR

# 7. Watch CD pipeline automatically deploy

# 8. Verify change is live at http://16.171.136.183
```

---

## 🎬 DEMO VIDEO REQUIREMENTS (10-15 minutes)

Record your screen showing:

### Part 1: Introduction (2 minutes)
- Show your README.md
- Explain the project purpose
- Show architecture diagram

### Part 2: Infrastructure (3 minutes)
- Show AWS Console with running EC2 instances
- Show ECR with Docker images
- Show RDS database
- Explain the infrastructure

### Part 3: Git-to-Production Demo (5-7 minutes)
- Make a code change (e.g., change button text in frontend/index.html)
- Create Pull Request
- Show CI pipeline running:
  - ESLint checks
  - Jest tests
  - Trivy container scan
  - tfsec infrastructure scan
- Merge PR
- Show CD pipeline running:
  - Docker build
  - Push to ECR
  - Ansible deployment
- Show the change live on your URL

### Part 4: Verification (2-3 minutes)
- SSH to bastion host
- Show Docker containers running
- Show application logs
- Access the live application
- Show the change you made is visible

---

## 📊 VERIFICATION CHECKLIST

Before recording your demo, verify:

```powershell
# 1. AWS configured
aws sts get-caller-identity

# 2. Terraform deployed
cd terraform
terraform output

# 3. GitHub secrets configured
# Go to: https://github.com/KhotKeys/EduConnect-Africa/settings/secrets/actions
# Verify all 6 secrets are present

# 4. Ansible working
cd ..\ansible
C:\Users\HP\AppData\Roaming\Python\Python313\Scripts\ansible.exe --version

# 5. Application accessible
curl http://16.171.136.183
# Or open in browser

# 6. CI/CD workflows valid
# Go to: https://github.com/KhotKeys/EduConnect-Africa/actions
# Check for any errors
```

---

## 🆘 TROUBLESHOOTING

### Issue: "Unable to locate credentials"
**Solution:**
```powershell
aws configure
# Enter your AWS credentials
```

### Issue: "ansible-galaxy not recognized"
**Solution:**
```powershell
# Use full path
C:\Users\HP\AppData\Roaming\Python\Python313\Scripts\ansible-galaxy.exe collection install -r requirements.yml
```

### Issue: "Terraform state locked"
**Solution:**
```powershell
cd terraform
terraform force-unlock <LOCK_ID>
```

### Issue: "GitHub Actions failing"
**Solution:**
1. Check secrets are configured correctly
2. Check workflow files have no syntax errors
3. View logs at: https://github.com/KhotKeys/EduConnect-Africa/actions

### Issue: "Can't SSH to EC2"
**Solution:**
```powershell
# Check security group allows SSH from your IP
aws ec2 describe-security-groups --filters "Name=tag:Project,Values=edulearn"

# Verify key permissions
icacls edulearn-key.pem /inheritance:r /grant:r "%USERNAME%:R"
```

---

## 🎯 QUICK COMMANDS REFERENCE

```powershell
# AWS
aws configure
aws sts get-caller-identity
aws ec2 describe-instances

# Terraform
cd terraform
terraform init
terraform plan
terraform apply
terraform output
terraform destroy  # Only if you want to tear down

# Ansible
cd ansible
C:\Users\HP\AppData\Roaming\Python\Python313\Scripts\ansible-playbook.exe deploy.yml

# Git
git status
git checkout -b feature-branch
git add .
git commit -m "message"
git push origin feature-branch

# Docker
docker ps
docker logs <container-id>
docker-compose up -d
```

---

## 📚 USEFUL LINKS

- **AWS Console**: https://console.aws.amazon.com/
- **GitHub Repository**: https://github.com/KhotKeys/EduConnect-Africa
- **GitHub Actions**: https://github.com/KhotKeys/EduConnect-Africa/actions
- **GitHub Secrets**: https://github.com/KhotKeys/EduConnect-Africa/settings/secrets/actions
- **Live Application**: http://16.171.136.183
- **Terraform Registry**: https://registry.terraform.io/
- **Ansible Galaxy**: https://galaxy.ansible.com/

---

## ✅ FINAL SUBMISSION CHECKLIST

Before submitting:

- [ ] AWS credentials configured and working
- [ ] Terraform infrastructure deployed
- [ ] All 6 GitHub secrets configured
- [ ] Ansible collections installed
- [ ] CI pipeline passing on PRs
- [ ] CD pipeline deploying on merge to main
- [ ] Application accessible at public URL
- [ ] Demo video recorded (10-15 minutes)
- [ ] README.md updated with live URL
- [ ] Architecture diagram included
- [ ] All documentation complete

---

## 🎉 YOU'RE ALMOST DONE!

Your code is 100% complete. You just need to:
1. Configure AWS (5 min)
2. Deploy with Terraform (10 min)
3. Add GitHub secrets (5 min)
4. Test the pipeline (5 min)
5. Record demo video (15 min)

**Total time needed: ~40 minutes**

Good luck! 🚀
