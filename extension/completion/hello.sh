#!/bin/sh

_UseGetOpt_hello(){
    local CUR &&
        COMPREPLY=() &&
        CUR=${COMP_WORDS[COMP_CWORD]} &&
        case ${CUR} in
            -*)
                COMPREPLY=($(compgen -W "--greetee" -- ${CUR}))
                ;;
        esac
}

complete -F _UseGetOpt_hello -o filenames hello