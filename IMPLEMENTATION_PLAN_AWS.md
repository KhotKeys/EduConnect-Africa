# Implementation Plan — AWS (Guidance Only)

Important: I will NOT create Terraform `.tf`, Ansible `.yml`, `Dockerfile`, `docker-compose.yml`, or GitHub Actions workflow files for you. The content below is a detailed, copy-ready implementation plan and checklist you must use to author those files yourself. I will review any student-authored files you push.

Overview
--------
This document guides you through completing the Summative Project on AWS. It contains:
- Exact resource names and variable names to use in your Terraform files
- IAM permission guidance for CI/CD
- Commands to run locally and in GitHub Actions
- Ansible run instructions and inventory hints
- Validation and demo checklist

Set your choices up-front (replace placeholders before use):
- AWS_REGION: eu-west-1
- APP_NAME: edulearn
- TF_STATE_BUCKET: <your-tf-state-bucket>
- TF_LOCK_TABLE: <your-lock-table>
- SSH_KEY_NAME: <your-ec2-ssh-keypair-name>
- ACCOUNT_ID: <your-aws-account-id>

Recommended Terraform variable names (declare in `variables.tf`)
- region
- vpc_cidr
- public_subnet_cidr
- private_subnet_cidr
- bastion_instance_type
- app_instance_type
- app_ami
- ssh_key_name
- db_engine
- db_username
- db_password  # do NOT commit secrets
- ecr_repo_name

Suggested resource naming convention
- VPC: `${var.app_name}-vpc`
- Public subnet: `${var.app_name}-public-subnet`
- Private subnet: `${var.app_name}-private-subnet`
- Bastion: `${var.app_name}-bastion`
- App instance: `${var.app_name}-app`
- RDS: `${var.app_name}-db`
- ECR repo: `${var.app_name}-repo`

Backend/State (recommended)
- Use an S3 bucket and DynamoDB table for locking:
  - `backend "s3" { bucket = "${TF_STATE_BUCKET}" key = "${APP_NAME}/terraform.tfstate" region = "${AWS_REGION}" }`

Networking & Security (copy to your Terraform module/variables)
- VPC CIDR: 10.0.0.0/16
- Public subnet CIDR: 10.0.1.0/24 (Bastion)
- Private subnet CIDR: 10.0.2.0/24 (App + RDS)
- NAT Gateway in public subnet for private subnet egress

Security Group rules (express as Terraform security_group rules)
- sg-bastion:
  - Inbound: TCP 22 from your office IP only (e.g., 203.0.113.4/32)
  - Outbound: allow all (or restrict to app private subnet)
- sg-app:
  - Inbound: TCP 22 from `sg-bastion`
  - Inbound: TCP 80,443 from ALB or 0.0.0.0/0 if using single public IP (less secure)
  - Outbound: allow required egress (egress to RDS, internet via NAT)
- sg-rds:
  - Inbound: DB port (5432/3306) from `sg-app`

ECR naming
- Repository: `${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}`

Ansible essentials (inventory and playbook notes)
- Inventory: list `app` host(s) using private IP, set `ansible_user` (ubuntu/ec2-user).
- Use `ansible_ssh_common_args` to proxy via bastion:
  `ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q ec2-user@${bastion_public_ip}"'`
- Playbook must perform (idempotent):
  1. Update packages
  2. Install Docker and Docker Compose
  3. Add deploy user to `docker` group
  4. Authenticate to ECR (aws ecr get-login-password)
  5. Pull new image and restart via `docker compose up -d`

Commands you'll run locally (PowerShell / WSL)
- Terraform cycle (in `terraform/`):
  ```powershell
  terraform init
  terraform fmt
  terraform validate
  terraform plan -out=tfplan
  terraform apply tfplan
  ```
- Trivy scan (dockerized):
  ```powershell
  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasecurity/trivy image --severity HIGH,CRITICAL --exit-code 1 edulearn:local
  ```
- tfsec scan:
  ```powershell
  tfsec ./terraform
  ```

AWS CLI ECR auth and push (example)
```powershell
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
docker tag edulearn:local ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:sha-${GITHUB_SHA}
docker push ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:sha-${GITHUB_SHA}
```

CI/CD guidance (what to include in workflows — do NOT paste as full workflow files)
- CI (PRs): lint, tests, build image, Trivy scan, tfsec/checkov on `terraform/`.
- CD (main): run CI checks, build image, tag with SHA, push to ECR, run Ansible playbook to deploy.

IAM minimal permissions for CI user (JSON snippet to create IAM policy)
- Allow ECR actions (GetAuthorizationToken, BatchCheckLayerAvailability, PutImage, InitiateLayerUpload, UploadLayerPart, CompleteLayerUpload)
- Allow S3/GetObject if you read state or artifacts
- If running Terraform from CI, grant limited `ec2`, `rds`, `iam`, `ecr`, `s3`, `dynamodb` as needed (prefer assume-role pattern)

Validation checklist (run after deploy)
- SSH to bastion: `ssh -i key.pem ec2-user@${bastion_public_ip}`
- From bastion, SSH to app private IP and run `docker ps` to confirm container running
- Confirm `curl http://localhost:PORT` from app host returns expected content
- From internet, `curl http://<ALB or public IP>` returns app page

What I will do next
- Review any Terraform, Ansible, Dockerfile, docker-compose, or workflow files you author. Push them to `urgent/summative-delivery` and ping me; I will provide corrections line-by-line.

Good luck — author the IaC and playbooks now, then push; I'll review immediately.
