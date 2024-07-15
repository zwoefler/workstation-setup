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
    echo "[INSTALL] Installing required packages:"
    echo "  - uidmap"
    echo "  - dbus-user-session"

    sudo apt update
    sudo apt install -y uidmap dbus-user-session

    echo "[INSTALL] Enable dbus user session"
    systemctl --user start dbus

    echo "[INSTALL] Installing nerdctl"
    TAR_FILE="nerdctl-full-$NERDCTL_VERSION-linux-amd64.tar.gz"
    if [ -f "$TAR_FILE" ]; then
        echo "[INSTALL] Tar file already exists. Using the local file: $TAR_FILE"
    else
        echo "[INSTALL] Downloading nerdctl"
        wget https://github.com/containerd/nerdctl/releases/download/v$NERDCTL_VERSION/$TAR_FILE
    fi
    sudo tar Cxzvvf /usr/local $TAR_FILE
    containerd-rootless-setuptool.sh install
    echo "[INSTALL] Successfully installed nerdctl"

    echo ""
    echo "Add /usr/sbin to PATH to run nerdctl"
    echo "export PATH=/usr/sbin:\$PATH"
    echo ""
    echo "Or add it to your .bashrc or .bash_profile"
    echo "export PATH=/usr/sbin:\$PATH >> ~/.bashrc"
}

uninstall_nerdctl() {
    echo "Uninstalling nerdctl, required packages and containerd"
    sudo apt remove -y uidmap

    systemctl --user stop containerd

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
    sudo rm -rv /home/$USER/.config/{cni,containerd,systemd}
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
        uninstall|delete|remove)
            uninstall_nerdctl
            exit 0
            ;;
        --version|-v)
            NERDCTL_VERSION="$2"
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