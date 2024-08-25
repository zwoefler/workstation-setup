#!/bin/bash

print_help() {
    echo "Usage: $0 [options]"
    echo "Installs VSCode"
    echo ""
    echo "Options:"
    echo "  --help, -h   Show this help message"
    echo "  uninstall    Uninstall VSCode"
    echo ""
}

install_vscode() {
    sudo apt install -y wget gpgpt
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f packages.microsoft.gpg

    sudo apt update
    sudo apt install -y code
}


uninstall_vscode() {
    echo "[UNINSTALL] VSCODE" 
    GPG_KEY_FILE="/etc/apt/keyrings/packages.microsoft.gpg"
    APT_SOURCE_LIST="/etc/apt/sources.list.d/vscode.list"

    if [ -f "$GPG_KEY_FILE" ]; then
        sudo rm "$GPG_KEY_FILE"
        echo "[UNINSTALL] GPG key removed"
    else
        echo "[UNINSTALL] No Microsoft GPG key found at $GPG_KEY_FILE:"
        echo "[UNINSTALL] Skipping GPG removal"
    fi

    if [ -f "$APT_SOURCE_LIST" ]; then
        sudo rm "$APT_SOURCE_LIST"
        echo "[UNINSTALL] APT source list removed."
    else
        echo "[UNINSTALL] No APT source list for Visual Studio Code found."
        echo "[UNINSTALL] Skipping APT source removal."
    fi

    sudo apt remove -y code
    echo "[UNINSTALL] VSCode removed"
}

install() {
    if ! command -v code &> /dev/null; then
        install_vscode
    else
        echo "VSCode is already installed."
        exit 0
    fi
}

case "$1" in
    "")
        install
        exit 0
        ;;
    uninstall|delete|remove)
        uninstall_vscode
        exit 0
        ;;
    help | --help | -h)
        print_help
        exit 0
        ;;
    *)
        print_help
        exit 1
        ;;
esac
