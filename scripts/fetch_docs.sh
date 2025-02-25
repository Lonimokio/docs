#!/bin/sh
set -e

# Force Git to use HTTPS instead of SSH for GitHub URLs (avoids SSH key issues)
git config --global url."https://github.com/".insteadOf "git@github.com:"

# Define absolute paths
REPO_URL="https://github.com/pvarki/docker-rasenmaeher-integration.git"
WORKSPACE="${GITHUB_WORKSPACE:-$(pwd)}"
# We'll completely clear the MainDocs folder to avoid merging with the repository checkout.
DEST_PARENT="$WORKSPACE/MainDocs"
DEST_DIR="$DEST_PARENT/docs"
TEMP_DIR="$WORKSPACE/repo_temp"

# Remove any existing MainDocs folder and temporary clone
rm -rf "$DEST_PARENT"
rm -rf "$TEMP_DIR"
mkdir -p "$DEST_DIR"

# Clone the main repository into TEMP_DIR (using HTTPS)
git clone "$REPO_URL" "$TEMP_DIR"
cd "$TEMP_DIR"

# Initialize and update all submodules recursively
git submodule update --init --recursive

# Use find to locate only Markdown files (case-insensitive) and copy them preserving directory structure.
# Only directories that contain a *.md file will be created.
find . -type f -iname '*.md' | while IFS= read -r file; do
    # Remove any leading "./" from the file path
    rel_path="${file#./}"
    dest_file="$DEST_DIR/$rel_path"
    mkdir -p "$(dirname "$dest_file")"
    cp "$file" "$dest_file"
done

# Clean up temporary repository clone
rm -rf "$TEMP_DIR"

echo "Markdown files and folder structure copied to $DEST_DIR"
