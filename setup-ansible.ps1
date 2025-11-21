# Setup Ansible for EduConnect Project
# Cross-platform Windows installer with dynamic path detection

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "EduConnect Ansible Setup Script" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Set UTF-8 encoding
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null
$env:PYTHONIOENCODING = "utf-8"

Write-Host "Installing/upgrading pip and setuptools..." -ForegroundColor Yellow
python -m pip install --upgrade --user pip setuptools
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to upgrade pip" -ForegroundColor Red
    exit 1
}

Write-Host "Installing Ansible..." -ForegroundColor Yellow
python -m pip install --user ansible-core ansible
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install Ansible" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Checking Ansible installation..." -ForegroundColor Yellow
$ansible = Get-Command ansible -ErrorAction SilentlyContinue
if ($ansible) {
    Write-Host "✅ Ansible found at: $($ansible.Source)" -ForegroundColor Green
    & ansible --version
} else {
    Write-Host "❌ Ansible not found in PATH. Trying to locate..." -ForegroundColor Yellow

    # Try to find ansible in common locations
    try {
        $pythonUserBase = python -m site --user-base 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to get Python user base"
        }
    } catch {
        Write-Host "❌ Failed to get Python user base. Ensure Python is installed and in PATH." -ForegroundColor Red
        Write-Host "Error: $_" -ForegroundColor Red
        exit 1
    }

    $possiblePaths = @(
        "$pythonUserBase\Scripts",
        "$env:APPDATA\Python\Python*\Scripts",
        "$env:LOCALAPPDATA\Programs\Python\Python*\Scripts"
    )

    foreach ($path in $possiblePaths) {
        $ansibleExe = Get-ChildItem -Path $path -Filter "ansible.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($ansibleExe) {
            Write-Host "Found Ansible at: $($ansibleExe.FullName)" -ForegroundColor Yellow
            Write-Host "Please add this directory to your PATH: $($ansibleExe.DirectoryName)" -ForegroundColor Yellow
            break
        }
    }
    
    Write-Host "❌ Ansible not found. Please ensure Python Scripts directory is in PATH" -ForegroundColor Red
    Write-Host "Run: python -m site --user-base to find your Python user base directory" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
$ansibleDir = Join-Path $PSScriptRoot "ansible"
if (Test-Path $ansibleDir) {
    Set-Location $ansibleDir
    Write-Host "Changed to ansible directory" -ForegroundColor Green
} else {
    Write-Host "❌ Ansible directory not found" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Installing Ansible collections..." -ForegroundColor Yellow
$ansibleGalaxy = Get-Command ansible-galaxy -ErrorAction SilentlyContinue
if (-not $ansibleGalaxy) {
    Write-Host "❌ ansible-galaxy not found in PATH" -ForegroundColor Red
    exit 1
}

if (Test-Path "requirements.yml") {
    & ansible-galaxy collection install -r requirements.yml
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Collections installed successfully" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to install collections" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "❌ requirements.yml not found" -ForegroundColor Red
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

