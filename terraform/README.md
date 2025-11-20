# Terraform Directory (Placeholders)

This `terraform/` directory is the required location for your Infrastructure-as-Code files for the Summative Project.

Requirements (student-authored — do NOT paste AI-generated `.tf` files):

- Modular Terraform config: `main.tf`, `variables.tf`, `outputs.tf`, plus any modules under `modules/`.
- Provision the following resources in your chosen cloud provider (AWS or Azure):
  - VPC / VNet with public and private subnets
  - Bastion host in public subnet
  - VM in private subnet for the application
  - Managed database (RDS / Azure DB)
  - Private container registry (ECR / ACR)
  - Security groups / NSGs to secure traffic

Place your Terraform files here when you are ready. For academic integrity, the actual `.tf` files must be authored by students.
