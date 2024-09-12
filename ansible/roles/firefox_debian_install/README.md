# Ansible Role: Firefox Debian Installation

Ansible role to install debian package Firefox via mozilla ppa.

Following Mozillas Installation Guide:
🔗 URL: https://support.mozilla.org/en-US/kb/install-firefox-linux

### Requirements
None.

### Role Variables
```YAML
mozilla_gpg_key_url: https://packages.mozilla.org/apt/repo-signing-key.gpg
mozilla_gpg_asc_key_path: /etc/apt/keyrings/packages.mozilla.org.asc
```


### Dependencies
None.

### Example Playbook
```YAML
- hosts: all
  roles:
    - firefox_debian_install
```

### LICENSE
MIT
