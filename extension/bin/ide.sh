#!/bin/sh

export CLOUD9_PORT=10380 &&
    export UPSTREAM_PORT=22 &&
    export ORIGIN_PORT=22 &&
    export REPORT_PORT=22 &&
    export UPSTREAM_BRANCH=master &&
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
                export GPG_SECRET_KEY=$(pass show "${2}") &&
                    shift 2
                ;;
            --gpg2-secret-key)
                export GPG2_SECRET_KEY=$(pass show "${2}") &&
                    shift 2
                ;;
            --gpg-owner-trust)
                export GPG_OWNER_TRUST=$(pass show "${2}") &&
                    shift 2
                ;;
            --gpg2-owner-trust)
                export GPG2_OWNER_TRUST=$(pass show "${2}") &&
                    shift 2
                ;;
            --upstream-host)
                export UPSTREAM_HOST="${2}" &&
                    shift 2
                ;;
            --upstream-port)
                export UPSTREAM_PORT="${2}" &&
                    shift 2
                ;;
            --upstream-id-rsa)
                export UPSTREAM_ID_RSA=$(pass show "${2}") &&
                    shift 2
                ;;
            --upstream-organization)
                export UPSTREAM_ORGANIZATION="${2}" &&
                    shift 2
                ;;
            --upstream-repository)
                export UPSTREAM_REPOSITORY="${2}" &&
                    shift 2
                ;;
            --upstream-branch)
                export UPSTREAM_BRANCH="${2}" &&
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
                export ORIGIN_ID_RSA=$(pass show "${2}") &&
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
            --origin-branch)
                export ORIGIN_BRANCH="${2}" &&
                    shift 2
                ;;
            --report-host)
                export REPORT_HOST="${2}" &&
                    shift 2 
                ;;
            --report-port)
                export REPORT_PORT="${2}" &&
                    shift 2
                ;;
            --report-id-rsa)
                export REPORT_ID_RSA=$(pass show "${2}") &&
                    shift 2
                ;;
            --report-organization)
                export REPORT_ORGANIZATION="${2}" &&
                    shift 2
                ;;
            --report-repository)
                export REPORT_REPOSITORY="${2}" &&
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
            *)
                echo Unsupported Option &&
                    echo ${0} &&
                    echo ${@} &&
                    exit 64
                ;;
        esac
    done &&
    if [ -z "${GPG_SECRET_KEY}" ]
    then
        echo Unspecified GPG_SECRET_KEY &&
            exit 65
    elif [ -z "${GPG_OWNER_TRUST}" ]
    then
        echo Unspecified GPG_OWNER_TRUST &&
            exit 66
    elif [ -z "${GPG2_SECRET_KEY}" ]
    then
        echo Unspecified GPG2_SECRET_KEY &&
            exit 67
    elif [ -z "${GPG2_OWNER_TRUST}" ]
    then
        echo Unspecified GPG2_OWNER_TRUST &&
            exit 68
    elif [ -z "${UPSTREAM_HOST}" ]
    then
        echo Unspecified UPSTREAM_HOST &&
            exit 69
    elif [ -z "${UPSTREAM_ID_RSA}" ]
    then
        echo Unspecified UPSTREAM_ID_RSA &&
            exit 70
    elif [ -z "${UPSTREAM_ORGANIZATION}" ]
    then
        echo Unspecified UPSTREAM_ORGANIZATION &&
            exit 71
    elif [ -z "${UPSTREAM_REPOSITORY}" ]
    then
        echo Unspecified UPSTREAM_REPOSITORY &&
            exit 72
    elif [ -z "${ORIGIN_HOST}" ]
    then
        echo Unspecified ORIGIN_HOST &&
            exit 73
    elif [ -z "${ORIGIN_ID_RSA}" ]
    then
        echo Unspecified ORIGIN_ID_RSA &&
            exit 74
    elif [ -z "${ORIGIN_ORGANIZATION}" ]
    then
        echo Unspecified ORIGIN_ORGANIZATION &&
            exit 75
    elif [ -z "${ORIGIN_REPOSITORY}" ]
    then
        echo Unspecified ORIGIN_REPOSITORY &&
            exit 75
    elif [ -z "${COMMITTER_NAME}" ]
    then
        echo Unspecified COMMITTER_NAME &&
            exit 76
    elif [ -z "${COMMITTER_EMAIL}" ]
    then
        echo Unspecified COMMITTER_EMAIL &&
            exit 77
    fi &&
    CIDFILE=$(cidfile) &&
    export PROJECT_NAME="${PROJECT_NAME}" &&
    sudo \
        --preserve-env \
        docker \
        container \
        create \
        --cidfile ${CIDFILE} \
        --env PROJECT_NAME \
        --env CLOUD9_PORT \
        --env GPG_SECRET_KEY \
        --env GPG_OWNER_TRUST \
        --env GPG2_SECRET_KEY \
        --env GPG2_OWNER_TRUST \
        --env UPSTREAM_HOST \
        --env UPSTREAM_PORT \
        --env UPSTREAM_ID_RSA \
        --env UPSTREAM_ORGANIZATION \
        --env UPSTREAM_REPOSITORY \
        --env UPSTREAM_BRANCH \
        --env ORIGIN_HOST \
        --env ORIGIN_PORT \
        --env ORIGIN_ID_RSA \
        --env ORIGIN_ORGANIZATION \
        --env ORIGIN_REPOSITORY \
        --env ORIGIN_BRANCH \
        --env REPORT_HOST \
        --env REPORT_PORT \
        --env REPORT_ID_RSA \
        --env REPORT_ORGANIZATION \
        --env REPORT_REPOSITORY \
        --env COMMITTER_NAME \
        --env COMMITER_EMAIL \
        --label timestamp=${TIMESTAMP} \
        rebelplutonium/github:1.0.9 &&
    sudo docker network connect --alias ${PROJECT_NAME} ${MAIN_NETWORK} $(cat ${CIDFILE}) &&
    sudo docker network disconnect bridge $(cat ${CIDFILE}) &&
    sudo docker container start $(cat ${CIDFILE})