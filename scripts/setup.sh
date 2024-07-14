#!/bin/bash

if [ -n "$SUDO_USER" ]; then
    user_home=$(getent passwd $SUDO_USER | cut -d: -f6)
else
    user_home=$HOME
fi

echo ""
echo "##################"
echo "[APT]"
echo "##################"
update_apt_cache() {
    local last_update=$(stat -c %Y /var/cache/apt/pkgcache.bin)
    local now=$(date +%s)
    local elapsed

    let elapsed=now-last_update
    if [ "$elapsed" -gt 3600 ]; then
        echo "[APT] Running apt update..."
        sudo apt update
    else
        echo "[APT] Skipping apt update, performed recently."
    fi
}

update_apt_cache

echo "[APT] Upgrading packages..."
sudo apt upgrade -y

echo "[APT] Remove packages..."
sudo apt remove -y nano

echo "[APT] Installing packages..."
sudo apt install -y vim git jq tree python3-pip firefox-esr openssh-client ffmpeg

echo "######################"
echo ""

echo "############################"
echo "[SSH] CREATE SSH KEYS"
echo "############################"
if systemctl is-active --quiet ssh; then
    echo "[SSH] SSH service active."
else
    echo "[SSH] Starting SSH service..."
    systemctl start ssh
fi

if [ ! -f "$user_home/.ssh/id_rsa" ]; then
    echo "[SSH-KEY] - CREATING - Create standard SSH key..."
    ssh-keygen -t rsa -b 2048 -f $user_home/.ssh/id_rsa -N ''
fi

if [ ! -f "$user_home/.ssh/github_rsa" ]; then
    echo "[SSH-KEY] - CREATING - Creating GitHub SSH key..."
    ssh-keygen -t rsa -b 2048 -f $user_home/.ssh/github_rsa -N ''
fi

echo "##########################"
echo ""

echo "############################"
echo "# .BASHRC"
echo "############################"
script_path=$(dirname "$0")
local_bashrc="${script_path}/dot-files/.bashrc"
remote_url="https://raw.githubusercontent.com/zwoefler/workstation-setup/master/dot-files/.bashrc"
bashrc_path="$user_home/.bashrc"

if [ -f "$local_bashrc" ]; then
    echo "[DOT-FILES] Copy local .bashrc"
    cp "$local_bashrc" "$bashrc_path"
else
    echo "[DOT-FILES] Pulling .bashrc from GitHub..."
    curl -sLo "$bashrc_path" "$remote_url"
fi

echo "############################"
echo "# VMCHAMP"
echo "############################"
check_CPU_supports_virtualisation() {
    if ! egrep -c '(vmx|svm)' /proc/cpuinfo &> /dev/null; then
        echo "[VMCHAMP] ERROR: Your CPU does not support virtualization."
        exit 1
    fi
}

install_vmchamp() {
    echo "[VMCHAMP] Downloading and installing VmChamp..."
    wget -qO- https://api.github.com/repos/zwoefler/VmChamp/releases/latest | grep "browser_download_url" | cut -d '"' -f 4 | wget -i - -O vmchamp
    chmod +x vmchamp
    sudo mv vmchamp /usr/local/bin/
    echo "[VMCHAMP] VmChamp installed successfully."

    echo "[VMCHAMP] Checking requirements for KVM and libvirt..."
    if ! dpkg -l | grep -qw qemu-kvm; then
        echo "[VMCHAMP] KVM is not installed. Installing..."
        sudo apt update
        sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
        echo "[VMCHAMP] KVM and related packages installed."
    else
        echo "[VMCHAMP] KVM is already installed."
    fi

    echo "[VMCHAMP] Adding user $USER to groups 'libvirt' and 'kvm'..."
    sudo adduser "$USER" libvirt
    sudo adduser "$USER" kvm
    echo "[VMCHAMP] User $USER added to 'libvirt' and 'kvm' groups successfully."
}

if ! command -v vmchamp &> /dev/null; then
    check_CPU_supports_virtualisation
    install_vmchamp
else
    echo "[VMCHAMP] VmChamp is already installed."
fi

echo "###################"
echo "# NERDCTL"
echo "###################"
NERDCTL_VERSION=1.7.6

install_nerdctl() {
    echo "[NERDCTL] Installing Rootless nerdctl version: $NERDCTL_VERSION"
    echo "[NERDCTL] Checking requirement uidmap package is installed"
    if ! dpkg -l | grep -q uidmap; then
        echo "[NERDCTL] uidmap not installed. Installing..."
        sudo apt install -y uidmap
    fi

    echo "[NERDCTL] Add /usr/sbin to PATH for compatibility"
    PATH="/usr/sbin:$PATH"

    echo "[NERDCTL] Installing nerdctl"
    wget https://github.com/containerd/nerdctl/releases/download/v$NERDCTL_VERSION/nerdctl-full-$NERDCTL_VERSION-linux-amd64.tar.gz
    sudo tar Cxzvvf /usr/local nerdctl-full-$NERDCTL_VERSION-linux-amd64.tar.gz
    containerd-rootless-setuptool.sh install
    echo "[NERDCTL] Successfully installed NERDCTL"
}

if command -v nerdctl &> /dev/null; then
    echo -e "nerdctl is already installed."
else
    install_nerdctl
fi

echo "############################"
echo "# FINISHED"
echo "# Run the following to end setup:"
echo "# source ~/.bashrc"
echo "############################"