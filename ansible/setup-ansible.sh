#!/usr/bin/env bash
# Setup Ansible for EduConnect-Africa project
# Cross-platform Linux-friendly installer for GitHub Actions

set -euo pipefail

echo "=================================="
echo "EduConnect Ansible Setup Script"
echo "=================================="
echo ""

# Set UTF-8 encoding
export PYTHONIOENCODING=utf-8

# Install pip and setuptools
echo "Installing/upgrading pip and setuptools..."
python3 -m pip install --upgrade --user pip setuptools

# Install Ansible
echo "Installing Ansible..."
python3 -m pip install --user ansible-core ansible

# Add user bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Verify installation
echo ""
echo "Verifying Ansible installation..."
if command -v ansible >/dev/null 2>&1; then
    echo "✅ Ansible installed successfully"
    ansible --version
else
    echo "❌ Ansible installation failed - not found in PATH"
    echo "PATH: $PATH"
    exit 1
fi

# Install Ansible collections
echo ""
echo "Installing Ansible collections..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
if [ -f "requirements.yml" ]; then
    ansible-galaxy collection install -r requirements.yml
    echo "✅ Collections installed successfully"
else
    echo "⚠️  requirements.yml not found, skipping collection installation"
fi

echo ""
echo "=================================="
echo "Setup Complete!"
echo "=================================="
echo ""
echo "Ansible is ready to use."
