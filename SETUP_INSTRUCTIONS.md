# Setup Instructions

## GitHub Secrets Required

Add these secrets at: https://github.com/KhotKeys/EduConnect-Africa/settings/secrets/actions

1. AWS_ACCESS_KEY_ID
2. AWS_SECRET_ACCESS_KEY
3. AWS_REGION - eu-north-1
4. ECR_REPO - 618854476233.dkr.ecr.eu-north-1.amazonaws.com/educate-generation
5. EC2_HOST - 16.171.136.183
6. SSH_PRIVATE_KEY_EC2

## Fixes Applied

- Cleaned corrupted HTML (removed NUL bytes)
- Updated Node.js to v20
- Added glob@11.1.0 to fix CVE-2025-64756
- Added NUL byte check in CI
- Updated Trivy to ignore unfixed vulnerabilities
