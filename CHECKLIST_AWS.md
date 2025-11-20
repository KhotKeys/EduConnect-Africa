# CHECKLIST — AWS Summative Delivery (Quick)

Follow these steps in order; check them off as you complete them.

1) Prepare repo & branch
- [ ] Create emergency branch: `git checkout -b urgent/summative-delivery`
- [ ] Commit current work and push

2) Local tool install
- [ ] Install Terraform, Docker, AWS CLI, Trivy, tfsec (or use Docker images)

3) Terraform (author files)
- [ ] `terraform/providers.tf` (AWS provider + backend S3 if used)
- [ ] `terraform/variables.tf` (declare variables)
- [ ] `terraform/main.tf` (modules/resource blocks)
- [ ] `terraform/outputs.tf` (bastion_public_ip, app_private_ip, rds_endpoint, ecr_repo_url)
- [ ] `terraform/terraform.tfvars` (local values; gitignored)

4) Minimal local validation
- [ ] `terraform init` (in terraform/)
- [ ] `terraform fmt` and `terraform validate`
- [ ] `terraform plan -out=tfplan` (resolve errors)

5) Build & scan image locally
- [ ] `docker build -t edulearn:local .`
- [ ] `docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasecurity/trivy image --severity HIGH,CRITICAL --exit-code 1 edulearn:local`

6) Ansible (author files)
- [ ] `ansible/inventory` (with ansible_ssh_common_args for bastion)
- [ ] `ansible/playbook.yml` (install Docker, login to ECR, pull image, run `docker compose up -d`)

7) GitHub Secrets (configure)
- [ ] `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
- [ ] `AWS_REGION`
- [ ] `ECR_REPO` (full ECR URI)
- [ ] `SSH_PRIVATE_KEY` (used by Actions to SSH to bastion)
- [ ] `DB_PASSWORD` (if needed)

8) CI checks (author workflow)
- [ ] Lint & unit tests
- [ ] Build image (no push on PR)
- [ ] Trivy scan (fail on HIGH/CRITICAL)
- [ ] tfsec / checkov against `terraform/`

9) CD workflow (author workflow to run on `main`)
- [ ] Re-run CI checks
- [ ] Build & tag image with `${{ github.sha }}`
- [ ] Authenticate to ECR and push image
- [ ] Run Ansible playbook (use SSH via bastion)
- [ ] Validate deployed app URL

10) Demo & recording
- [ ] Show live app
- [ ] Make small change, create PR, show CI running
- [ ] Merge PR to `main`, show CD running
- [ ] Show the app updated live

When ready: push your authored files to `urgent/summative-delivery` and ping me. I will review and provide line-by-line edits or security fixes.
