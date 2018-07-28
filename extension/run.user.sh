#!/bin/sh

    mkdir ${HOME}/.ssh &&
    chmod 0700 ${HOME}/.ssh &&
    echo 'Include ~/.ssh/config.d/*' > ${HOME}/.ssh/config &&
    chmod 0600 ${HOME}/.ssh/config &&
    mkdir ${HOME}/.ssh/config.d &&
    chmod 0700 ${HOME}/.ssh/config.d &&
    mkdir ${HOME}/bin &&
    echo /usr/local/bin/bash_completion >> ${HOME}/.bashrc