# Ansible Role: Spotify Debian Installation

Ansible role to install debian package Spotify client.

🔗 URL: https://www.spotify.com/us/download/linux/

### Requirements
None.

### Role Variable
Variables from Spotify's webpage.
```YAML
spotify_gpg_key_url: https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg
spotify_repo_url: deb http://repository.spotify.com stable non-free
spotify_package_name: spotify-client
```

### Dependencies
None.

### Example Playbook
```YAML
- hosts: all
  roles:
    - spotify_debian_install
```

### LICENSE
MIT