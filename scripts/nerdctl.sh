#!/bin/bash

NERDCTL_VERSION=1.7.6

print_help() {
    echo "Usage: $0 [options]"
    echo "Install rootless nerdctl version: $NERDCTL_VERSION"
    echo ""
    echo "Options:"
    echo "  --version, -v VERSION   Set the NERDCTL_VERSION to install"
    echo "  --help, -h              Show this help message"
    echo "  uninstall               Uninstall nerdctl"
    echo ""
}

install_nerdctl() {
    echo "[INSTALL] Installing Rootless nerdctl version: $NERDCTL_VERSION"
    echo "[INSTALL] Checking requirement uidmap package is installed"
    if ! dpkg -l | grep -q uidmap; then
        echo "[INSTALL] uidmap not installed. Installing..."
        sudo apt update
        sudo apt install -y uidmap
    fi

    echo "[INSTALL] Installing nerdctl"
    wget https://github.com/containerd/nerdctl/releases/download/v$NERDCTL_VERSION/nerdctl-full-$NERDCTL_VERSION-linux-amd64.tar.gz
    sudo tar Cxzvvf /usr/local nerdctl-full-$NERDCTL_VERSION-linux-amd64.tar.gz
    containerd-rootless-setuptool.sh install
    echo "[INSTALL] Successfully installed nerdctl"
}

uninstall_nerdctl() {
    echo "Uninstalling nerdctl, required packages and containerd"
    sudo apt remove -y uidmap

    echo "Removing Containerd and nerdctl"
    # Stolen from 1nachi
    # GITHUB GIST: https://gist.github.com/1nachi
    # https://gist.github.com/1nachi/3d283a216481078c147fce784fdbecc6#file-containerd-purge-sh
    sudo rm -v /usr/local/bin/{containerd*,buildctl,buildkitd,bypass4*,ctd-decoder,ctr*,fuse-overlayfs,ipfs,nerdctl,rootlessctl,rootlesskit,runc,slirp4netns,tini}
    sudo rm -v /usr/local/lib/systemd/system/{containerd.service,buildkit.service,stargz-snapshotter.service}
    sudo rm -rv /opt/{cni,containerd}
    sudo rm -v /usr/local/sbin/runc
    sudo rm -rv $XDG_RUNTIME_DIR/{buildkit,containerd-rootless}
    sudo rm -rv /usr/local/share/doc/nerdctl*
    sudo rm -v /etc/bash_completion.d/nerdctl
}

install() {
    if command -v nerdctl &> /dev/null; then
        echo -e "[INSTALL] nerdctl is already installed."
    else
        install_nerdctl
    fi
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        "")
            install
            ;;
        uninstall)
            uninstall_nerdctl
            exit 0
            ;;
        --version|-v)
            NERDCTL_VERSION="$2"
            shift 2
            install
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