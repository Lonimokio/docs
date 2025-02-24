#!/bin/bash

REPO_URL="https://github.com/pvarki/docker-rasenmaeher-integration.git"
CLONE_PATH="fetched_docs"
OUTPUT_PATH="fetched_docs"

# Clone the main repository
clone_repo() {
    if [ -d "$CLONE_PATH" ]; then
        rm -rf "$CLONE_PATH"
    fi
    git clone --recurse-submodules "$REPO_URL" "$CLONE_PATH"
}

# Fetch docs from a repository
fetch_docs_from_repo() {
    local repo_path=$1
    local output_path=$2

    find "$repo_path" -type d -name 'docs' | while read -r docs_path; do
        relative_path=$(realpath --relative-to="$repo_path" "$docs_path")
        dest_path="$output_path/$relative_path"
        mkdir -p "$(dirname "$dest_path")"
        cp -r "$docs_path" "$dest_path"
        echo "Copied docs from $docs_path to $dest_path"
    done
}

# Fetch docs from submodules
fetch_docs_from_submodules() {
    local repo_path=$1
    local output_path=$2

    git -C "$repo_path" submodule foreach --recursive '
        submodule_path=$toplevel/$sm_path
        submodule_name=$(basename "$submodule_path")
        fetch_docs_from_repo "$submodule_path" "$output_path/$submodule_name"
    '
}

# Main function
main() {
    echo "Cloning repository from $REPO_URL to $CLONE_PATH"
    clone_repo
    echo "Repository cloned to $CLONE_PATH"

    echo "Fetching docs from repository at $CLONE_PATH to $OUTPUT_PATH"
    fetch_docs_from_repo "$CLONE_PATH" "$OUTPUT_PATH"

    echo "Fetching docs from submodules in repository at $CLONE_PATH to $OUTPUT_PATH"
    fetch_docs_from_submodules "$CLONE_PATH" "$OUTPUT_PATH"
    echo "Fetching completed"
}

main