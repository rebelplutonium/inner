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
    ls -1 /home/user/extension/completion | while read SCRIPT
    do
        cp /home/user/extension/completion/${SCRIPT} /etc/bash_completion.d/${SCRIPT%.*} &&
            chmod 0644 /etc/bash_completion.d/${SCRIPT%.*}
    done &&
    dnf clean all