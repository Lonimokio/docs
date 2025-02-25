#!/bin/bash

# Set the repository URL
REPO_URL="https://github.com/pvarki/docker-rasenmaeher-integration.git"

# Set the destination directory
DEST_DIR="$GITHUB_WORKSPACE/MainDocs/docs"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Clone the repository recursively using HTTPS and force HTTPS for submodules
git clone --recursive --submodule-force-https "$REPO_URL" "$DEST_DIR/repo"

# Process the files (same as before)
find "$DEST_DIR/repo" -type f -name "*.md" -print0 | while IFS= read -r -d $'\0' file; do
  dir=$(dirname "$file")
  if find "$dir" -type f -name "*.md" -print -quit | grep -q .; then
    cp -r "$dir" "$DEST_DIR"
  else
    cp "$file" "$DEST_DIR"
  fi
done

# Remove the cloned repository
rm -rf "$DEST_DIR/repo"

echo "Files processed and saved to $DEST_DIR"

# Remove duplicate files/folders (if any)
find "$DEST_DIR" -depth -name "repo" -exec rm -rf {} \;

echo "Duplicate 'repo' folders removed"