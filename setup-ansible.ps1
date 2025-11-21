# Setup Ansible for EduConnect Project
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "EduConnect Ansible Setup Script" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

$ansiblePath = "C:\Users\HP\AppData\Roaming\Python\Python313\Scripts"
$ansibleGalaxy = Join-Path $ansiblePath "ansible-galaxy.exe"
$ansible = Join-Path $ansiblePath "ansible.exe"

Write-Host "Checking Ansible installation..." -ForegroundColor Yellow
if (Test-Path $ansible) {
    Write-Host "Ansible found" -ForegroundColor Green
    & $ansible --version
} else {
    Write-Host "Ansible not found. Run: pip install ansible" -ForegroundColor Red
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
    & $ansibleGalaxy collection install -r requirements.yml
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Collections installed successfully" -ForegroundColor Green
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
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Configure AWS: aws configure" -ForegroundColor White
Write-Host "2. Deploy Terraform: cd terraform" -ForegroundColor White
Write-Host "3. Update Ansible inventory" -ForegroundColor White
Write-Host "4. Deploy application" -ForegroundColor White
