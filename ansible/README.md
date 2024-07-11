# ANSIBLE

Run:
```SHELL
# LOCALLY
ansible-playbook -i "localhost," -c local full_install.yml --ask-become-pass

# REMOTE
ansible-playbook -i inventory.yml full_install.yml
```

Check if inventory works
```SHELL
ansible -i inventory.yml all -m ping
```
