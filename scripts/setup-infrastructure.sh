#!/bin/bash
set -e

echo "🚀 EduLearn Infrastructure Setup"
echo "================================"

command -v terraform >/dev/null 2>&1 || { echo "❌ Terraform not installed"; exit 1; }
command -v ansible >/dev/null 2>&1 || { echo "❌ Ansible not installed"; exit 1; }
command -v aws >/dev/null 2>&1 || { echo "❌ AWS CLI not installed"; exit 1; }

echo "✅ Prerequisites check passed"

echo ""
echo "📦 Creating S3 bucket for Terraform state..."
aws s3 mb s3://edulearn-terraform-state --region us-east-1 2>/dev/null || echo "Bucket already exists"

echo "🔒 Creating DynamoDB table for state locking..."
aws dynamodb create-table \
  --table-name edulearn-terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1 2>/dev/null || echo "Table already exists"

echo ""
echo "🏗️  Initializing Terraform..."
cd terraform
terraform init

if [ ! -f terraform.tfvars ]; then
  echo "📝 Creating terraform.tfvars..."
  cp terraform.tfvars.example terraform.tfvars
  echo "⚠️  Please edit terraform/terraform.tfvars with your values"
  exit 0
fi

echo ""
echo "📋 Planning infrastructure..."
terraform plan -out=tfplan

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Review the plan above"
echo "2. Run: cd terraform && terraform apply tfplan"
echo "3. Save outputs: terraform output > ../outputs.txt"
echo "4. Update GitHub secrets with Terraform outputs"
echo "5. Update ansible/inventory/production.ini with IPs"
