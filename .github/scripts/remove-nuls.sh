#!/usr/bin/env bash
# Script to detect and optionally remove NUL bytes from repository files
# Usage:
#   ./remove-nuls.sh        - detect files with NUL bytes (exit 1 if any found)
#   ./remove-nuls.sh --fix  - remove NUL bytes in-place from all files

set -euo pipefail

FIX_MODE=false
EXIT_CODE=0

# Parse arguments
if [[ "${1:-}" == "--fix" ]]; then
    FIX_MODE=true
fi

# Find all files (excluding .git and node_modules)
echo "Scanning repository for NUL bytes..."

while IFS= read -r -d '' file; do
    # Skip binary files (images, etc) - check by file extension
    case "$file" in
        *.jpg|*.jpeg|*.png|*.gif|*.ico|*.pdf|*.zip|*.tar|*.gz|*.bz2|*.7z)
            continue
            ;;
    esac
    
    # Check if file contains NUL bytes using a more reliable method
    if python3 -c "import sys; data = open('$file', 'rb').read(); sys.exit(0 if b'\x00' in data else 1)" 2>/dev/null; then
        if [ "$FIX_MODE" = true ]; then
            echo "Fixing: $file"
            # Remove NUL bytes in-place using tr
            tr -d '\000' < "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
        else
            echo "Found NUL bytes in: $file"
            EXIT_CODE=1
        fi
    fi
done < <(find . -type f ! -path './.git/*' ! -path './node_modules/*' -print0)

if [ "$FIX_MODE" = false ] && [ $EXIT_CODE -eq 0 ]; then
    echo "✓ No NUL bytes found"
fi

if [ "$FIX_MODE" = true ]; then
    echo "✓ NUL byte cleanup complete"
    EXIT_CODE=0
fi

exit $EXIT_CODE
