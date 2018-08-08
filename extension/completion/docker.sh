#!/bin/sh

_UseGetOpt_docker(){
    local CUR &&
        COMPREPLY=("--help" "--config" "-D" "--debug" "-H" "--host" "-l" "--log" "--tls" "--tlscacert" "--tlscert" "--tlskey" "--tlsverify" "-v" "--version" "config" "container" "image" "network" "node" "plugin" "secret" "service" "stack" "swarm" "system" "trust" "volume" "attach" "build" "commit" "cp" "create" "deploy" "diff" "events" "exec" "export" "history" "images" "import" "info" "inspect" "kill" "load" "login" "logout" "logs" "pause" "port" "ps" "pull" "push" "rename" "restart" "rm" "rmi" "run" "save" "search" "start" "stats" "stop" "tag" "top" "unpause" "update" "version" "wait") &&
        CUR=${COMP_WORDS[COMP_CWORD]} &&
        case ${CUR} in
            -*)
                COMPREPLY=($(compgen -W "--greetee" -- ${CUR}))
                ;;
        esac
}

complete -F _UseGetOpt_docker -o filenames docker