#!/usr/bin/env bash
set -euo pipefail

# Script to detect and optionally strip NUL bytes from repository files
# Usage:
#   ./remove-nuls.sh          # List files with NUL bytes and exit non-zero if any found
#   ./remove-nuls.sh --fix    # Remove NUL bytes in-place from affected files

FIX_MODE=false
EXIT_CODE=0

# Parse arguments
if [[ "${1:-}" == "--fix" ]]; then
    FIX_MODE=true
fi

# Find text files (exclude binary files, git directory, node_modules, etc.)
TEXT_FILE_PATTERNS=(
    "*.md"
    "*.txt"
    "*.js"
    "*.json"
    "*.yml"
    "*.yaml"
    "*.html"
    "*.css"
    "*.sh"
    "*.py"
    "*.xml"
)

EXCLUDE_PATTERNS=(
    ".git"
    "node_modules"
    "dist"
    "build"
    "*.jpg"
    "*.jpeg"
    "*.png"
    "*.gif"
    "*.ico"
    "*.svg"
    "*.woff"
    "*.woff2"
    "*.ttf"
    "*.eot"
)

echo "Scanning repository for NUL bytes in text files..."

# Build find command with file patterns
FIND_CMD="find . -type f \("
for i in "${!TEXT_FILE_PATTERNS[@]}"; do
    if [ $i -gt 0 ]; then
        FIND_CMD="$FIND_CMD -o"
    fi
    FIND_CMD="$FIND_CMD -name '${TEXT_FILE_PATTERNS[$i]}'"
done
FIND_CMD="$FIND_CMD \)"

# Add exclusions
for pattern in "${EXCLUDE_PATTERNS[@]}"; do
    FIND_CMD="$FIND_CMD -not -path '*/$pattern/*' -not -name '$pattern'"
done

# Execute find and check each file
while IFS= read -r file; do
    if [ -f "$file" ]; then
        # Check if file contains NUL bytes using perl
        if ! perl -0777 -ne 'exit 1 if /\x00/' "$file" 2>/dev/null; then
            if [ "$FIX_MODE" = true ]; then
                echo "Fixing: $file"
                # Remove NUL bytes in-place and ensure UTF-8 encoding
                perl -i -0777 -pe 's/\x00//g' "$file"
                # Convert to LF line endings
                tr -d '\r' < "$file" > "$file.tmp" && mv "$file.tmp" "$file"
                echo "  ✓ NUL bytes removed from $file"
            else
                echo "Found NUL bytes in: $file"
                EXIT_CODE=1
            fi
        fi
    fi
done < <(eval "$FIND_CMD")

if [ "$FIX_MODE" = true ]; then
    echo "✓ Fix complete. Verify changes before committing."
else
    if [ $EXIT_CODE -eq 0 ]; then
        echo "✓ No NUL bytes found in text files."
    else
        echo ""
        echo "✗ Files with NUL bytes detected!"
        echo "  Run with --fix to remove them: $0 --fix"
    fi
fi

exit $EXIT_CODE
