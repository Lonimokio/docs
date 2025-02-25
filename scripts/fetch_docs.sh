#!/bin/bash

REPO_URL="https://github.com/pvarki/docker-rasenmaeher-integration.git"
CLONE_PATH=$(realpath "MainDocs/docs")
OUTPUT_PATH=$(realpath "MainDocs/docs")

# Clone the main repository
clone_repo() {
    if [ -d "$CLONE_PATH" ]; then
        rm -rf "$CLONE_PATH"
    fi
    git clone --recurse-submodules "$REPO_URL" "$CLONE_PATH"
}

# Fetch .md files from a repository
fetch_md_files_from_repo() {
    local repo_path=$1
    local output_path=$2

    find "$repo_path/docs" -type f -name '*.md' | while read -r md_file; do
        relative_path=$(realpath --relative-to="$repo_path" "$md_file")
        dest_path="$output_path/$relative_path"
        mkdir -p "$(dirname "$dest_path")"
        cp "$md_file" "$dest_path"
        echo "Copied $md_file to $dest_path"
    done
}

# Fetch .md files from submodules
fetch_md_files_from_submodules() {
    local repo_path=$1
    local output_path=$2

    git -C "$repo_path" submodule foreach --recursive '
        submodule_path=$toplevel/$sm_path
        submodule_name=$(basename "$submodule_path")
        fetch_md_files_from_repo "$submodule_path" "$output_path/$submodule_name"
    '
}

# Main function
main() {
    echo "Cloning repository from $REPO_URL to $CLONE_PATH"
    clone_repo
    echo "Repository cloned to $CLONE_PATH"

    echo "Fetching .md files from repository at $CLONE_PATH to $OUTPUT_PATH"
    fetch_md_files_from_repo "$CLONE_PATH" "$OUTPUT_PATH"

    echo "Fetching .md files from submodules in repository at $CLONE_PATH to $OUTPUT_PATH"
    fetch_md_files_from_submodules "$CLONE_PATH" "$OUTPUT_PATH"
    echo "Fetching completed"
}

main