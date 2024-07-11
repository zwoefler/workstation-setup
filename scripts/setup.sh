#!/bin/bash

# Run as root?
if [ "$(id -u)" -ne 0 ]; then
   echo "[ROOT?] This script must be run as root" 1>&2
   exit 1
fi

update_apt_cache() {
    local last_update=$(stat -c %Y /var/cache/apt/pkgcache.bin)
    local now=$(date +%s)
    local elapsed

    let elapsed=now-last_update
    if [ "$elapsed" -gt 3600 ]; then
        echo "[APT] Running apt update..."
        apt update
    else
        echo "[APT] Skipping apt update, performed recently."
    fi
}

update_apt_cache

echo "[APT] Upgrading packages..."
apt-get upgrade -y

echo "[APT] Remove packages..."
apt-get remove -y nano

echo "[APT] Installing packages..."
apt-get install -y vim git jq tree python3-pip firefox-esr openssh-client

############################
# CREATE SSH KEYS
############################
if systemctl is-active --quiet ssh; then
    echo "SSH service active."
else
    echo "Starting SSH service..."
    systemctl start ssh
fi

if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "[SSH-KEY] - CREATING - Create standard SSH key..."
    su -c "ssh-keygen -t rsa -b 2048 -f $HOME/.ssh/id_rsa -N ''" -s /bin/sh $SUDO_USER
fi

if [ ! -f "$HOME/.ssh/github_rsa" ]; then
    echo "[SSH-KEY] - CREATING - Creating GitHub SSH key..."
    su -c "ssh-keygen -t rsa -b 2048 -f $HOME/.ssh/github_rsa -N ''" -s /bin/sh $SUDO_USER
fi

############################
# INSTALL PYTHON PACKAGES
############################
echo "[PIP] Installing Ansible..."
pip3 install ansible

echo "[COMPLETE] All tasks completed successfully."