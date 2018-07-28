#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
        --greetee)
            GREETEE="${2}" &&
                shift 2
            ;;
        *)
            echo Unknown Option &&
                echo ${1} &&
                echo ${0} &&
                echo ${@} &&
                exit 64
            ;;
    esac
done &&
    if [ -z "${GREETEE}" ]
    then
        echo Unspecified GREETEE
    fi &&
    echo Hello to ${GREETEE}