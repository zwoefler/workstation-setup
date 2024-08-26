#!/bin/bash
# Install Node Version Manager from GitHub

NVM_VERSION="0.40.0"

print_help() {
    echo "Usage: $0 [options]"
    echo "Install nvm (Node Version Manager)"
    echo "Installs latest Node LTS (Long term support) version"
    echo ""
    echo "Options:"
    echo "  install                 Install nvm"
    echo "  --version, -v VERSION   Install specific version. Provide in X.Y.Z form (e.g., 0.40.0)"
    echo "  uninstall               Uninstall nvm"
    echo "  --help, -h              Show this help message"
    echo ""
}

install_nvm() {
    echo "[INSTALL] Download and install nvm"
    wget -qO- "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | bash

    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 

    nvm install --lts

    echo "[INSTALL] nvm installation complete."
    echo "Restart your terminal or run:"
    echo "source ~/.bashrc"
}

uninstall_nvm() {
    echo "[UNINSTALL] Uninstalling nvm"
    rm -rf "$HOME/.nvm"
    
    sed -i '/NVM_DIR/d' ~/.bashrc
    sed -i '/nvm.sh/d' ~/.bashrc
    sed -i '/NVM_DIR/d' ~/.zshrc
    sed -i '/nvm.sh/d' ~/.zshrc

    echo "[UNINSTALL] nvm has been uninstalled."
    echo "Restart your terminal or run:"
    echo "source ~/.bashrc"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        install)
            install_nvm
            exit 0
            ;;
        --version|-v)
            NVM_VERSION="$2"
            shift 2
            ;;
        uninstall|delete|remove)
            uninstall_nvm
            exit 0
            ;;
        --help|-h)
            print_help
            exit 0
            ;;
        *)
            print_help
            exit 1
            ;;
    esac
done

if [ $# -eq 0 ]; then
    print_help
fi

