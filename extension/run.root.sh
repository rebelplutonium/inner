#!/bin/sh

dnf update --assumeyes &&
    dnf install --assumeyes dnf-plugins-core sudo &&
    dnf install --assumeyes python2-pip &&
    dnf install --assumeyes gnupg gnupg pass findutils &&
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo &&
    dnf install --assumeyes docker-common docker-latest &&
    dnf install --assumeyes man &&
    dnf install --assumeyes paperkey a2ps &&
    dnf install --assumeyes gnucash fuse-sshfs &&
    dnf install --assumeyes procps-ng &&
    sed -i "s+^# user_allow_other\$+user_allow_other+" /etc/fuse.conf &&
    mkdir /srv/ids &&
dnf clean all