#!/bin/sh

TIMESTAMP=$(date +%s) &&
    while [ ${#} -gt 0 ]
    do
        case ${1} in
            --project-name)
                export PROJECT_NAME="${2}" &&
                    shift 2
                ;;
            --major)
                export MAJOR="${2}" &&
                    shift 2
                ;;
            --minor)
                export MINOR="${2}" &&
                    shift 2
                ;;
            --patch)
                export PATCH="${2}" &&
                    shift 2
                ;;
            --workspace-volume)
                export WORKSPACE_VOLUME="${2}" &&
                    shift 2
                ;;
            --main-network)
                export MAIN_NETWORK="${2}" &&
                    shift 2
                ;;
            --cloud9-port)
                export CLOUD9_PORT="${2}" &&
                    shift 2
                ;;
            --gpg-secret-key)
                export GPG_SECRET_KEY="$(pass show ${2})" &&
                    shift 2
                ;;
            --gpg-owner-trust)
                export GPG_OWNER_TRUST="$(pass show ${2})" &&
                    shift 2
                ;;
            --gpg2-secret-key)
                export GPG2_SECRET_KEY="$(pass show ${2})" &&
                    shift 2
                ;;
            --gpg2-owner-trust)
                export GPG2_OWNER_TRUST="$(pass show ${2})" &&
                    shift 2
                ;;
            --secrets-host)
                export SECRETS_HOST="${2}" &&
                    shift 2
                ;;
            --secrets-organization)
                export SECRETS_ORGANIZATION="${2}" &&
                    shift 2
                ;;
            --secrets-repository)
                export SECRETS_REPOSITORY="${2}" &&
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
    if [ -z "${PROJECT_NAME}" ]
    then
        echo Unspecified PROJECT_NAME &&
            exit 65
    elif [ -z "${MAJOR}" ]
    then
        echo Unspecified MAJOR &&
            exit 66
    elif [ -z "${MINOR}" ]
    then
        echo Unspecified MINOR &&
            exit 67
    elif [ -z "${PATCH}" ]
    then
        echo Unspecified PATCH &&
            exit 68
    elif [ -z "${WORKSPACE_VOLUME}" ]
    then
        echo Unspecified WORKSPACE_VOLUME &&
            exit 69
    elif [ -z "${MAIN_NETWORK}" ]
    then
        echo Unspecified MAIN_NETWORK &&
            exit 70
    elif [ -z "${CLOUD9_PORT}" ]
    then
        echo Unspecified CLOUD9_PORT &&
            exit 71
    elif [ -z "${GPG_SECRET_KEY}" ]
    then
        echo Unspecified GPG_SECRET_KEY &&
            exit 72
    elif [ -z "${GPG_OWNER_TRUST}" ]
    then
        echo Unspecified GPG_OWNER_TRUST &&
            exit 73
    elif [ -z "${GPG2_SECRET_KEY}" ]
    then
        echo Unspecified GPG2_SECRET_KEY &&
            exit 74
    elif [ -z "${GPG2_OWNER_TRUST}" ]
    then
        echo Unspecified GPG2_OWNER_TRUST &&
            exit 75
    elif [ -z "${SECRETS_HOST}" ]
    then
        echo Unspecified SECRETS_HOST &&
            exit 76
    elif [ -z "${SECRETS_ORGANIZATION}" ]
    then
        echo Unspecified SECRETS_ORGANIZATION &&
            exit 77
    elif [ -z "${SECRETS_REPOSITORY}" ]
    then
        echo Unspecified SECRETS_REPOSITORY &&
            exit 78
    fi &&
    CIDFILE=$(sudo mktemp /run/docker/unencrypted/XXXXXXXX) &&
    sudo rm -rf ${CIDFILE} &&
    sudo \
        --preserve \
        docker \
    	container \
    	create \
    	--cidfile ${CIDFILE} \
    	--interactive \
    	--tty \
    	--volume /var/run/docker.sock:/var/run/docker.sock:ro \
    	--volume ${WORKSPACE_VOLUME}:/opt/cloud9/workspace \
    	--volume /run/docker/encrypted:/run/docker/encrypted \
    	--volume /run/docker/unencrypted:/run/docker/unencrypted \
    	--env PROJECT_NAME \
    	--env CLOUD9_PORT=18326 \
    	--env GPG_SECRET_KEY \
    	--env GPG_OWNER_TRUST \
    	--env GPG2_SECRET_KEY \
    	--env GPG2_OWNER_TRUST \
    	--env SECRETS_HOST \
    	--env SECRETS_ORGANIZATION \
    	--env SECRETS_REPOSITORY \
    	--label timestamp=${TIMESTAMP} \
    	rebelplutonium/inner:${MAJOR}.${MINOR}.${PATCH} \
    	&&
	sudo docker network connect --alias ${PROJECT_NAME} ${MAIN_NETWORK} $(cat ${CIDFILE}) &&
	sudo docker network disconnect bridge $(cat ${CIDFILE}) &&
	sudo docker container start $(cat ${CIDFILE}) &&
	sudo rm -f ${CIDFILE}
