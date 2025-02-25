#!/bin/bash

# Set the repository URL
REPO_URL="https://github.com/pvarki/docker-rasenmaeher-integration.git"

# Set the destination directory
DEST_DIR="$GITHUB_WORKSPACE/MainDocs/docs"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Clone the repository (without recursing submodules initially)
git clone "$REPO_URL" "$DEST_DIR/repo"

# Change directory into the newly cloned repo
cd "$DEST_DIR/repo"

# Configure git to use HTTPS for all submodules
git config -f .gitmodules submodule.active.url "https"

# Initialize and update the submodules (now using HTTPS)
git submodule update --init --recursive

# Change directory back to the script's original location
cd -

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