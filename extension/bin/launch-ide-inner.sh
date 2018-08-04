#!/bin/sh

ide --cloud9-port 18326 --committer-email emory.merryman@gmail.com --committer-name "Emory Merryman" --gpg-owner-trust gpg.owner.trust --gpg-secret-key gpg.secret.key --gpg2-owner-trust gpg2.owner.trust --gpg2-secret-key gpg2.secret.key --origin-host github.com --origin-id-rsa origin.id_rsa --origin-organization nextmoose --origin-port 22 \
    --origin-repository inner \
    --project-name inner-01 --upstream-host github.com --upstream-id-rsa upstream.id_rsa --upstream-organization rebelplutonium --upstream-port 22 \
    --upstream-repository inner