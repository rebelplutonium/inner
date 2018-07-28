#!/bin/sh

dnf update --assumeyes &&
    dnf install --assumeyes dnf-plugins-core sudo &&
    dnf install --assumeyes python2-pip &&
    dnf install --assumeyes gnupg gnupg pass findutils &&
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo &&
    dnf install --assumeyes docker-common docker-latest &&
    dnf install --assumeyes man &&
    dnf install --assumeyes procps-ng &&
    dnf install --assumeyes iputils &&
    ls -1 /opt/cloud9/extension/completion | while read SCRIPT
    do
        cp /opt/cloud9/extension/completion/${SCRIPT} /etc/bash_completion.d/${SCRIPT%.*} &&
            chmod 0644 /etc/bash_completion.d/${SCRIPT%.*}
    done &&
    echo "user ALL=(ALL) NOPASSWD:SETENV:ALL" > /etc/sudoers.d/user &&
    chmod 0444 /etc/sudoers.d/user &&
    dnf clean all