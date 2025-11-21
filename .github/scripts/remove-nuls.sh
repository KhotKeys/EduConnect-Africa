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

# Function to check and fix NUL bytes in a file
check_and_fix_file() {
    local file="$1"
    
    # Check if file contains NUL bytes using perl
    # perl exits with 1 if NUL bytes found, 0 if not found
    if perl -0777 -ne 'exit 1 if /\x00/' "$file" 2>/dev/null; then
        # No NUL bytes found - file is clean
        return 0
    fi
    
    # NUL bytes detected
    if [ "$FIX_MODE" = true ]; then
        echo "Fixing: $file"
        # Remove NUL bytes in-place and ensure UTF-8 encoding
        perl -i -0777 -pe 's/\x00//g' "$file"
        # Convert to LF line endings (atomic operation)
        local tmpfile="${file}.tmp.$$"
        if tr -d '\r' < "$file" > "$tmpfile"; then
            mv "$tmpfile" "$file"
            echo "  ✓ NUL bytes removed from $file"
        else
            rm -f "$tmpfile"
            echo "  ✗ Failed to convert line endings for $file"
            EXIT_CODE=1
        fi
    else
        echo "Found NUL bytes in: $file"
        EXIT_CODE=1
    fi
}

# Find and process files using find -exec for safety
for pattern in "${TEXT_FILE_PATTERNS[@]}"; do
    while IFS= read -r -d '' file; do
        # Skip excluded paths
        skip=false
        for exclude in "${EXCLUDE_PATTERNS[@]}"; do
            if [[ "$file" == *"/$exclude/"* ]] || [[ "$file" == *"$exclude" ]]; then
                skip=true
                break
            fi
        done
        
        if [ "$skip" = false ] && [ -f "$file" ]; then
            check_and_fix_file "$file"
        fi
    done < <(find . -type f -name "$pattern" -print0 2>/dev/null)
done

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
