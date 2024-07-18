#!/bin/bash

list_dir="/etc/apt/sources.list.d"
nexus_url="http://localhost:8888/repository"

update_url() {
  local line="$1"
  if [[ $line =~ deb\ \[.*\]\ ([^[:space:]]+)\ ([^[:space:]]+)\ (.+) ]]; then
    url="${BASH_REMATCH[1]}"
    distribution="${BASH_REMATCH[2]}"
    components="${BASH_REMATCH[3]}"
    new_url="$nexus_url/$file_name"
    echo "${line/$url/$new_url}"
  elif [[ $line =~ deb\ ([^[:space:]]+)\ ([^[:space:]]+)\ (.+) ]]; then
    url="${BASH_REMATCH[1]}"
    distribution="${BASH_REMATCH[2]}"
    components="${BASH_REMATCH[3]}"
    new_url="$nexus_url/$file_name"
    echo "${line/$url/$new_url}"
  else
    echo "$line"
  fi
}

for list_file in "$list_dir"/*.list; do
  file_name=$(basename "$list_file" .list)

  temp_file=$(mktemp)

  while IFS= read -r line; do
    [[ $line =~ ^#.*$ ]] && echo "$line" >> "$temp_file" && continue
    updated_line=$(update_url "$line")
    echo "$updated_line" >> "$temp_file"
  done < "$list_file"

  mv -f "$temp_file" "$list_file"
  if [[ $? -ne 0 ]]; then
    echo "Failed to move $temp_file to $list_file. Permission denied."
    rm "$temp_file"
    exit 1
  fi

  chmod 644 "$list_file"
  if [[ $? -ne 0 ]]; then
    echo "Failed to set permissions for $list_file."
    exit 1
  fi
done

echo "All .list files have been updated."

