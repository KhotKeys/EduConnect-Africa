#!/usr/bin/env bash
# Setup Ansible on Linux/macOS for EduConnect Project
# This script installs Ansible and required collections

set -euo pipefail

echo "=================================="
echo "EduConnect Ansible Setup Script"
echo "=================================="
echo ""

# Set UTF-8 encoding
export PYTHONIOENCODING=utf-8

echo "Setting up Python environment..."
python3 -m pip install --upgrade --user pip setuptools

echo ""
echo "Installing Ansible..."
python3 -m pip install --user ansible-core ansible

# Add user bin to PATH
export PATH="$HOME/.local/bin:$PATH"

echo ""
echo "Verifying Ansible installation..."
if command -v ansible &> /dev/null; then
    ansible --version
else
    echo "Error: Ansible not found in PATH"
    echo "Please add $HOME/.local/bin to your PATH"
    exit 1
fi

echo ""
echo "Installing Ansible collections..."
ANSIBLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
if [ -z "$ANSIBLE_DIR" ] || [ ! -d "$ANSIBLE_DIR" ]; then
    echo "Error: Failed to determine ansible directory"
    exit 1
fi
cd "$ANSIBLE_DIR" || exit 1

if [ -f "requirements.yml" ]; then
    ansible-galaxy collection install -r requirements.yml
    echo "✓ Collections installed successfully"
else
    echo "Error: requirements.yml not found"
    exit 1
fi

echo ""
echo "=================================="
echo "✓ Setup Complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "1. Configure AWS: aws configure"
echo "2. Deploy Terraform: cd terraform"
echo "3. Update Ansible inventory"
echo "4. Deploy application"
