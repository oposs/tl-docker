#!/bin/sh
set -e
set -x
echo Installing Ubuntu $UBUNTU_RELEASE
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -yq apt-utils
yes | unminimize
apt-get update
apt-get install -yq \
    vim \
    locales \
    binutils \
    dialog \
    openssh-server \
    sudo \
    iproute2 \
    curl \
    lsb-release \
    less \
    joe \
    man-db \
    net-tools \
    python-apt \
    python \
    ubuntu-desktop
apt-get -qq clean
apt-get -qq autoremove 

# disable services we do not need
systemctl disable gdm snapd wpa_supplicant upower sendmail fstrim.timer fstrim e2scrub_reap e2scrub_all e2scrub_all.timer

# Prevents apt-get upgrade issue when upgrading in a container environment.
# Similar to https://bugs.launchpad.net/ubuntu/+source/makedev/+bug/1675163
cp makedev /etc/apt/preferences.d/makedev

cp locale.conf /etc/locale.conf
cp locale /etc/default/locale
cp locale.gen /etc/locale.gen
locale-gen

# make sure we get fresh ssh keys on first boot
/bin/rm -f -v /etc/ssh/ssh_host_*_key*
cp *.service /etc/systemd/system
systemctl enable regenerate_ssh_host_keys
# Remove the divert that disables services
rm -f /sbin/initctl
dpkg-divert --local --rename --remove /sbin/initctl
