#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
        --configuration-volume)
            export CONFIGURATION_VOLUME="${2}" &&
                shift 2
            ;;
        --logs-volume)
            export LOGS_VOLUME="${2}" &&
                shift 2
            ;;
        --data-volume)
            export DATA_VOLUME="${2}" &&
                shift 2
            ;;
        --main-network)
            export MAIN_NETWORK="${2}" &&
                shift 2
            ;;
        --alias)
            export ALIAS="${2}" &&
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
    TIMESTAMP=$(date +%s) &&
    expiry=${EXPIRY} &&
    if [ -z "${CONFIGURATION_VOLUME}" ]
    then
        export CONFIGURATION_VOLUME=$(docker volume create --driver lvm --opt thinpool --opt size=1G --label timestamp=${TIMESTAMP} --label expiry=${EXPIRY})
    elif [ -z "${LOGS_VOLUME}" ]
    then
        export LOGS_VOLUME=$(docker volume create --driver lvm --opt thinpool --opt size=1G --label timestamp=${TIMESTAMP} --label expiry=${EXPIRY})
    elif [ -z "${DATA_VOLUME}" ]
    then
        export DATA_VOLUME=$(docker volume create --driver lvm --opt thinpool --opt size=1G --label timestamp=${TIMESTAMP} --label expiry=${EXPIRY})
    elif [ -z "${MAIN_NETWORK}" ]
    then
        echo Unspecified MAIN_NETWORK &&
            exit 65
    elif [ -z "${ALIAS}" ]
    then
        echo Unspecified ALIAS &&
            exit 66
    fi &&
    CIDFILE=$(cidfile) &&
    docker \
        container \
        create \
        --cidfile ${CIDFILE} \
        --mount type=volume,source=${CONFIGURATION_VOLUME},destination=/etc/gitlab \
        --mount type=volume,source=${LOGS_VOLUME},destination=/var/logs/gitlab\
        --mount type=volume,source=${DATA_VOLUME},destination=/var/opt/gitlab \
        --label timestamp=${TIMESTAMP} \
        gitlab/gitlab-ce:11.1.4-ce.0 \
        &&
    docker network connect --alias ${ALIAS} ${MAIN_NETWORK} $(cat ${CIDFILE})
    docker network disconnect bridge $(cat ${CIDFILE}) &&
    docker container start $(cat ${CIDFILE}) &&
    sudo rm -f ${CIDFILE}
    
    
    
    
    
    
    