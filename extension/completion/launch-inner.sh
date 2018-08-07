#!/bin/sh

_UseGetOpt_launch_inner(){
    local CUR &&
        COMPREPLY=() &&
        CUR=${COMP_WORDS[COMP_CWORD]} &&
        case ${CUR} in
            -*)
                COMPREPLY=($(compgen -W "--main-network --major --minor --patch --workspace-volume --main-network --cloud9-port --gpg-secret-key --gpg-owner-trust --gpg2-secret-key --gpg2-owner-trust --secrets-host --secrets-organization --secrets-repository" -- ${CUR}))
                ;;
        esac
} &&
    complete -F _UseGetOpt_ide -o filenames ide