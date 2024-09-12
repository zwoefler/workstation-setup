# Ansible Role: VmChamp Debian Installation

Installs the latest VmChamp application to create VMs and SSH into them in seconds.

🔗 URL: https://github.com/zwoefler/VmChamp

⚠️ Doesn't add bash completion!
Add `source <(vmchamp --completion bash)` to your .bashrc.
Or check the [Docs on Shellcompletion](https://github.com/zwoefler/VmChamp/blob/master/README.md#add-shell-completion)

### Requirements
None.

### Role Variables
Defaults:
```YAML
vmchamp_github_api_url: https://api.github.com/repos/zwoefler/VmChamp/releases/latest
vmchamp_installation_path: /usr/local/bin/vmchamp
```

### Dependencies
None.

### Example Playbook
```YAML
- hosts: all
  roles:
    - vmchamp_debian_install
```

### ToDo
- [ ] Add Uninstall VmChamp role
- [ ] Set VmChamp version
- [ ] Provide binary from control node, and install from there

### LICENSE
MIT