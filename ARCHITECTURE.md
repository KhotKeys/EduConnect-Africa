# EduLearn Architecture

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         Internet                                 │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │   Internet Gateway   │
              └──────────┬───────────┘
                         │
        ┌────────────────┴────────────────┐
        │         VPC (10.0.0.0/16)       │
        │                                  │
        │  ┌────────────────────────────┐ │
        │  │  Public Subnet (10.0.1.0/24)│ │
        │  │                             │ │
        │  │  ┌──────────────────────┐  │ │
        │  │  │   Bastion Host       │  │ │
        │  │  │   (SSH Gateway)      │  │ │
        │  │  └──────────┬───────────┘  │ │
        │  └─────────────┼──────────────┘ │
        │                │                 │
        │                │ SSH             │
        │                ▼                 │
        │  ┌────────────────────────────┐ │
        │  │ Private Subnet (10.0.10.0/24)│ │
        │  │                             │ │
        │  │  ┌──────────────────────┐  │ │
        │  │  │  App Server (EC2)    │  │ │
        │  │  │  - Docker            │  │ │
        │  │  │  - EduLearn App      │  │ │
        │  │  └──────────┬───────────┘  │ │
        │  │             │               │ │
        │  │             │               │ │
        │  │             ▼               │ │
        │  │  ┌──────────────────────┐  │ │
        │  │  │  RDS PostgreSQL      │  │ │
        │  │  │  (Private)           │  │ │
        │  │  └──────────────────────┘  │ │
        │  └─────────────────────────────┘ │
        │                                  │
        │  ┌────────────────────────────┐ │
        │  │   NAT Gateway              │ │
        │  └────────────────────────────┘ │
        └──────────────────────────────────┘

┌─────────────────────────────────────────┐
│         AWS ECR                         │
│   (Container Registry)                  │
│   - edulearn:latest                     │
└─────────────────────────────────────────┘
```

## CI/CD Pipeline Flow

```
Developer Push
      │
      ▼
┌─────────────────┐
│  GitHub Repo    │
│  (main branch)  │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│     GitHub Actions CI/CD                │
│                                         │
│  1. Security Scanning                   │
│     - Trivy (Container)                 │
│     - tfsec (Terraform)                 │
│     - ESLint                            │
│                                         │
│  2. Build & Test                        │
│     - npm test                          │
│     - Docker build                      │
│                                         │
│  3. Push to ECR                         │
│     - Tag with timestamp                │
│     - Push :latest                      │
│                                         │
│  4. Deploy with Ansible                 │
│     - SSH via Bastion                   │
│     - Pull new image                    │
│     - docker compose up -d              │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────┐
│  Live App       │
│  http://EC2-IP  │
└─────────────────┘
```

## Security Layers

1. **Network Security**
   - Private subnets for app and database
   - Bastion host for SSH access only
   - Security groups with least privilege

2. **Application Security**
   - Container scanning with Trivy
   - Non-root container user
   - Secrets managed via GitHub Secrets

3. **Infrastructure Security**
   - IaC scanning with tfsec
   - Encrypted RDS storage
   - VPC isolation

## Technology Stack

- **Infrastructure**: Terraform (IaC)
- **Configuration**: Ansible
- **Containerization**: Docker
- **CI/CD**: GitHub Actions
- **Cloud**: AWS (VPC, EC2, RDS, ECR)
- **Security**: Trivy, tfsec
- **Application**: Node.js, HTML/CSS/JS
