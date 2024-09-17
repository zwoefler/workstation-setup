# Ansible Role: VSCode Debian Installation

Install latest VSCode.

Tested on:
- Ubuntu2404 LTS

### Requirements
None.

### Role Variables

### Dependencies
None.

### Example Playbook
```YAML
- name: Install VSCode
  roles:
    - role: vscode_debian_install
      vars:
        vscode_action: "install"  # Optional, "install" is default.

```

### ToDo
- [ ] Rerun updates if version is higher
- [ ] Add Uninstall VSCode role

### LICENSE
MIT