#!/bin/sh

pip install awscli --upgrade --user &&
    echo "export PATH=\${HOME}/.local/bin:\${PATH}" >> ${HOME}/.bashrc &&
    mkdir /home/user/.ssh &&
    chmod 0700 /home/user/.ssh &&
    echo 'Include ~/.ssh/config.d/*' > /home/user/.ssh/config &&
    chmod 0600 /home/user/.ssh/config &&
    mkdir /home/user/.ssh/config.d &&
    chmod 0700 /home/user/.ssh/config.d &&
    mkdir /home/user/bin