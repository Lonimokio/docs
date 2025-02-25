#!/bin/bash

# Set the repository URL
REPO_URL="https://github.com/pvarki/docker-rasenmaeher-integration.git"

# Set the destination directory
DEST_DIR="$GITHUB_WORKSPACE/MainDocs/docs"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Clone the repository recursively using HTTPS
git clone --recursive "$REPO_URL" "$DEST_DIR/repo"

# Process the files
find "$DEST_DIR/repo" -type f -name "*.md" -print0 | while IFS= read -r -d $'\0' file; do
  # Get the directory containing the .md file
  dir=$(dirname "$file")

  # Check if the directory contains ANY .md files (including in subdirectories)
  if find "$dir" -type f -name "*.md" -print -quit | grep -q .; then
    # Copy the directory and its contents
    cp -r "$dir" "$DEST_DIR"
  else
    # Copy only the .md file
    cp "$file" "$DEST_DIR"
  fi
done

# Remove the cloned repository
rm -rf "$DEST_DIR/repo"

echo "Files processed and saved to $DEST_DIR"

# Remove duplicate files/folders (if any)
find "$DEST_DIR" -depth -name "repo" -exec rm -rf {} \;

echo "Duplicate 'repo' folders removed"