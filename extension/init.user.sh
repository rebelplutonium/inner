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
    ln -sf /home/user/.ssh /home/user/workspace/dot_ssh &&
    ln -sf /home/user/bin /home/user/workspace &&
    ls -1 /usr/local/bin | while read FILE
    do
        cp /usr/local/bin/${FILE} /home/user/bin/${FILE}.sh &&
            chmod 0700 /home/user/bin/${FILE}.sh
    done &&
    pass git fetch origin master &&
    pass git checkout master