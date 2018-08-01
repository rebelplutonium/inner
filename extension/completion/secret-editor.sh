#!/bin/sh

_UseGetOpt_secret_editor(){
    local CUR &&
        COMPREPLY=() &&
        CUR=${COMP_WORDS[COMP_CWORD]} &&
        case ${CUR} in
            -*)
                COMPREPLY=($(compgen -W "--main-network --project-name --cloud9-port --gpg-secret-key --gpg-owner-trust --gpg2-secret-key --gpg2-owner-trust --origin-host --origin-port --origin-id-rsa --origin-organization --origin-repository --committer-name --committer-email --read-write --read-only" -- ${CUR}))
        esac
} &&
    complete -F _UseGetOpt_secret_editor -o filenames secret-editor