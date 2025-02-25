#!/bin/bash
set -e

WORKSPACE="${GITHUB_WORKSPACE:-$(pwd)}"
DOCS_DIR="$WORKSPACE/MainDocs/docs"
CONFIG_FILE="$WORKSPACE/MainDocs/docusaurus.config.js"

# Generate the sidebar configuration
generate_sidebar() {
  local dir="$1"
  local indent="$2"
  local sidebar=""

  for entry in "$dir"/*; do
    if [ -d "$entry" ]; then
      local folder_name=$(basename "$entry")
      sidebar+="${indent}{\n"
      sidebar+="${indent}  type: 'category',\n"
      sidebar+="${indent}  label: '$folder_name',\n"
      sidebar+="${indent}  items: [\n"
      sidebar+=$(generate_sidebar "$entry" "$indent    ")
      sidebar+="${indent}  ],\n"
      sidebar+="${indent}},\n"
    elif [[ "$entry" == *.md ]]; then
      local file_name=$(basename "$entry" .md)
      local relative_path=$(realpath --relative-to="$DOCS_DIR" "$entry")
      sidebar+="${indent}'$relative_path',\n"
    fi
  done

  echo -e "$sidebar"
}

# Generate the new sidebar content
new_sidebar=$(generate_sidebar "$DOCS_DIR" "    ")

# Update the docusaurus.config.js file
escaped_sidebar=$(echo "$new_sidebar" | sed ':a;N;$!ba;s/\n/\\n/g')
sed -i "/sidebarPath:/a \ \ \ \ \ \ \ \ items: [\n$escaped_sidebar\ \ \ \ \ \ \ \ ]," "$CONFIG_FILE"

echo "Docusaurus config updated with new sidebar structure."