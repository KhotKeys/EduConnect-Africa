# GitHub Issues to Create

Go to: https://github.com/KhotKeys/EduConnect-Africa/issues/new

Create these issues to document your project tasks:

---

## Issue 1: Infrastructure as Code with Terraform
**Title:** Set up Infrastructure as Code with Terraform

**Labels:** `infrastructure`, `terraform`, `devOps`

**Description:**
```
Create modular Terraform configuration to provision AWS infrastructure:

- [x] VPC with public/private subnets
- [x] EC2 instances (bastion + app server)
- [x] RDS PostgreSQL database
- [x] ECR container registry
- [x] Security groups and IAM roles

**Files:**
- terraform/main.tf
- terraform/variables.tf
- terraform/outputs.tf
- terraform/modules/ (network, compute, database, ecr, security)

**Status:** ✅ Complete
```

---

## Issue 2: Configuration Management with Ansible
**Title:** Create Ansible playbook for deployment automation

**Labels:** `ansible`, `configuration`, `devOps`

**Description:**
```
Develop Ansible playbook to automate application deployment:

- [x] Install Docker and Docker Compose
- [x] Configure application environment
- [x] Deploy containerized application
- [x] Zero-downtime updates

**Files:**
- ansible/deploy.yml
- ansible/requirements.yml
- ansible/inventory/

**Status:** ✅ Complete
```

---

## Issue 3: CI Pipeline with Security Scanning
**Title:** Implement CI pipeline with DevSecOps integration

**Labels:** `CI`, `security`, `testing`, `devOps`

**Description:**
```
Create comprehensive CI pipeline with security scanning:

- [x] ESLint code linting
- [x] Jest unit testing
- [x] Trivy container image scanning
- [x] tfsec infrastructure scanning
- [x] Fail on critical vulnerabilities

**Workflow:** .github/workflows/ci-security.yml

**Status:** ✅ Complete - All 4 checks passing
```

---

## Issue 4: CD Pipeline for Automated Deployment
**Title:** Build CD pipeline for production deployment

**Labels:** `CD`, `deployment`, `automation`, `devOps`

**Description:**
```
Automate deployment to production on merge to main:

- [x] Build Docker image
- [x] Push to private ECR registry
- [x] Deploy to EC2 instance
- [x] Health checks and verification

**Workflow:** .github/workflows/cd.yml

**Live URL:** http://16.171.136.183

**Status:** ✅ Complete
```

---

## Issue 5: Docker Containerization
**Title:** Containerize application with Docker

**Labels:** `docker`, `containerization`, `devOps`

**Description:**
```
Create Docker configuration for application:

- [x] Multi-stage Dockerfile
- [x] Docker Compose configuration
- [x] Non-root user for security
- [x] Optimized image size

**Files:**
- Dockerfile
- docker-compose.yml

**Status:** ✅ Complete
```

---

## Issue 6: Documentation and Architecture
**Title:** Complete project documentation

**Labels:** `documentation`

**Description:**
```
Create comprehensive project documentation:

- [x] README.md with live URL
- [x] Architecture diagram
- [x] Deployment guide
- [x] Video recording guide
- [x] Setup instructions

**Status:** ✅ Complete
```

---

## Issue 7: Live Application Deployment
**Title:** Deploy application to AWS EC2

**Labels:** `deployment`, `production`, `AWS`

**Description:**
```
Deploy application to production environment:

- [x] EC2 instance configured
- [x] Application accessible via public URL
- [x] Docker containers running
- [x] ECR integration working

**Live URL:** http://16.171.136.183

**Status:** ✅ Live and Running
```

---

## Issue 8: Git-to-Production Workflow Demo
**Title:** Record video demonstration of Git-to-Production workflow

**Labels:** `documentation`, `demo`

**Description:**
```
Record 10-15 minute video showing:

- [ ] Make code change
- [ ] Create Pull Request
- [ ] CI checks running (all 4 passing)
- [ ] Merge to main
- [ ] CD pipeline deploying
- [ ] Change live on production URL

**Status:** ⏳ In Progress
```

---

## How to Create These Issues:

1. Go to https://github.com/KhotKeys/EduConnect-Africa/issues
2. Click "New issue"
3. Copy the title and description from above
4. Add the labels mentioned
5. Click "Submit new issue"
6. Repeat for all 8 issues

## Quick Labels to Create:

If labels don't exist, create them:
- `infrastructure` (purple)
- `terraform` (blue)
- `ansible` (green)
- `CI` (yellow)
- `CD` (orange)
- `security` (red)
- `testing` (green)
- `devOps` (blue)
- `docker` (blue)
- `documentation` (gray)
- `deployment` (orange)
- `production` (red)
- `AWS` (orange)
- `demo` (purple)

---

**Note:** Issues 1-7 are complete ✅. Only Issue 8 (video) is pending!
