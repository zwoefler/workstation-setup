#!/bin/bash

print_help() {
    echo "Usage: $0 [options]"
    echo "Removes snapd"
    echo ""
    echo "Options:"
    echo "  --help, -h   Show this help message"
}

remove_snapd() {
    # Check if snapd service exists and disable/unmask it if it does
    if systemctl list-units --type=service | grep -q 'snapd.service'; then
        echo "Disabling and unmasking snapd service..."
        sudo systemctl stop snapd
        sudo systemctl disable snapd
        sudo systemctl unmask snapd
    else
        echo "snapd.service does not exist."
    fi

    echo "Uninstalling snapd package..."
    sudo apt-get purge -y snapd

    echo "Snap removal complete."
}

while [[ $# -gt 0 ]]; do
    case "$1" in
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

remove_snapd
