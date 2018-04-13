#!/bin/sh

_UseGetOpt_create_docker_id_file() {
    local CUR &&
        COMPREPLY=() &&
        CUR=${COMP_WORDS[COMP_CWORD]} &&
        case "${CUR}" in
            -*)
                COMPREPLY=($( compgen -W "--type" -- ${CUR}))
            ;;
        esac
  return 0
} &&
    complete -F _UseGetOpt_create_docker_id_file -o filenames /usr/local/bin/create-docker-id-file create-docker-id-file --