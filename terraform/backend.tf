terraform {
  backend "s3" {
    bucket         = "edulearn-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "edulearn-terraform-locks"
  }
}
