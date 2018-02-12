#!/bin/sh

while [ ${#} -gt 0 ]
do
    case "${1}" in
        --type)
            export TYPE="${2}" &&
                shift 2
        ;;
        *)
            echo Unknown Option &&
                echo ${0} &&
                echo ${@} &&
                exit 64
        ;;
    esac
done &&
    ID_FILE=$(mktemp "/srv/docker/${TYPE}/XXXXXXXX") &&
    rm -f ${ID_FILE}