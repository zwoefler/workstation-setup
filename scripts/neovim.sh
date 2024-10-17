#!/bin/bash

print_help() {
    echo "Usage: $0 [options]"
    echo "Install latest Neovim"
    echo "Run with sudo to install systemwide"
    echo ""
    echo "Options:"
    echo "  --help, -h   Show this help message"
    echo "  uninstall    Uninstall Neovim"
    echo ""
}

get_latest_tag() {
    echo "[INFO] Fetching latest Neovim version tag..."
    TAG_NAME=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep 'tag_name' | cut -d '"' -f 4)
    if [ -z "$TAG_NAME" ]; then
        echo "[ERROR] Could not fetch the latest Neovim version."
        exit 1
    fi
    echo "[INFO] Latest Neovim version: $TAG_NAME"
}

install_neovim() {
    get_latest_tag
    echo "[INSTALL] Installing Neovim $TAG_NAME"
    
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"

    wget "https://github.com/neovim/neovim/releases/download/${TAG_NAME}/nvim-linux64.tar.gz"
    tar xzvf nvim-linux64.tar.gz

    if [ "$EUID" -ne 0 ]; then
        echo "[INSTALL] Installing Neovim to ~/nvim"
        mv nvim-linux64 ~/nvim
        ln -s ~/nvim/bin/nvim ~/.local/bin/nvim
    else
        echo "[INSTALL] Installing Neovim to /opt/nvim"
        sudo mv nvim-linux64 /opt/nvim
        sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim
    fi

    cd ~
    rm -rf "$TMP_DIR"
    echo "[INSTALL] Neovim $TAG_NAME installed successfully"
}

uninstall_neovim() {
    echo "[UNINSTALL] Uninstalling Neovim"
    
    if [ -d "/opt/nvim" ]; then
        sudo rm -rf /opt/nvim
        sudo rm /usr/local/bin/nvim
        echo "[UNINSTALL] Neovim removed from /opt."
    elif [ -d "$HOME/nvim" ]; then
        rm -rf ~/nvim
        rm ~/.local/bin/nvim
        echo "[UNINSTALL] Neovim removed from ~/nvim."
    else
        echo "[UNINSTALL] Neovim installation not found."
    fi
}

install() {
    if ! command -v nvim &> /dev/null; then
        install_neovim
    else
        echo "Neovim is already installed."
        exit 0
    fi
}

case "$1" in
    "")
        install
        exit 0
        ;;
    uninstall|delete|remove)
        uninstall_neovim
        exit 0
        ;;
    help|--help|-h)
        print_help
        exit 0
        ;;
    *)
        print_help
        exit 1
        ;;
esac
