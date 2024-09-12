# Ansible Role: Steam Ubuntu Installation

Install Steam Client debian package.

### Requirements
None.

### Dependencies
None.

### Role Variable
URL for debian package from a button on: https://store.steampowered.com/about/
```YAML
steam_deb_url: https://cdn.akamai.steamstatic.com/client/installer/steam.deb
steam_apt_download_path: /tmp/steam.deb
```

### Example Playbook
```YAML
- hosts: all
  roles:
    - steam_ubuntu_install
```

### LICENSE
MIT