#!/usr/bin/env bash
set -euo pipefail

cp -avf /ctx/system_files/. /
chmod 0755 /usr/bin/vanta-check /usr/bin/vanta-lab

# KVM uses the same Linux kernel on AMD-V and Intel VT-x.
dnf5 install -y qemu-kvm libvirt-daemon-kvm virt-manager

# Socket activation starts the daemons only when virtualization is used.
systemctl enable virtqemud.socket virtnetworkd.socket