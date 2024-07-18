# Apt Scripts

## Get List of Nexus Repositories to create
1. Run:
```SHELL
sudo ./update_apt_sources.sh
./extract_repositories_yaml.sh
```

2. Copy the output to the Ansible Inventory

**Want to reset?:**
```SHELL
sudo sh -c 'for file in /etc/apt/sources.list.d/*.list.save; do cp "$file" "${file%.save}"; done'
```

- `extract_repositories_json.sh` and
- `extract_repositories_yaml.sh`
create a JSON and YAML output of locally installed apt sources.
Use the output to create the APT repositories in Nexus.

The `update_apt_source.sh` script rewrites the remote URLs in the apt sources files to the Nexus URL `http://localhost:8888/repository/<NAME>`.
