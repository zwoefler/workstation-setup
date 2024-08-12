# ANSIBLE

Run:
```SHELL
# LOCALLY
ansible-playbook -i "localhost," -c local full_install.yml --ask-become-pass

# With local inventory
ansible-playbook -i inventories/localhost.yaml nexus3_ice_install.yaml

# REMOTE
ansible-playbook -i inventory.yml full_install.yml
```

Check if inventory works
```SHELL
ansible -i inventory.yml all -m ping
```


---

## Offline Work - ICE Setup
While traveling (with the ICE) there will not always be internet.
Playbook that setups up a working environment for offline work:
- Nexus3: Stores repositories for Apt, node, Docker Images, github binaries

- [X] Setup Nexus3 as Container
- [X] Configure a password
- [ ] Setup repositories:
    - [X] Apt repos
    - [ ] Node packages / repos
    - [ ] GitHub binaries
- [ ] Configure Yum repositories
