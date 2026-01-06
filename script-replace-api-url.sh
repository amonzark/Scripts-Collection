#!/bin/bash

# Define the new API URL
new_api_url="https://katulampa-lark-app.gopayapi.com/notify"

path="altmngr/routes/teams"

# Iterate over all YAML files in the directory, excluding files with '-do-not-edit-' in their names
for file_path in $(find "$path" -name "*.{yaml,yml}" ! -name "*-do-not-edit-*"); do
  # Update the api_url field under receivers
  yq eval '(.receivers[] | select(has("api_url")) | .api_url) = "'$new_api_url'"' -i "$file_path"
done

echo "api_url updated in all relevant YAML files."