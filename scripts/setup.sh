#!/bin/bash

# Run as root?
if [ "$(id -u)" -ne 0 ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

update_apt_cache() {
    local last_update=$(stat -c %Y /var/cache/apt/pkgcache.bin)
    local now=$(date +%s)
    local elapsed

    let elapsed=now-last_update
    if [ "$elapsed" -gt 3600 ]; then
        echo "Running apt update..."
        apt update
    else
        echo "Skipping apt update, performed recently."
    fi
}

update_apt_cache

echo "Upgrading packages..."
apt-get upgrade -y

echo "Remove packages..."
apt-get remove -y nano

echo "Installing packages..."
apt-get install -y vim git jq tree python3-pip firefox-esr