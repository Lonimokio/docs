#!/bin/sh
set -e

# Variables (using absolute paths)
REPO_URL="https://github.com/pvarki/docker-rasenmaeher-integration.git"
DEST_DIR="$GITHUB_WORKSPACE/MainDocs/docs"
TEMP_DIR="$GITHUB_WORKSPACE/repo_temp"

# Clean up any previous clone
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Clone the repository (using HTTPS)
git clone "$REPO_URL" "$TEMP_DIR"

# If .gitmodules exists, convert SSH URLs to HTTPS
if [ -f "$TEMP_DIR/.gitmodules" ]; then
    sed -i 's/git@github.com:/https:\/\/github.com\//g' "$TEMP_DIR/.gitmodules"
fi

cd "$TEMP_DIR"

# Sync and update submodules recursively using the updated URLs
git submodule sync --recursive
git submodule update --init --recursive

# Create destination directory
mkdir -p "$DEST_DIR"

# Use rsync to copy only .md files (and only the directories that contain them)
# This command includes all directories, but prunes those that end up empty (i.e. without any *.md files).
rsync -av --prune-empty-dirs --include '*/' --include '*.md' --exclude '*' ./ "$DEST_DIR/"

# Clean up temporary directory
rm -rf "$TEMP_DIR"

echo "Markdown files and folder structure copied to $DEST_DIR"
