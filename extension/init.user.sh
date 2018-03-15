#!/bin/sh

TEMP=$(mktemp -d) &&
    echo "${GPG_SECRET_KEY}" > ${TEMP}/gpg-secret-key &&
    gpg --batch --import ${TEMP}/gpg-secret-key &&
    echo "${GPG2_SECRET_KEY}" > ${TEMP}/gpg2-secret-key &&
    gpg2 --batch --import ${TEMP}/gpg2-secret-key &&
    echo "${GPG_OWNER_TRUST}" > ${TEMP}/gpg-owner-trust &&
    gpg --batch --import-ownertrust ${TEMP}/gpg-owner-trust &&
    echo "${GPG2_OWNER_TRUST}" > ${TEMP}/gpg2-owner-trust &&
    gpg2 --batch --import-ownertrust ${TEMP}/gpg2-owner-trust &&
    rm -rf ${TEMP} &&
    pass init ${GPG_KEY_ID} &&
    pass git init &&
    pass git config user.name "${USER_NAME}" &&
    pass git config user.email "${USER_EMAIL}" &&
    pass git remote add origin https://github.com/${SECRETS_ORGANIZATION}/${SECRETS_REPOSITORY}.git &&
    ln -sf /usr/bin/post-commit ${HOME}/.password-store/.git/hooks/post-commit &&
    ln -sf ${HOME}/.ssh /opt/cloud9/workspace/dot_ssh &&
    ln -sf ${HOME}/bin /opt/cloud9/workspace &&
    pass git fetch origin master &&
    pass git checkout master &&
    ls -1 /opt/cloud9/extension/completion | while read SCRIPT
    do
        cp /opt/cloud9/extension/completion/${SCRIPT} ${HOME}/.bash_completion.d/${SCRIPT%.*} &&
            chmod 0644 ${HOME}/.bash_completion.d/${SCRIPT%.*}
    done
