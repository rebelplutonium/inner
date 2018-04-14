#!/bin/sh

pip install awscli --upgrade --user &&
    echo "export PATH=\${HOME}/.local/bin:\${PATH}" >> ${HOME}/.bashrc &&
    mkdir ${HOME}/.ssh &&
    chmod 0700 ${HOME}/.ssh &&
    echo 'Include ~/.ssh/config.d/*' > ${HOME}/.ssh/config &&
    chmod 0600 ${HOME}/.ssh/config &&
    mkdir ${HOME}/.ssh/config.d &&
    chmod 0700 ${HOME}/.ssh/config.d &&
    mkdir ${HOME}/bin &&
    echo source /usr/local/bin/bash_completion >> ${HOME}/.bashrc