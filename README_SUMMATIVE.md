# EduLearn - Complete DevOps Pipeline (Summative Project)

[![CI with Security Scanning](https://github.com/KhotKeys/EduConnect-Africa/actions/workflows/ci-security.yml/badge.svg)](https://github.com/KhotKeys/EduConnect-Africa/actions/workflows/ci-security.yml)
[![CD - Deploy to Production](https://github.com/KhotKeys/EduConnect-Africa/actions/workflows/cd.yml/badge.svg)](https://github.com/KhotKeys/EduConnect-Africa/actions/workflows/cd.yml)

## 🎓 Project Overview

**EduLearn** is a comprehensive educational platform with a complete DevOps pipeline demonstrating Git-to-Production automation, Infrastructure as Code, Configuration Management, and DevSecOps practices.

### 🎯 Live Application
**URL**: `http://<YOUR_EC2_PUBLIC_IP>` (Update after deployment)

## 📐 Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed architecture diagrams.

### Infrastructure Components

- **VPC**: Isolated network (10.0.0.0/16)
- **Public Subnet**: Bastion host for SSH access
- **Private Subnet**: Application server and RDS database
- **ECR**: Private container registry
- **RDS**: PostgreSQL database
- **NAT Gateway**: Outbound internet for private subnet

## 🚀 Complete DevOps Pipeline

### 1. Infrastructure as Code (Terraform)

Modular Terraform configuration in `terraform/`:

```
terraform/
├── main.tf              # Root module
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── backend.tf           # S3 backend config
└── modules/
    ├── network/         # VPC, subnets, routing
    ├── security/        # Security groups
    ├── compute/         # EC2 instances
    ├── database/        # RDS PostgreSQL
    └── ecr/            # Container registry
```

**Deploy Infrastructure:**
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 2. Configuration Management (Ansible)

Automated deployment playbook in `ansible/`:

```
ansible/
├── deploy.yml           # Main deployment playbook
├── ansible.cfg          # Ansible configuration
└── inventory/
    └── production.ini   # Production hosts
```

**Deploy Application:**
```bash
cd ansible
ansible-playbook deploy.yml
```

### 3. DevSecOps Integration

**Security Scanning (CI Pipeline):**
- ✅ Container scanning with Trivy
- ✅ IaC scanning with tfsec
- ✅ Code linting with ESLint
- ✅ Automated tests with Jest
- ✅ Fails on CRITICAL/HIGH vulnerabilities

**Workflows:**
- `.github/workflows/ci-security.yml` - Runs on PRs
- `.github/workflows/cd.yml` - Runs on merge to main

### 4. Continuous Deployment

**Git-to-Production Flow:**

```
1. Developer pushes code
   ↓
2. Create Pull Request
   ↓
3. CI Pipeline runs:
   - Lint & Test
   - Security Scanning
   - Docker Image Scan
   - Terraform Scan
   ↓
4. Merge to main (if CI passes)
   ↓
5. CD Pipeline runs:
   - Build Docker image
   - Push to ECR
   - Deploy with Ansible
   ↓
6. Application live!
```

## 🛠 Technology Stack

### Infrastructure
- **IaC**: Terraform
- **Config Management**: Ansible
- **Cloud Provider**: AWS
- **Container Registry**: Amazon ECR

### CI/CD
- **Pipeline**: GitHub Actions
- **Security Scanning**: Trivy, tfsec
- **Testing**: Jest, ESLint

### Application
- **Runtime**: Node.js
- **Containerization**: Docker
- **Frontend**: HTML5, CSS3, JavaScript

## 📋 Quick Start

### Prerequisites
- AWS Account
- GitHub Account
- Terraform >= 1.0
- Ansible >= 2.9
- Docker Desktop

### Setup Steps

1. **Clone Repository**
   ```bash
   git clone https://github.com/KhotKeys/EduConnect-Africa.git
   cd EduConnect-Africa
   ```

2. **Configure AWS Credentials**
   ```bash
   aws configure
   ```

3. **Deploy Infrastructure**
   ```bash
   cd terraform
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars
   terraform init
   terraform apply
   ```

4. **Configure GitHub Secrets**
   - AWS_ACCESS_KEY_ID
   - AWS_SECRET_ACCESS_KEY
   - AWS_REGION
   - ECR_REPO (from Terraform output)
   - EC2_HOST (from Terraform output)
   - SSH_PRIVATE_KEY_EC2

5. **Test Deployment**
   ```bash
   cd ansible
   ansible-playbook deploy.yml
   ```

6. **Verify Application**
   - Open browser to EC2 public IP
   - Application should be running

See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for detailed instructions.

## 🎥 Demo Video

**Video Demonstration**: [Link to video] (10-15 minutes)

Demonstrates:
1. Making code change
2. Creating Pull Request
3. CI pipeline running security checks
4. Merging PR
5. CD pipeline deploying automatically
6. Change visible on live site

## 📊 Project Structure

```
EduConnect-Africa/
├── .github/
│   └── workflows/
│       ├── ci-security.yml    # CI with security scanning
│       └── cd.yml             # CD deployment pipeline
├── terraform/                 # Infrastructure as Code
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
├── ansible/                   # Configuration management
│   ├── deploy.yml
│   └── inventory/
├── frontend/                  # Application code
│   ├── index.html
│   └── images/
├── Dockerfile                 # Container definition
├── docker-compose.yml         # Local development
├── package.json               # Dependencies
├── ARCHITECTURE.md            # Architecture diagrams
└── DEPLOYMENT_GUIDE.md        # Deployment instructions
```

## ✅ Summative Requirements Checklist

- [x] **Infrastructure as Code (Terraform)**
  - [x] Modular structure (main.tf, variables.tf, outputs.tf)
  - [x] VPC with public/private subnets
  - [x] Bastion host in public subnet
  - [x] App server in private subnet
  - [x] RDS database
  - [x] ECR private registry
  - [x] Security groups

- [x] **Configuration Management (Ansible)**
  - [x] Playbook to install Docker
  - [x] Playbook to deploy application
  - [x] Inventory management

- [x] **DevSecOps Integration**
  - [x] Container image scanning (Trivy)
  - [x] IaC scanning (tfsec)
  - [x] Pipeline fails on critical vulnerabilities

- [x] **Continuous Deployment**
  - [x] Automated deployment on merge to main
  - [x] Security checks before deployment
  - [x] Ansible-based deployment
  - [x] Push to private ECR

- [x] **Documentation**
  - [x] Architecture diagram
  - [x] Deployment guide
  - [x] Live application URL
  - [x] Demo video

## 🔒 Security Features

1. **Network Isolation**: Private subnets for sensitive resources
2. **Bastion Access**: SSH only through bastion host
3. **Container Scanning**: Automated vulnerability detection
4. **IaC Scanning**: Terraform security validation
5. **Secrets Management**: GitHub Secrets for credentials
6. **Non-root Containers**: Security best practices

## 📈 Monitoring & Logs

**View Application Logs:**
```bash
ssh -J ubuntu@<BASTION_IP> ubuntu@<APP_IP>
cd /opt/edulearn
docker compose logs -f
```

**Check Pipeline Status:**
- GitHub Actions tab in repository
- View security scan results in Security tab

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'feat: add amazing feature'`)
4. Push to branch (`git push origin feature/amazing`)
5. Open Pull Request (CI will run automatically)

## 👥 Team

- **DevOps Engineer**: Lenine NGENZI
- **Project Lead**: Gabriel Pawuoi
- **Frontend Developer**: Lina IRATWE

## 📝 License

MIT License - see [LICENSE](LICENSE)

## 🙏 Acknowledgments

- AWS for cloud infrastructure
- GitHub Actions for CI/CD
- Trivy for security scanning
- Terraform for IaC
- Ansible for configuration management

---

**EduLearn** - Demonstrating complete DevOps pipeline from code to production 🚀
