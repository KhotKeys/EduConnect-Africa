# URGENT RUNBOOK — Finish Summative Project (Night-before Delivery)

Purpose
-------
This runbook gives a prioritized, copy-paste list of actions to finish the summative project before the deadline. It avoids creating course-prohibited DevOps config files for you, but gives exact commands, checks, and a tight sequence to follow.

Before you start
- Confirm which cloud provider you'll use (AWS or Azure).
- Make sure you (or a team member) have credentials ready for the cloud and GitHub repository admin access.

1) Create an emergency branch and snapshot work (5 minutes)

```powershell
git checkout -b urgent/summative-delivery
git add -A
git commit -m "WIP: emergency delivery checkpoint"
git push -u origin urgent/summative-delivery
```

2) Install essential tools (10–20 minutes)
- On Windows (PowerShell as Admin) — use Chocolatey (or install tools manually):

```powershell
# Install Chocolatey (if missing)
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install required tools
choco install -y git terraform awscli az docker-desktop wget
```

Notes:
- Ansible runs best from Linux or WSL; if you are on Windows, open WSL (Ubuntu) and `sudo apt update; sudo apt install -y ansible python3-pip`.

3) Author the minimum required files (HIGH PRIORITY)
You must author these yourself (course rules). Create placeholder files now so the repo structure is complete and you can iterate quickly:

- `terraform/main.tf`, `terraform/variables.tf`, `terraform/outputs.tf` (minimal resources and variables)
- `ansible/deploy.yml`, `ansible/inventory.ini` (playbook outline and inventory)
- `Dockerfile` and `docker-compose.yml` at repo root
- `.github/workflows/ci.yml` and `.github/workflows/cd.yml` (workflow skeletons)

Action: create the files with minimal content (comments and TODOs) — then commit. This shows structure and lets you run local checks.

4) Quick local checks and scans (20–30 minutes)

- Build Docker image locally (adjust path/tag):

```powershell
# From repo root
docker build -t edulearn:local .
```

- Scan with Trivy (dockerized) to catch high/critical issues quickly:

```powershell
# Pull & run trivy to scan the local image (fails if HIGH/CRITICAL found)
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasecurity/trivy image --severity HIGH,CRITICAL --exit-code 1 edulearn:local
```

- Run tfsec against your `terraform/` directory (install tfsec or use container):

```powershell
# If tfsec is installed
tfsec ./terraform
```

If these produce failures, fix critical issues (upgrade base image, patch packages, or adjust Terraform values) before pushing.

5) Terraform quick cycle (only after you write minimal `.tf` files)

```powershell
cd terraform
terraform init
terraform fmt
terraform validate
terraform plan -out=tfplan
# Apply only if you are ready and have cost/permission approval
terraform apply tfplan
```

To tear down after testing:

```powershell
terraform destroy -auto-approve
```

6) Ansible testing (from a Linux control host or WSL)

```bash
# Dry-run
ansible-playbook -i ansible/inventory.ini ansible/deploy.yml --check --diff

# Real run
ansible-playbook -i ansible/inventory.ini ansible/deploy.yml
```

Important: If using a Bastion host, ensure `ansible_ssh_common_args` is set in `inventory.ini` to proxy via the bastion.

7) GitHub Secrets (set immediately in repo Settings → Secrets)

Minimum secrets to add:
- AWS: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `ECR_REPO`
- Azure: `AZURE_CREDENTIALS`, `AZURE_REGISTRY`
- Shared: `SSH_PRIVATE_KEY` (for Ansible), `DB_PASSWORD` (if needed)

8) Simulate CD tasks locally (build → tag → push)

For AWS ECR example:

```powershell
# Authenticate
aws ecr get-login-password --region YOUR_REGION | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.YOUR_REGION.amazonaws.com

# Build and tag
docker build -t edulearn:sha-test .
docker tag edulearn:sha-test <ACCOUNT_ID>.dkr.ecr.YOUR_REGION.amazonaws.com/edulearn:sha-test

# Push
docker push <ACCOUNT_ID>.dkr.ecr.YOUR_REGION.amazonaws.com/edulearn:sha-test
```

For Azure ACR:

```powershell
az acr login --name <registryName>
docker tag edulearn:sha-test <registryName>.azurecr.io/edulearn:sha-test
docker push <registryName>.azurecr.io/edulearn:sha-test
```

9) Final PR → Merge → Deploy (what CD should automate)

Sequence the CD must perform:
- Run CI checks (lint, test, security scans)
- Build image and tag with commit SHA
- Authenticate to registry and push image
- SSH (via Bastion) to application host and run Ansible playbook to pull image and run `docker compose up -d`

10) Recording the demo (follow this exact flow)

1. Show live app running.
2. Make a small visible change (button text/header) and commit to a feature branch.
3. Open PR to `main` and show CI running; point out Trivy/tfsec logs.
4. Merge PR once checks pass.
5. Show CD running and pushing image; show Ansible playbook execution logs.
6. Refresh public URL and show change live.

11) If things fail — rapid troubleshooting
- Check GitHub Actions logs and copy error output.
- For Trivy failures: update base image or remove vulnerable packages.
- For tfsec failures: read the rule in the output and fix Terraform (e.g., tighten security groups).
- For SSH/Ansible failures: verify `SSH_PRIVATE_KEY` and `ansible_user`/`ansible_host` values and bastion proxy settings.

12) Commit and submit

```powershell
# Commit final files
git add -A
git commit -m "Summative: final infra and deploy artifacts (student-authored)"
git push origin urgent/summative-delivery
# Create a PR to main, merge, then record the demo
```

What I will NOT do
- I will not author or commit the following files for you: Terraform `.tf` files, Ansible playbooks, `Dockerfile`, `docker-compose.yml`, or GitHub Actions workflow `.yml` files. This respects the course requirement you provided.

What I WILL do next (pick one)
- Option 1: Review the files you author and provide line-by-line fixes and security advice.
- Option 2: Provide a provider-specific checklist and exact commands (AWS or Azure) for the remaining steps.
- Option 3: Create an `URGENT_TODO.md` issue template or checklist file in the repo to guide the team through submission steps.

Tell me which option you want and which cloud provider you will use (AWS or Azure). If you want me to review files, commit them to the emergency branch and ping me here — I'll review immediately and provide corrections.
