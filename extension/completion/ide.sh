#!/bin/sh

_UseGetOpt_ide(){
    local CUR &&
        COMPREPLY=() &&
        CUR=${COMP_WORDS[COMP_CWORD]} &&
        case ${CUR} in
            -*)
                COMPREPLY=($(compgen -W "--main-network --project-name --cloud9-port --gpg-secret-key --gpg2-secret-key --gpg-owner-trust --gpg2-owner-trust --upstream-host --upstream-port --upstream-id-rsa --upstream-organization --upstream-repository --upstream-branch --origin-host --origin-port --origin-id-rsa --origin-organization --origin-repository --origin-branch --report-host --report-port --report-id-rsa --report-organization --report-repository --committer-name --committer-email --master-branch --issue-number" -- ${CUR}))
        esac
} &&
    complete -F _UseGetOpt_ide -o filenames ide