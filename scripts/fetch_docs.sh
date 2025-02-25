#!/bin/bash

REPO_URL="https://github.com/pvarki/docker-rasenmaeher-integration.git"
CLONE_PATH=$(realpath "MainDocs/tmp_clone")
OUTPUT_PATH=$(realpath "MainDocs/docs")

# Clone the main repository
clone_repo() {
    if [ -d "$CLONE_PATH" ]; then
        rm -rf "$CLONE_PATH"
    fi
    git clone --recurse-submodules "$REPO_URL" "$CLONE_PATH"
}

# Copy only .md files and necessary folder structure (Corrected)
fetch_md_files() {
    local source_path=$1
    local dest_path=$2

    find "$source_path" -type f -name '*.md' -print0 | while IFS= read -r -d $'\0' md_file; do
        # Create relative path manually
        relative_path=$(echo "$md_file" | sed "s|^$source_path/||")  # <--- Key change
        dest_file="$dest_path/$relative_path"
        mkdir -p "$(dirname "$dest_file")"
        cp "$md_file" "$dest_file"
        echo "Copied $md_file to $dest_file"
    done
}

# Fetch .md files from submodules
fetch_md_files_from_submodules() {
    git -C "$CLONE_PATH" submodule foreach --recursive '
        submodule_path=$toplevel/$sm_path
        fetch_md_files "$submodule_path" "'$OUTPUT_PATH'/$sm_path"
    '
}

# Main function
main() {
    echo "Cloning repository from $REPO_URL to $CLONE_PATH"
    clone_repo
    echo "Repository cloned to $CLONE_PATH"

    echo "Fetching .md files from repository at $CLONE_PATH to $OUTPUT_PATH"
    fetch_md_files "$CLONE_PATH" "$OUTPUT_PATH"

    echo "Fetching .md files from submodules in repository at $CLONE_PATH to $OUTPUT_PATH"
    fetch_md_files_from_submodules
    echo "Fetching completed"

    # Cleanup cloned repository
    rm -rf "$CLONE_PATH"
}

main