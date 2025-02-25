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
git submodule foreach --recursive '
    URL=$(git config --get remote.origin.url)
    HTTPS_URL=${URL/ssh:\/\/git@/https:\/\/}
    HTTPS_URL=${HTTPS_URL/git@github.com:/https:\/\/github.com\/}
    git config --local remote.origin.url "$HTTPS_URL"
    git submodule sync --recursive
    git submodule update --init --recursive
'

# Create the destination directory
mkdir -p "$DEST_DIR"

# Find all directories containing .md files
find "$TEMP_DIR" -type f -name "*.md" | while read -r md_file; do
    md_dir=$(dirname "$md_file")
    relative_path="${md_dir#$TEMP_DIR/}"
    
    # Copy only the directory containing .md files and the .md files inside it
    mkdir -p "$DEST_DIR/$relative_path"
    cp -r "$md_dir"/*.md "$DEST_DIR/$relative_path/"
done

# Clean up temporary files
rm -rf "$TEMP_DIR"

echo "Markdown files and their folders have been copied to $DEST_DIR"
