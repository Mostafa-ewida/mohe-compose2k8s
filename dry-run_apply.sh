#!/bin/bash

# Processes all ConfigMaps and Secrets with envsubst and saves to prod-conf

set -eo pipefail

# Configuration
SOURCE_DIR="."
OUTPUT_DIR="prod-dry-run"
ENV_FILE="$SOURCE_DIR/.env_domain"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Verify envsubst is available
if ! command -v envsubst >/dev/null 2>&1; then
  echo "Error: envsubst is required (part of gettext package)"
  exit 1
fi

# Load environment variables
if [ -f "$ENV_FILE" ]; then
  set -a
  . "$ENV_FILE"
  echo "Loaded environment variables from $ENV_FILE"
else
  echo "Warning: No .env file found"
  exit 1
fi



# Process all YAML/YML files
find "$SOURCE_DIR" -type f \( -name '*.yaml' -o -name '*.yml' \) | while read -r file; do
  # Skip hidden files and directories
  if [[ "$file" == *"/."* ]]; then
    continue
  fi
  
  # Get relative path and create directory structure
  rel_path="${file#$SOURCE_DIR/}"
  out_file="$OUTPUT_DIR/$rel_path"
  mkdir -p "$(dirname "$out_file")"
  
  # Check if file is ConfigMap or Secret
  if [[ "$file" == *"configmap"* || "$file" == *"config-map"* || 
        "$file" == *"secret"* || "$file" == *"secrets"* ]]; then
    echo "Processing (envsubst): $file -> $out_file"
    envsubst < "$file" > "$out_file"
  else
    echo "Copying: $file -> $out_file"
    cp "$file" "$out_file"
  fi
done

echo "Processing complete. Dry-run output saved to $OUTPUT_DIR/"
echo "You can inspect the files or run:"
echo "  kubectl apply --dry-run=client -f $OUTPUT_DIR/"