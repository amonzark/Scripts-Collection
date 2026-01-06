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

    #step 1 replace .*slack.* to .*lark.* in match_re.integration
    # yq -i '
    #   .alertmanagerFiles."alertmanager.yml".route.routes |=
    #   map(
    #     .match_re.integration |= sub("slack"; "lark")
    #   )' "$file" 

    #step 2 remove match_re blocks that contains *-slack in match_re.receiver
    yq -i '
      .alertmanagerFiles."alertmanager.yml".route.routes |=
      map(select(.receiver | test("slack") | not))' "$file" 

    #step 3 replace .*lark.*|.*lark.* to only .*lark.*
    # yq -i '
    #   .alertmanagerFiles."alertmanager.yml".route.routes |=
    #   map(
    #     .match_re.integration |= sub(".*lark.*|.*lark.*"; ".*lark.*")
    #   )' "$file" 

    echo "Updated: $file"
  else
    echo "No YAML files found in the specified directory."
  fi
done
