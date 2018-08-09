#!/bin/sh

_UseGetOpt_launch_gitlab(){
    local CUR &&
        COMPREPLY=("--configuration-volume" "--logs-volume" "--data-volume" "--main-network" "--alias") &&
        CUR=${COMP_WORDS[COMP_CWORD]} &&
        case ${CUR} in
            -*)
                COMPREPLY=($(compgen -W "--configuration-volume --logs-volume --data-volume --main-network --alias" -- ${CUR}))
                ;;
        esac
}

complete -F _UseGetOpt_launch_gitlab -o filenames launch-gitlab