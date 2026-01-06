#!/bin/bash

# Directory containing YAML files (adjust as needed)
YAML_DIR="alertmngr/routes/teams"

# Loop through each YAML file in the specified directory
for file in "$YAML_DIR"/*.{yml,yaml}; do
  # Check if file exists
  if [[ "$file" == *"-do-not-edit-"* ]]; then
    echo "Skip do-not-edit files: " $file
    continue
  fi

  #Skip specific files
  if [[ "$file" == "$YAML_DIR/gopay.yaml" || "$file" == "$YAML_DIR/order-management.yaml" ]]; then
    echo "Skip specific files: " $file
    continue
  fi

  # Check if file exists
  if [[ -f "$file" ]]; then
    echo "Processing file: $file"

    #remove receiver.name blocks that contains slack
    yq -i '
      .alertmanagerFiles."alertmanager.yml".receivers |=
      map(select(.name | test("slack") | not))' "$file" 

    echo "Updated: $file"
  else
    echo "No YAML files found in the specified directory."
  fi
done
