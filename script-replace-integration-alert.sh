#!/bin/bash

# Directory containing YAML files (adjust as needed)
YAML_DIR="prometheus-rules/alerts/"

# Loop through each YAML file in the specified directory
for file in "$YAML_DIR"/*/*.{yaml,yml}; do

  # Check if file exists
  if [[ "$file" == *"-do-not-edit-"* ]]; then
    echo "Skip do-not-edit files: " $file
    continue
  fi
  
  # Check if file exists
  if [[ -f "$file" ]]; then
    echo "Processing file: $file"

    # Replace "slack" with "lark" in labels.integration without removing "pagerduty"
    yq -i '
      .groups[].rules[].labels.integration |=
      sub("slack"; "lark")' "$file"

    echo "Updated: $file"
  else
    echo "No YAML files found in the specified directory."
  fi
done