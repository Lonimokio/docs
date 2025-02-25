#!/bin/bash

# Set the repository URL
REPO_URL="https://github.com/pvarki/docker-rasenmaeher-integration.git"

# Set the destination directory
DEST_DIR="$GITHUB_WORKSPACE/MainDocs/docs"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Clone the repository (without recursing submodules initially)
git clone "$REPO_URL" "$DEST_DIR/repo_temp"

# Change directory into the newly cloned repo
cd "$DEST_DIR/repo_temp"

# Configure git to use HTTPS for all submodules
git config -f .gitmodules submodule.active.url "https"

# Initialize and update the submodules (now using HTTPS)
git submodule update --init --recursive

# Change directory back to the script's original location
cd -

# Use rsync to copy only .md files and their directories
rsync -av --include='*/' --include='*.md' --exclude='*' "$DEST_DIR/repo_temp/" "$DEST_DIR/"

# Remove the cloned repository
rm -rf "$DEST_DIR/repo_temp"

echo "Files processed and saved to $DEST_DIR"
