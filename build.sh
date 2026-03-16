#!/bin/bash
# Process {{#include path}} directives in templates and output final markdown files
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

process_includes() {
  local file="$1"
  local dir
  dir="$(dirname "$file")"

  while IFS= read -r line; do
    if [[ "$line" =~ \{\{#include\ (.*)\}\} ]]; then
      local include_path="${BASH_REMATCH[1]}"
      # Resolve relative to the template file's directory
      cat "$dir/$include_path"
    else
      echo "$line"
    fi
  done < "$file"
}

echo "Building README.md..."
process_includes "$SCRIPT_DIR/templates/readme.md" > "$SCRIPT_DIR/README.md"

echo "Building SPONSORS.md..."
process_includes "$SCRIPT_DIR/templates/sponsors.md" > "$SCRIPT_DIR/SPONSORS.md"

echo "Done!"
