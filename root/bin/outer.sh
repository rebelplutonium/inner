#!/bin/sh

sudo \
    /usr/bin/docker \
    container \
    run \
    --interactive \
    --tty \
    --rm \
    --label expiry=$(date --date "now + 1 month" +%s) \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    rebelplutonium/outer:0.0.0 \
        --project-name outer \
        --user-name "${USER_NAME}" \
        --user-email "${USER_EMAIL}" \
        --gpg-secret-key "${GPG_SECRET_KEY}" \
        --gpg2-secret-key "${GPG2_SECRET_KEY}" \
        --gpg-owner-trust "${GPG_OWNER_TRUST}" \
        --gpg2-owner-trust "${GPG2_OWNER_TRUST}" \
        --gpg-key-id "${GPG_KEY_ID}" \
        --secrets-organization "${SECRETS_ORGANIZATION}" \
        --secrets-repository "${SECRETS_REPOSITORY}"