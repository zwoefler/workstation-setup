#!/bin/bash

print_help() {
    echo "Usage: $0 [options]"
    echo "Installs VmChamp"
    echo ""
    echo "Options:"
    echo "  --help, -h   Show this help message"
    echo "  uninstall    Uninstall VmChamp"
    echo ""
}

install_vmchamp() {
    echo "[INSTALL] checking requirements kvm and libvirt"
    if ! dpkg -l | grep -q qemu-kvm; then
        echo "KVM is not installed. Installing..."
        sudo apt update
        sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
    fi

    echo "[INSTALL] Add $USER to group libvirt and kvm"
    sudo adduser "$USER" libvirt
    sudo adduser "$USER" kvm

    echo "[INSTALL] Downloading and installing VmChamp..."
    wget https://github.com/wubbl0rz/VmChamp/releases/download/v0.0.7/VmChamp-linux-v0.0.7-amd64
    mv VmChamp-linux-v0.0.7-amd64 vmchamp
    chmod +x vmchamp
    sudo mv vmchamp /usr/local/bin/
    echo "[INSTALL] VmChamp installed successfully."
}


uninstall_vmchamp() {
    echo "Uninstalling VmChamp..."
    sudo rm -rf /usr/local/bin/vmchamp
    echo "VmChamp uninstalled successfully."

    echo "Uninstalling packages..."
    sudo apt purge -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
    sudo apt autoremove -y
    echo "Packages uninstalled successfully."

    echo "Removing user from groups..."
    sudo deluser "$USER" libvirt
    sudo deluser "$USER" kvm
    echo "User removed from groups successfully."
}

check_CPU_supports_virtualisation() {
    if ! egrep -c '(vmx|svm)' /proc/cpuinfo &> /dev/null; then
        echo "ERROR: Your CPU does not support virtualization."
        exit 1
    fi
}


install() {
    if ! command -v vmchamp &> /dev/null; then
        check_CPU_supports_virtualisation
        install_vmchamp
    else
        echo "VmChamp is already installed."
        exit 0
    fi
}

case "$1" in
    "")
        install
        ;;
    uninstall)
        uninstall_vmchamp
        ;;
    help | --help | -h)
        print_help
        ;;
    *)
        print_help
        ;;
esac