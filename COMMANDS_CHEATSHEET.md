# Commands Cheat Sheet

## 🚀 Quick Commands Reference

### AWS Setup

```bash
# Configure AWS CLI
aws configure

# Create key pair
aws ec2 create-key-pair --key-name edulearn-key --query 'KeyMaterial' --output text > edulearn-key.pem
chmod 400 edulearn-key.pem

# Create S3 bucket for Terraform state
aws s3 mb s3://edulearn-terraform-state --region us-east-1

# Create DynamoDB table
aws dynamodb create-table \
  --table-name edulearn-terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1

# Verify AWS identity
aws sts get-caller-identity
```

### Terraform Commands

```bash
cd terraform

# Initialize
terraform init

# Format code
terraform fmt -recursive

# Validate configuration
terraform validate

# Plan changes
terraform plan

# Apply changes
terraform apply

# Apply without confirmation
terraform apply -auto-approve

# Show outputs
terraform output

# Show specific output
terraform output ecr_repository_url

# Destroy infrastructure
terraform destroy

# Destroy without confirmation
terraform destroy -auto-approve
```

### Ansible Commands

```bash
cd ansible

# Test connection
ansible all -m ping

# Test specific group
ansible app_servers -m ping

# Run playbook
ansible-playbook deploy.yml

# Run with extra variables
ansible-playbook deploy.yml \
  -e "ecr_repo=123456789.dkr.ecr.us-east-1.amazonaws.com/edulearn" \
  -e "image_tag=latest" \
  -e "aws_region=us-east-1"

# Dry run
ansible-playbook deploy.yml --check

# Verbose output
ansible-playbook deploy.yml -v
ansible-playbook deploy.yml -vv
ansible-playbook deploy.yml -vvv
```

### Docker Commands

```bash
# Build image
docker build -t edulearn:latest .

# Run container locally
docker run -p 80:80 edulearn:latest

# Run with docker-compose
docker-compose up

# Run in background
docker-compose up -d

# View logs
docker-compose logs
docker-compose logs -f

# Stop containers
docker-compose down

# Rebuild and restart
docker-compose up --build -d

# List running containers
docker ps

# Remove all containers
docker-compose down -v
```

### Git Commands

```bash
# Check status
git status

# Add all changes
git add .

# Commit changes
git commit -m "feat: add new feature"

# Push to remote
git push origin main

# Create new branch
git checkout -b feature-name

# Switch branch
git checkout main

# Pull latest changes
git pull origin main

# View commit history
git log --oneline

# Undo last commit (keep changes)
git reset --soft HEAD~1
```

### SSH Commands

```bash
# SSH to bastion
ssh -i edulearn-key.pem ubuntu@<BASTION_IP>

# SSH to app server via bastion
ssh -i edulearn-key.pem -J ubuntu@<BASTION_IP> ubuntu@<APP_PRIVATE_IP>

# Copy file to bastion
scp -i edulearn-key.pem file.txt ubuntu@<BASTION_IP>:~/

# SSH with port forwarding
ssh -i edulearn-key.pem -L 8080:localhost:80 ubuntu@<BASTION_IP>
```

### AWS CLI Commands

```bash
# List EC2 instances
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' --output table

# List ECR repositories
aws ecr describe-repositories

# List ECR images
aws ecr list-images --repository-name edulearn

# Get ECR login
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ECR_REGISTRY>

# List S3 buckets
aws s3 ls

# List RDS instances
aws rds describe-db-instances --query 'DBInstances[*].[DBInstanceIdentifier,DBInstanceStatus,Endpoint.Address]' --output table
```

### Debugging Commands

```bash
# Check Docker logs on server
ssh -J ubuntu@<BASTION_IP> ubuntu@<APP_IP>
cd /opt/edulearn
docker-compose logs -f

# Check system logs
sudo journalctl -u docker -f

# Check disk space
df -h

# Check memory usage
free -h

# Check running processes
ps aux | grep docker

# Test port connectivity
nc -zv <IP> 80

# Check security group rules
aws ec2 describe-security-groups --group-ids <SG_ID>
```

### GitHub Actions Commands

```bash
# Trigger workflow manually (via GitHub CLI)
gh workflow run cd.yml

# List workflow runs
gh run list

# View workflow run
gh run view <RUN_ID>

# Download workflow logs
gh run download <RUN_ID>
```

### NPM Commands

```bash
# Install dependencies
npm install

# Install with lock file
npm ci

# Run linter
npm run lint

# Fix linting issues
npm run lint -- --fix

# Run tests
npm test

# Run tests in watch mode
npm test -- --watch

# Start dev server
npm start
```

### Useful One-Liners

```bash
# Get all Terraform outputs as JSON
terraform output -json > outputs.json

# Format all Terraform files
find . -name "*.tf" -exec terraform fmt {} \;

# Check if port is open
timeout 1 bash -c 'cat < /dev/null > /dev/tcp/<IP>/80' && echo "Port is open" || echo "Port is closed"

# Get public IP
curl ifconfig.me

# Watch Ansible deployment
watch -n 2 'ansible app_servers -m shell -a "docker ps"'

# Tail multiple log files
tail -f /var/log/syslog /var/log/docker.log

# Find large files
find . -type f -size +100M

# Count lines of code
find . -name "*.tf" -o -name "*.yml" | xargs wc -l
```

### Emergency Commands

```bash
# Stop all Docker containers
docker stop $(docker ps -aq)

# Remove all Docker containers
docker rm $(docker ps -aq)

# Remove all Docker images
docker rmi $(docker images -q)

# Terraform force unlock
terraform force-unlock <LOCK_ID>

# Reset Git to last commit
git reset --hard HEAD

# Rollback Terraform to previous state
terraform state pull > backup.tfstate
terraform apply -target=<resource>
```

### Monitoring Commands

```bash
# Watch EC2 instance status
watch -n 5 'aws ec2 describe-instances --instance-ids <INSTANCE_ID> --query "Reservations[0].Instances[0].State.Name"'

# Monitor Docker stats
docker stats

# Monitor system resources
htop

# Check network connections
netstat -tulpn

# Check DNS resolution
nslookup <domain>
dig <domain>
```

## 📝 Common Workflows

### Deploy New Version

```bash
# 1. Make changes
vim frontend/index.html

# 2. Test locally
docker-compose up --build

# 3. Commit and push
git add .
git commit -m "feat: update homepage"
git push origin main

# 4. CD pipeline deploys automatically
```

### Rollback Deployment

```bash
# 1. Find previous image tag
aws ecr describe-images --repository-name edulearn

# 2. Update Ansible to use previous tag
ansible-playbook deploy.yml -e "image_tag=20250120-123456-abc123"
```

### Update Infrastructure

```bash
# 1. Modify Terraform files
vim terraform/main.tf

# 2. Plan changes
terraform plan

# 3. Apply changes
terraform apply

# 4. Update Ansible inventory if IPs changed
vim ansible/inventory/production.ini
```

### Troubleshoot Failed Deployment

```bash
# 1. Check GitHub Actions logs
# Go to Actions tab in GitHub

# 2. SSH to server
ssh -J ubuntu@<BASTION_IP> ubuntu@<APP_IP>

# 3. Check Docker status
docker-compose ps
docker-compose logs

# 4. Check system logs
sudo journalctl -u docker -n 50

# 5. Restart if needed
docker-compose down
docker-compose up -d
```
