#!/bin/bash

# Directory containing the .list files
list_dir="/etc/apt/sources.list.d"

# Start JSON array
echo "["

# Function to extract URL, distribution, and components from a line
extract_info() {
  local line="$1"
  if [[ $line =~ deb\ \[.*\]\ ([^[:space:]]+)\ ([^[:space:]]+)\ (.+) ]]; then
    url="${BASH_REMATCH[1]}"
    distribution="${BASH_REMATCH[2]}"
    components="${BASH_REMATCH[3]}"
    echo "  {\"url\": \"$url\", \"distribution\": \"$distribution\", \"components\": \"$components\"},"
  elif [[ $line =~ deb\ ([^[:space:]]+)\ ([^[:space:]]+)\ (.+) ]]; then
    url="${BASH_REMATCH[1]}"
    distribution="${BASH_REMATCH[2]}"
    components="${BASH_REMATCH[3]}"
    echo "  {\"url\": \"$url\", \"distribution\": \"$distribution\", \"components\": \"$components\"},"
  fi
}

# Iterate over each .list file in the directory
for list_file in "$list_dir"/*.list; do
  while IFS= read -r line; do
    [[ $line =~ ^#.*$ ]] && continue
    extract_info "$line"
  done < "$list_file"
done

# End JSON array
echo "]"

