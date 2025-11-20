# Summative Project Checklist

## ✅ Core Requirements

### 1. Infrastructure as Code (Terraform)
- [x] Modular Terraform configuration (main.tf, variables.tf, outputs.tf)
- [x] VPC with private network
- [x] Virtual Machine in private subnet
- [x] Bastion Host in public subnet
- [x] Managed database (RDS)
- [x] Private container registry (ECR)
- [x] Security Groups configured
- [x] Terraform code in `terraform/` directory

### 2. Configuration Management (Ansible)
- [x] Ansible playbook created (`ansible/deploy.yml`)
- [x] Installs Docker and Docker Compose
- [x] Installs required packages
- [x] Deploys application from ECR
- [x] Inventory file configured

### 3. DevSecOps Integration
- [x] Container image scanning (Trivy)
- [x] IaC scanning (tfsec)
- [x] CI pipeline scans on PRs
- [x] Pipeline fails on critical vulnerabilities
- [x] Security scans in `.github/workflows/ci-security.yml`

### 4. Continuous Deployment Pipeline
- [x] CD workflow triggers on merge to main
- [x] Runs all CI checks before deployment
- [x] Builds and pushes to private ECR
- [x] Authenticates to AWS
- [x] Runs Ansible playbook for deployment
- [x] CD pipeline in `.github/workflows/cd.yml`

### 5. Final Presentation & Evidence
- [ ] Live application accessible via public URL
- [ ] 10-15 minute demo video recorded
  - [ ] Shows code change
  - [ ] Shows PR creation
  - [ ] Shows CI/Security checks running
  - [ ] Shows PR merge
  - [ ] Shows CD pipeline deploying
  - [ ] Shows change live on public URL
- [x] README.md updated with:
  - [x] Architecture diagram
  - [ ] Link to live app
  - [x] Setup instructions

## 📋 Pre-Deployment Checklist

### AWS Setup
- [ ] AWS account created
- [ ] IAM user with appropriate permissions
- [ ] AWS CLI configured locally
- [ ] SSH key pair created in AWS
- [ ] Key pair downloaded and secured

### GitHub Setup
- [ ] Repository created/updated
- [ ] Branch protection rules enabled on main
- [ ] GitHub Secrets configured:
  - [ ] AWS_ACCESS_KEY_ID
  - [ ] AWS_SECRET_ACCESS_KEY
  - [ ] AWS_REGION
  - [ ] ECR_REPO (after Terraform)
  - [ ] EC2_HOST (after Terraform)
  - [ ] SSH_PRIVATE_KEY_EC2

### Local Setup
- [ ] Terraform installed (>= 1.0)
- [ ] Ansible installed (>= 2.9)
- [ ] Docker Desktop installed
- [ ] Git configured
- [ ] Node.js installed (>= 14)

## 🚀 Deployment Steps

### Step 1: Infrastructure
- [ ] Run `scripts/setup-infrastructure.sh`
- [ ] Edit `terraform/terraform.tfvars`
- [ ] Run `terraform apply`
- [ ] Save Terraform outputs
- [ ] Update GitHub secrets with outputs

### Step 2: Ansible Configuration
- [ ] Update `ansible/inventory/production.ini` with IPs
- [ ] Test Ansible connection: `ansible app_servers -m ping`
- [ ] Run initial deployment: `ansible-playbook deploy.yml`

### Step 3: CI/CD Verification
- [ ] Create test branch
- [ ] Make small code change
- [ ] Push and create PR
- [ ] Verify CI pipeline runs
- [ ] Verify security scans pass
- [ ] Merge PR
- [ ] Verify CD pipeline deploys
- [ ] Verify application is live

### Step 4: Demo Video
- [ ] Record screen
- [ ] Show Git-to-Production flow
- [ ] Demonstrate all pipeline stages
- [ ] Show live application
- [ ] Upload video
- [ ] Add link to README

## 📝 Documentation Checklist

- [x] ARCHITECTURE.md created with diagrams
- [x] DEPLOYMENT_GUIDE.md with step-by-step instructions
- [x] README_SUMMATIVE.md with complete overview
- [x] Terraform modules documented
- [x] Ansible playbooks documented
- [ ] Video demo link added
- [ ] Live URL added to README

## 🔍 Testing Checklist

### Infrastructure Testing
- [ ] VPC created successfully
- [ ] Subnets configured correctly
- [ ] Bastion host accessible via SSH
- [ ] App server accessible via bastion
- [ ] RDS database created
- [ ] ECR repository created
- [ ] Security groups allow correct traffic

### Application Testing
- [ ] Docker image builds successfully
- [ ] Container runs locally
- [ ] Application accessible on port 80
- [ ] All pages load correctly
- [ ] No console errors

### CI/CD Testing
- [ ] CI pipeline runs on PR
- [ ] Security scans complete
- [ ] Linting passes
- [ ] Tests pass
- [ ] CD pipeline runs on merge
- [ ] Image pushed to ECR
- [ ] Ansible deployment succeeds
- [ ] Application updates automatically

## 🎥 Video Demo Requirements

Your video must show:
1. ✅ Current state of live application
2. ✅ Making a code change (e.g., button text)
3. ✅ Creating a Pull Request
4. ✅ CI pipeline running (show checks)
5. ✅ Security scans passing
6. ✅ Merging the PR
7. ✅ CD pipeline automatically triggering
8. ✅ Deployment completing
9. ✅ Refreshing browser showing the change live
10. ✅ Brief explanation of the pipeline

## 📤 Submission Checklist

- [ ] All code committed to GitHub
- [ ] README.md updated with live URL
- [ ] Architecture diagram included
- [ ] Demo video recorded and linked
- [ ] All workflows passing
- [ ] Infrastructure deployed and running
- [ ] Application accessible
- [ ] Documentation complete

## 🎯 Success Criteria

- ✅ Terraform provisions complete infrastructure
- ✅ Ansible deploys application successfully
- ✅ CI pipeline includes security scanning
- ✅ CD pipeline deploys on merge to main
- ✅ Git-to-Production flow fully automated
- [ ] Live application accessible
- [ ] Demo video demonstrates complete flow
- ✅ All documentation complete

## 📞 Support

If you encounter issues:
1. Check DEPLOYMENT_GUIDE.md troubleshooting section
2. Review GitHub Actions logs
3. Check AWS CloudWatch logs
4. Verify all secrets are configured correctly
5. Test SSH connectivity to bastion and app server
