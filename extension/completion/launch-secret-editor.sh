#!/bin/sh

_UseGetOpt_launch_secret_editor() {
    local CUR &&
        COMPREPLY=() &&
        CUR=${COMP_WORDS[COMP_CWORD]} &&
        case "${CUR}" in
            -*)
                COMPREPLY=($( compgen -W "--project-name --cloud9-port --origin-organization --origin-repository --host-name --host-port --user-name --user-email --read-write --read-only --expiry" -- ${CUR}))
            ;;
        esac
  return 0
} &&
    complete -F _UseGetOpt_launch_secret_editor -o filenames /usr/local/bin/launch-secret-editor launch-secret-editor --