#!/bin/sh

export CLOUD9_PORT=10604 &&
    TIMESTAMP=$(date +%s) &&
    while [ ${#} -gt 0 ]
    do
        case ${1} in
            --main-network)
                export MAIN_NETWORK="${2}" &&
                    shift 2
                ;;
            --project-name)
                export PROJECT_NAME="${2}" &&
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
            --origin-host)
                export ORIGIN_HOST="${2}" &&
                    shift 2
                ;;
            --origin-port)
                export ORIGIN_PORT="${2}" &&
                    shift 2
                ;;
            --origin-id-rsa)
                export ORIGIN_ID_RSA="$(pass show ${2})" &&
                    shift 2
                ;;
            --origin-organization)
                export ORIGIN_ORGANIZATION="${2}" &&
                    shift 2
                ;;
            --origin-repository)
                export ORIGIN_REPOSITORY="${2}" &&
                    shift 2
                ;;
            --committer-name)
                export COMMITTER_NAME="${2}" &&
                    shift 2
                ;;
            --committer-email)
                export COMMITTER_EMAIL="${2}" &&
                    shift 2
                ;;
            --read-write)
                export READ_WRITE=$(uuidgen) &&
                    shift
                ;;
            --read-only)
                export READ_ONLY=$(uuidgen) &&
                    shift
                ;;
            *)
                echo Unknown Option &&
                    echo ${0} &&
                    echo ${@} &&
                    exit 64
                ;;
        esac
    done &&
    if [ -z "${PROJECT_NAME}" ]
    then
        echo Missing PROJECT_NAME &&
            exit 65
    elif [ -z "${CLOUD9_PORT}" ]
    then
        echo Missing CLOUD9_PORT &&
            exit 66
    elif [ -z "${GPG_SECRET_KEY}" ]
    then
        echo Missing GPG_SECRET_KEY &&
            exit 67
    elif [ -z "${GPG_OWNER_TRUST}" ]
    then
        echo Missing GPG_OWNER_TRUST &&
            exit 68
    elif [ -z "${GPG2_SECRET_KEY}" ]
    then
        echo Missing GPG2_SECRET_KEY &&
            exit 69
    elif [ -z "${GPG2_OWNER_TRUST}" ]
    then
        echo Missing GPG2_OWNER_TRUST &&
            exit 70
    elif [ -z "${ORIGIN_HOST}" ]
    then
        echo Missing ORIGIN_HOST &&
            exit 71
    elif [ -z "${ORIGIN_PORT}" ]
    then
        echo Missing ORIGIN_PORT &&
            exit 72
    elif [ -z "${ORIGIN_ORGANIZATION}" ]
    then
        echo Missing ORIGIN_ORGANIZATION &&
            exit 73
    elif [ -z "${COMMITTER_NAME}" ]
    then
        echo Missing COMMITTER_NAME &&
            exit 74
    elif [ -z "${COMMITTER_EMAIL}" ]
    then
        echo Missing COMMITTER_EMAIL &&
            exit 75
    elif [ ! -z "${READ_WRITE}" ] && [ ! -z "${READ_ONLY}" ]
    then
        echo READ_WRITE is specified and READ_ONLY is specified &&
            exit 76
    elif [ ! -z "${READ_WRITE}" ] && [ -z "${COMMITTER_NAME}" ]
    then
        echo READ_WRITE is specified by missing COMMITTER_NAME &&
            exit 77
    elif [ ! -z "${READ_WRITE}" ] && [ -z "${COMMITTER_EMAIL}" ]
    then
        echo READ_WRITE is specified by missing COMMITTER_EMAIL &&
            exit 78
    elif [ -z "${READ_ONLY}" ] && [ -z "${READ_WRITE}" ]
    then
        echo Neither READ_ONLY nor READ_WRITE is specified &&
            exit 79
    fi &&
    CIDFILE=$(cidfile) &&
    VOLUME=$(sudo docker volume create --driver lvm --opt thinpool --opt size=1G) &&
    sudo \
        --preserve-env \
        docker \
        container \
        create \
        --cidfile ${CIDFILE} \
        --env PROJECT_NAME \
        --env CLOUD9_PORT \
        --env GPG_SECRET_KEY \
        --env GPG2_SECRET_KEY \
        --env GPG_OWNER_TRUST \
        --env GPG2_OWNER_TRUST \
        --env ORIGIN_HOST \
        --env ORIGIN_PORT \
        --env ORIGIN_ORGANIZATION \
        --env ORIGIN_REPOSITORY \
        --env ORIGIN_ID_RSA \
        --env COMMITTER_NAME \
        --env COMMITTER_EMAIL \
        --env READ_WRITE \
        --env READ_ONLY \
        --label timestamp=${TIMESTAMP} \
        --volume ${VOLUME}:/opt/cloud9/workspace \
        rebelplutonium/secret-editor:2.0.1 \
        &&
    sudo docker network connect --alias ${PROJECT_NAME} ${MAIN_NETWORK} $(cat ${CIDFILE}) &&
    sudo docker network disconnect bridge $(cat ${CIDFILE}) &&
    sudo docker container start $(cat ${CIDFILE}) &&
    true
