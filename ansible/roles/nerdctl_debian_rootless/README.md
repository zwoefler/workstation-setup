# Ansible Role: Nerdctl rootless install

Install rootless Nerdctl on Debian/Ubuntu systems.

Tested on:
- Ubuntu 24.04 LTS

### Requirements
None.

### Dependencies
None.

### Role Variable
None.

### Example Playbook
```YAML
- hosts: all
  roles:
    - role: nerdctl_debian_install
```

### 📚️ Sources


### ToDO
- [X] Activate Bash completion
- [ ] Provide uninstall/purge option
- [ ] Provide binary from control node
- [ ] Provide binary on path on remote node

### LICENSE
MIT

