#!/bin/bash

list_dir="/etc/apt/sources.list.d"

echo "["

extract_info() {
  local line="$1"
  if [[ $line =~ deb\ \[.*\]\ ([^[:space:]]+)\ ([^[:space:]]+)\ (.+) ]]; then
    url="${BASH_REMATCH[1]}"
    distribution="${BASH_REMATCH[2]}"
    components="${BASH_REMATCH[3]}"
    echo "    {\"url\": \"$url\", \"distribution\": \"$distribution\", \"components\": \"$components\"},"
  elif [[ $line =~ deb\ ([^[:space:]]+)\ ([^[:space:]]+)\ (.+) ]]; then
    url="${BASH_REMATCH[1]}"
    distribution="${BASH_REMATCH[2]}"
    components="${BASH_REMATCH[3]}"
    echo "    {\"url\": \"$url\", \"distribution\": \"$distribution\", \"components\": \"$components\"},"
  fi
}

for list_file in "$list_dir"/*.list; do
  file_name=$(basename "$list_file" .list)
  echo "  {"
  echo "    \"name\": \"$file_name\","
  echo "    \"repositories\": ["
  
  while IFS= read -r line; do
    [[ $line =~ ^#.*$ ]] && continue
    extract_info "$line"
  done < "$list_file"
  echo "    ]"
  echo "  },"
done

# End JSON array
echo "]"

