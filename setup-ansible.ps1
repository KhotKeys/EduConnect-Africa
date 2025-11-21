# Setup Ansible for EduConnect Project
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "EduConnect Ansible Setup Script" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Set UTF-8 encoding
$env:PYTHONIOENCODING = "utf-8"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Setting up Python environment..." -ForegroundColor Yellow
python -m pip install --upgrade --user pip setuptools

Write-Host ""
Write-Host "Installing Ansible..." -ForegroundColor Yellow
python -m pip install --user ansible-core ansible

Write-Host ""
Write-Host "Checking Ansible installation..." -ForegroundColor Yellow

# Try to find ansible in PATH
$ansible = Get-Command ansible -ErrorAction SilentlyContinue
$ansibleGalaxy = Get-Command ansible-galaxy -ErrorAction SilentlyContinue

if (-not $ansible) {
    # Try common Python user paths
    $pythonUserBase = python -c "import site; print(site.USER_BASE)" 2>$null
    if ($pythonUserBase) {
        $scriptsPath = Join-Path $pythonUserBase "Scripts"
        $env:PATH = "$scriptsPath;$env:PATH"
        $ansible = Get-Command ansible -ErrorAction SilentlyContinue
        $ansibleGalaxy = Get-Command ansible-galaxy -ErrorAction SilentlyContinue
    }
}

if ($ansible) {
    Write-Host "✓ Ansible found: $($ansible.Source)" -ForegroundColor Green
    & ansible --version
} else {
    Write-Host "Error: Ansible not found in PATH" -ForegroundColor Red
    Write-Host "Please ensure Python user scripts directory is in your PATH" -ForegroundColor Yellow
    Write-Host "Run: python -c `"import site; print(site.USER_BASE)`"" -ForegroundColor Yellow
    Write-Host "Then add <USER_BASE>\Scripts to your PATH" -ForegroundColor Yellow
    exit 1
}

if (-not $ansibleGalaxy) {
    Write-Host "Error: ansible-galaxy not found in PATH" -ForegroundColor Red
    exit 1
}

Write-Host ""
$ansibleDir = Join-Path $PSScriptRoot "ansible"
if (Test-Path $ansibleDir) {
    Set-Location $ansibleDir
    Write-Host "Changed to ansible directory" -ForegroundColor Green
} else {
    Write-Host "Ansible directory not found" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Installing Ansible collections..." -ForegroundColor Yellow
if (Test-Path "requirements.yml") {
    & ansible-galaxy collection install -r requirements.yml
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Collections installed successfully" -ForegroundColor Green
    } else {
        Write-Host "Failed to install collections" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "requirements.yml not found" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "✓ Setup Complete!" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Configure AWS: aws configure" -ForegroundColor White
Write-Host "2. Deploy Terraform: cd terraform" -ForegroundColor White
Write-Host "3. Update Ansible inventory" -ForegroundColor White
Write-Host "4. Deploy application" -ForegroundColor White
