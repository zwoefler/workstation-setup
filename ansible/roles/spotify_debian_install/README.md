# Ansible Role: Spotify Debian Installation

Ansible role to install debian package Spotify client.

🔗 URL: https://www.spotify.com/us/download/linux/

### Requirements
None.

### Role Variable
Variables from Spotify's webpage.
```YAML
spotify_source_list_filename: "spotify"
spotify_gpg_key_url: "https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg"
spotify_gpg_asc_key_path: "/etc/apt/keyrings/{{ spotify_source_list_filename }}.asc"
spotify_package_name: "spotify-client"
```

### Dependencies
None.

### Example Playbook
```YAML
- hosts: all
  roles:
    - spotify_debian_install
```

### Explanations
Bugs and Explanations why this playbook installation differs from Spotifys recommendations read [here](/ansible/roles/spotify_debian_install/docs/README.md)

### ToDos
- Update to Deb822

### LICENSE
MIT