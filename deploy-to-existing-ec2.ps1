# PowerShell deployment script for existing EC2 instance

$ErrorActionPreference = "Stop"

Write-Host "🚀 EduLearn Deployment to Existing EC2" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green

# Variables
$AWS_REGION = "eu-north-1"
$ECR_REPO = "educate-generation"
$EC2_IP = "16.171.136.183"

# Check AWS CLI
if (!(Get-Command aws -ErrorAction SilentlyContinue)) {
    Write-Host "❌ AWS CLI not found. Please install it first." -ForegroundColor Red
    exit 1
}

# Check Docker
if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker not found. Please ensure Docker Desktop is running." -ForegroundColor Red
    exit 1
}

Write-Host "`n✅ Prerequisites check passed" -ForegroundColor Green

# Get AWS Account ID
Write-Host "`n📋 Getting AWS Account ID..." -ForegroundColor Cyan
$AWS_ACCOUNT_ID = (aws sts get-caller-identity --query Account --output text)
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to get AWS account ID. Please run 'aws configure' first." -ForegroundColor Red
    exit 1
}
Write-Host "Account ID: $AWS_ACCOUNT_ID" -ForegroundColor Green

$ECR_URI = "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO"

# Login to ECR
Write-Host "`n🔐 Logging into ECR..." -ForegroundColor Cyan
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ ECR login failed" -ForegroundColor Red
    exit 1
}

# Build Docker image
Write-Host "`n🏗️  Building Docker image..." -ForegroundColor Cyan
docker build -t "${ECR_REPO}:latest" .
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Docker build failed" -ForegroundColor Red
    exit 1
}

# Tag image
Write-Host "`n🏷️  Tagging image..." -ForegroundColor Cyan
docker tag "${ECR_REPO}:latest" "${ECR_URI}:latest"

# Push to ECR
Write-Host "`n📤 Pushing to ECR..." -ForegroundColor Cyan
docker push "${ECR_URI}:latest"
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Push to ECR failed" -ForegroundColor Red
    exit 1
}

Write-Host "`n✅ Docker image pushed successfully!" -ForegroundColor Green
Write-Host "ECR URI: ${ECR_URI}:latest" -ForegroundColor Yellow

Write-Host "`n📝 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Add GitHub Secrets:" -ForegroundColor White
Write-Host "   - AWS_ACCESS_KEY_ID" -ForegroundColor Gray
Write-Host "   - AWS_SECRET_ACCESS_KEY" -ForegroundColor Gray
Write-Host "   - AWS_REGION = $AWS_REGION" -ForegroundColor Gray
Write-Host "   - ECR_REPO = $ECR_URI" -ForegroundColor Gray
Write-Host "   - EC2_HOST = $EC2_IP" -ForegroundColor Gray
Write-Host "   - SSH_PRIVATE_KEY_EC2 = (content of edu-access.pem)" -ForegroundColor Gray

Write-Host "`n2. SSH to EC2 and deploy:" -ForegroundColor White
Write-Host "   ssh -i edu-access.pem ubuntu@$EC2_IP" -ForegroundColor Gray
Write-Host "   # Then run deployment commands" -ForegroundColor Gray

Write-Host "`n3. Or use Ansible (if installed):" -ForegroundColor White
Write-Host "   cd ansible" -ForegroundColor Gray
Write-Host "   ansible-playbook deploy.yml" -ForegroundColor Gray

Write-Host "`n🎉 Image is ready in ECR!" -ForegroundColor Green
