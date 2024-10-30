# Ansible Role: Obsidian

Install [Obsidian](https://obsidian.md/).
Installs the latest version, a specific version, or uninstalls Obsidian.
A simple yet powerful application for notetaking that works on local Markdown files.

Rerun triggers an update.

## Requirements

- Ansible 2.9 or later
- A Debian/Ubuntu system

## Dependencies
None.

## Testing & Development
Using Ansible Molecule for testing:
```SHELL
molecule create
molecule converge
```

## Role Variables

```yaml
vars:
  obsidian_version: ""               # specific version (e.g., "1.7.4"). Leave blank for latest
  local_deb_file: ""                 # path to local .deb file
  uninstall_obsidian: false          # true to uninstall Obsidian
  obsidian_deb_file_path: "/tmp/obsidian_{{ obsidian_version }}_amd64.deb"
```

## Usage
Example Playbook:

```yaml
---
- name: Manage Obsidian Installation
  hosts: all
  become: yes
  vars:
    uninstall_obsidian: false  # true to uninstall Obsidian
    local_deb_file: ""         # path to local .deb file
    obsidian_version: ""        # specific version (e.g., "1.7.4"). Leave blank for latest
  roles:
    - role: obsidian_debian_install
```

Then run:
```bash
ansible-playbook install_obsidian.yml
```

## Use Cases
1. Install the Latest Version

```yaml
vars:
  uninstall_obsidian: false
  local_deb_file: ""
  obsidian_version: ""
```

2. Install a Specific Version
```yaml
vars:
  uninstall_obsidian: false
  local_deb_file: ""
  obsidian_version: "1.7.4"
```

3. Install from a Local .deb File
```yaml
vars:
  uninstall_obsidian: false
  local_deb_file: "/path/to/obsidian.deb"
  obsidian_version: ""
```

4. Uninstall Obsidian
```yaml
vars:
  uninstall_obsidian: true
  local_deb_file: ""
  obsidian_version: ""
```

## Problems
- obsidian: error while loading shared libraries: libgbm.so.1: cannot open shared object file: No such file or directory


### LICENSE
MIT

