#!/bin/sh

# Variables
REPO_URL="https://github.com/pvarki/docker-rasenmaeher-integration.git"
DEST_DIR="$GITHUB_WORKSPACE/MainDocs/docs"
TEMP_DIR="$GITHUB_WORKSPACE/repo_temp"

# Ensure a clean workspace
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Clone the repository with submodules using HTTPS
git clone --recurse-submodules --depth=1 "$REPO_URL" "$TEMP_DIR"

# Convert all submodules to HTTPS
cd "$TEMP_DIR"
git submodule foreach --recursive 'git config --file $toplevel/.gitmodules submodule.$name.url ${url/ssh:\/\/git@/https:\/\/} && git submodule sync --recursive && git submodule update --init --recursive'

# Create the destination directory
mkdir -p "$DEST_DIR"

# Find and copy .md files and their directories
find "$TEMP_DIR" -type f -name "*.md" | while read -r md_file; do
    md_dir=$(dirname "$md_file")
    mkdir -p "$DEST_DIR/${md_dir#$TEMP_DIR/}"
    cp "$md_file" "$DEST_DIR/${md_file#$TEMP_DIR/}"
done

# Clean up
rm -rf "$TEMP_DIR"

echo "Markdown files and their folders have been copied to $DEST_DIR"
