#!/bin/bash

LOCAL_DEB_FILE=""

print_help() {
    echo "Usage: $0 [options]"
    echo "Installs Obsidian version: $OBSIDIAN_VERSION by default"
    echo ""
    echo "Options:"
    echo "  --version, -v VERSION   Install specific version. Provide in X.Y.Z form (e.g., 1.6.7)"
    echo "  --local, -l FILE        Install from a local .deb file"
    echo "  uninstall               Uninstall Obsidian"
    echo "  --help, -h              Show this help message"
    echo ""
}

get_latest_tag() {
    echo "[INFO] Fetching latest Obsidian version tag..."
    TAG_NAME=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | grep 'tag_name' | cut -d '"' -f 4)
    if [ -z "$TAG_NAME" ]; then
        echo "[ERROR] Could not fetch the latest Obsidian version."
        exit 1
    fi
    echo "[INFO] Latest Obsidian version: $TAG_NAME"
}

install_obsidian() {
    get_latest_tag
    OBSIDIAN_VERSION="${TAG_NAME#v}"
    echo "[INSTALL] Installing dependencies"
    sudo apt install -y libgbm1 libasound2

    if [ -n "$LOCAL_DEB_FILE" ]; then
        echo "[INSTALL] Installing Obsidian from local file: $LOCAL_DEB_FILE"
        sudo apt install -y ./"$LOCAL_DEB_FILE"
    else
        OBSIDIAN_DEB_FILE_DASH="obsidian-${OBSIDIAN_VERSION}-amd64.deb"
        OBSIDIAN_DEB_FILE_UNDERSCORE="obsidian_${OBSIDIAN_VERSION}_amd64.deb"

        echo "[INSTALL] Installing Obsidian version ${OBSIDIAN_VERSION}"
        if wget "https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/${OBSIDIAN_DEB_FILE_DASH}"; then
            OBSIDIAN_DEB_FILE="${OBSIDIAN_DEB_FILE_DASH}"
            echo "[INSTALL] Using dashed file"
        elif wget "https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/${OBSIDIAN_DEB_FILE_UNDERSCORE}"; then
            OBSIDIAN_DEB_FILE="${OBSIDIAN_DEB_FILE_UNDERSCORE}"
            echo "[INSTALL] Using underscored file"

        sudo apt install -y ./${OBSIDIAN_DEB_FILE}
        rm ./${OBSIDIAN_DEB_FILE}
        fi
    fi
}

uninstall_obsidian() {
    sudo apt remove -y obsidian
    echo "[UNINSTALL] Removed Obsidian"
}

install() {
    if ! command -v obsidian &> /dev/null; then
        install_obsidian
    else
        echo "Obsidian is already installed."
        exit 0
    fi
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        uninstall|delete|remove)
            uninstall_obsidian
            exit 0
            ;;
        --version|-v)
            OBSIDIAN_VERSION="$2"
            shift 2
            ;;
        --local|-l)
            LOCAL_DEB_FILE="$2"
            shift 2
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
    install
fi
