# Ansible Role: Remove Snap

Remove snap from Ubuntu and disable auto installation via Ubuntu apt backdooor.
Read more about the backdoor [here](https://linuxmint-user-guide.readthedocs.io/en/latest/snap.html#disabled-snap-store-in-linux-mint-20).

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
    - remove_snapd
```

### 📚️ Sources

Linux Mint User Guide on Snap Store:
🔗 URL: https://linuxmint-user-guide.readthedocs.io/en/latest/snap.html#disabled-snap-store-in-linux-mint-20

### ToDO
- [ ] Remove snap from PATH /snap/bin...
- [ ] Remove snap from XDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/snapd/desktop



### LICENSE
MIT

