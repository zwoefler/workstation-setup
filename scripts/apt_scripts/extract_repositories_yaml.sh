#!/bin/bash

list_dir="/etc/apt/sources.list.d"

echo "apt_repositories:"

extract_info() {
  local line="$1"
  if [[ $line =~ deb\ \[.*\]\ ([^[:space:]]+)\ ([^[:space:]]+)\ (.+) ]]; then
    url="${BASH_REMATCH[1]}"
    distribution="${BASH_REMATCH[2]}"
    components="${BASH_REMATCH[3]}"
    echo "  - name: \"$file_name\""
    echo "    url: \"$url\""
    echo "    distribution: \"$distribution\""
  elif [[ $line =~ deb\ ([^[:space:]]+)\ ([^[:space:]]+)\ (.+) ]]; then
    url="${BASH_REMATCH[1]}"
    distribution="${BASH_REMATCH[2]}"
    components="${BASH_REMATCH[3]}"
    echo "  - name: \"$file_name\""
    echo "    url: \"$url\""
    echo "    distribution: \"$distribution\""
  fi
}

for list_file in "$list_dir"/*.list; do
  file_name=$(basename "$list_file" .list)

  while IFS= read -r line; do
    [[ $line =~ ^#.*$ ]] && continue
    extract_info "$line"
  done < "$list_file"
done