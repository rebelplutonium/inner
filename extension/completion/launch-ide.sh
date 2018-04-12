#!/bin/sh

_UseGetOpt() {
    local CUR &&
        COMPREPLY=() &&
        CUR=${COMP_WORDS[COMP_CWORD]} &&
        case "${CUR}" in
            -*)
                COMPREPLY=($( compgen -W "--host-name --host-port --master-branch --upstream-id-rsa --upstream-organization --upstream-repository --origin-id-rsa --origin-organization --origin-repository --report-id-rsa --report-organization --report-repository --project-name --cloud9-port --checkout-branch --gpg-secret-key --gpg2-secret-key --gpg-owner-trust --gpg2-owner-trust --gpg-key-id --user-name --user-email --expiry" -- ${CUR}))
            ;;
        esac
  return 0
} &&
    complete -F _UseGetOpt -o filenames /usr/local/bin/launch-ide launch-ide --