# SCRIPTS


Install software via script:
```BASH
curl https://raw.githubusercontent.com/zwoefler/workstation-setup/main/scripts/<APPLICATION_NAME>.sh | sudo bash -
```

## Base setup
Install base setup:
```BASH
curl https://raw.githubusercontent.com/zwoefler/workstation-setup/main/scripts/setup.sh | sudo bash -
```

- Updates apt packages
- Removes nano
- Installs: vim, git, jq, tree, python3-pip, firefox-esr, openssh-client, ffmpeg
- Creates SSH keys: id_rsa and github
- Install .bashrc
- Install VSCode
- Install VmChamp (And virtualization packages)
- Install Nerdctl (+containerd depedencies)

## 🏗️ ToDos
Add `private.sh` install script:
Installs:
- [ ] Steam
- [ ] Nvidia drivers
- [ ] Obsidian
- [ ] Spotify
- [ ] Obsidian
- [ ] Signal
- [ ] gThumb
- [ ] LibreOffice
