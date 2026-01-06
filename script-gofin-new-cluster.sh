#!/bin/bash

# Define the directory containing the YAML files
#directory="/gofin"

# Define the new cluster names to add
new_clusters=("al-ma-id-p-01" "al-ma-id-s-01")

# Iterate over all YAML files in the directory
for file_path in prome/alerts/gofin/*.yaml; do
  # Add the new cluster names to the existing only_in_clusters sections
  for cluster in "${new_clusters[@]}"; do
    yq eval ".groups[] |= (select(has(\"only_in_clusters\")) | .only_in_clusters += [\"$cluster\"] | .only_in_clusters |= unique)" -i "$file_path"
  done
done

echo "Cluster names added to all relevant YAML files."