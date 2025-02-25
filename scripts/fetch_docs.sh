#!/bin/sh
set -e

# Force Git to use HTTPS for GitHub URLs (avoids SSH issues)
git config --global url."https://github.com/".insteadOf "git@github.com:"

# Define absolute paths (GITHUB_WORKSPACE is provided by GitHub Actions)
REPO_URL="https://github.com/pvarki/docker-rasenmaeher-integration.git"
WORKSPACE="${GITHUB_WORKSPACE:-$(pwd)}"
DEST_DIR="$WORKSPACE/MainDocs/docs"
TEMP_DIR="$WORKSPACE/repo_temp"

# Clean out any previous clone and destination contents
rm -rf "$TEMP_DIR"
rm -rf "$DEST_DIR"
mkdir -p "$TEMP_DIR"
mkdir -p "$DEST_DIR"

# Clone the repository (using HTTPS) into TEMP_DIR
git clone "$REPO_URL" "$TEMP_DIR"
cd "$TEMP_DIR"

# Initialize and update submodules recursively (they’ll be cloned via HTTPS thanks to our global config)
git submodule update --init --recursive

# Use find to locate only .md files (case-insensitive) and copy them preserving directory structure.
# For each Markdown file, we compute its relative path, ensure the destination directory exists, then copy.
find . -type f -iname '*.md' | while IFS= read -r file; do
    # Strip any leading "./" from the file path
    rel_path="${file#./}"
    dest_file="$DEST_DIR/$rel_path"
    mkdir -p "$(dirname "$dest_file")"
    cp "$file" "$dest_file"
done

# Clean up temporary clone
rm -rf "$TEMP_DIR"

echo "Markdown files and folder structure copied to $DEST_DIR"
