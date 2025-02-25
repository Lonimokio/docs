#!/bin/sh
set -e

# Ensure Git uses HTTPS instead of SSH for GitHub URLs
git config --global url."https://github.com/".insteadOf "git@github.com:"

# Define absolute paths
REPO_URL="https://github.com/pvarki/docker-rasenmaeher-integration.git"
DEST_DIR="$GITHUB_WORKSPACE/MainDocs/docs"
TEMP_DIR="$GITHUB_WORKSPACE/repo_temp"

# Clean up any previous clone and prepare a temporary directory
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Clone the main repository using HTTPS
git clone "$REPO_URL" "$TEMP_DIR"

# Change directory to the cloned repository
cd "$TEMP_DIR"

# Initialize and update all submodules recursively
git submodule update --init --recursive

# (Optional) Also update any .gitmodules files to replace SSH URLs with HTTPS.
# This is mostly redundant due to the global git config above but included for completeness.
find "$TEMP_DIR" -type f -name ".gitmodules" -exec sed -i 's/git@github.com:/https:\/\/github.com\//g' {} +

# Sync submodules to ensure any changes from .gitmodules are applied
git submodule sync --recursive
git submodule update --init --recursive

# Create the destination directory
mkdir -p "$DEST_DIR"

# Use rsync to copy only directories (and subdirectories) that contain .md files
# It includes directories (needed for structure) and .md files, excluding everything else.
rsync -av --prune-empty-dirs --include '*/' --include '*.md' --exclude '*' "$TEMP_DIR"/ "$DEST_DIR"/

# Clean up temporary repository clone
rm -rf "$TEMP_DIR"

echo "Markdown files and folder structure copied to $DEST_DIR"
