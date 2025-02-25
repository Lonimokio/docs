#!/bin/sh
set -e

# Ensure Git automatically rewrites SSH GitHub URLs to HTTPS.
git config --global url."https://github.com/".insteadOf "git@github.com:"

# Define absolute paths
REPO_URL="https://github.com/pvarki/docker-rasenmaeher-integration.git"
DEST_DIR="$GITHUB_WORKSPACE/MainDocs/docs"
TEMP_DIR="$GITHUB_WORKSPACE/repo_temp"

# Clean up previous temporary clone and destination folder
rm -rf "$TEMP_DIR"
rm -rf "$DEST_DIR"
mkdir -p "$TEMP_DIR"
mkdir -p "$DEST_DIR"

# Clone the repository (using HTTPS) and its submodules
git clone "$REPO_URL" "$TEMP_DIR"
cd "$TEMP_DIR"
git submodule update --init --recursive

# Find all Markdown files and copy them preserving directory structure.
# This will only copy .md files and create directories as needed.
find . -type f -name '*.md' | while IFS= read -r mdfile; do
    # Remove the leading './' from the path
    rel_path="${mdfile#./}"
    dest_path="$DEST_DIR/$(dirname "$rel_path")"
    mkdir -p "$dest_path"
    cp "$mdfile" "$dest_path/"
done

# Clean up the temporary repository clone
rm -rf "$TEMP_DIR"

echo "Markdown files and folder structure copied to $DEST_DIR"
