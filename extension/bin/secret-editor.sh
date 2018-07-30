#!/bin/sh

export CLOUD9_PORT=10604 &&
    TIMESTAMP=$(date +%s) &&
    while [ ${#} -gt 0 ]
    do
        case ${1} in
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
                export UPSTREAM_HOST="${2}" &&
                    shift 2
                ;;
            --origin-port)
                export UPSTREAM_PORT="${2}" &&
                    shift 2
                ;;
            --origin-id-rsa)
                export UPSTREAM_ID_RSA="$(pass show ${2})" &&
                    shift 2
                ;;
            --origin-organization)
                export UPSTREAM_ORGANIZATION="${2}" &&
                    shift 2
                ;;
            --origin-repository)
                export UPSTREAM_REPOSITORY="${2}" &&
                    shift 2
                ;;
            --committer-name)
                export USER_NAME="${2}" &&
                    shift 2
                ;;
            --committer-email)
                export USER_NAME="${2}" &&
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
    elif [ -z "${UPSTREAM_HOST}" ]
    then
        echo Missing UPSTREAM_HOST &&
            exit 71
    elif [ -z "${UPSTREAM_PORT}" ]
    then
        echo Missing UPSTREAM_PORT &&
            exit 72
    elif [ -z "${UPSTREAM_ORGANIZATION}" ]
    then
        echo Missing UPSTREAM_ORGANIZATION &&
            exit 73
    elif [ -z "${COMMITER_NAME}" ]
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
    cleanup(){
        docker container stop $(cat ${CIDFILE}) && docker container rm --volumes $(cat ${CIDFILE})
        rm -f ${CIDFILE}
    } &&
    trap cleanup EXIT &&
    docker \
        container \
        create \
        --cidfile ${CIDFILE} \
        --rm \
        --env PROJECT_NAME \
        --env CLOUD9_PORT \
        --env GPG_SECRET_KEY \
        --env GPG2_SECRET_KEY \
        --env GPG_OWNER_TRUST \
        --env GPG2_OWNER_TRUST \
        --env UPSTREAM_HOST \
        --env UPSTREAM_PORT \
        --env UPSTREAM_ORGANIZATION \
        --env UPSTREAM_REPOSITORY \
        --env UPSTREAM_ID_RSA \
        --env COMMITTER_NAME \
        --env COMMITTER_EMAIL \
        --env READ_WRITE \
        --env READ_ONLY \
        --label timestamp=${TIMESTAMP} \
        rebelplutonium/secret-editor:2.0.0 \
        &&
    docker network connect --alias ${PROJECT_NAME} ${MAIN_NETWORK} $(cat ${CIDFILE}) &&
    docker network disconnect bridge $(cat ${CIDFILE}) &&
    docker container start --interactive $(cat ${CIDFILE}) &&
    true
