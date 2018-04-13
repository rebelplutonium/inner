#!/bin/sh

export PROJECT_NAME=hacker &&
    export CLOUD9_PORT=10380 &&
    export HOST_NAME=github.com &&
    export HOST_PORT=22 &&
    export MASTER_BRANCH=master &&
    while [ ${#} -gt 0 ]
    do
        case ${1} in
            --host-name)
                export HOST_NAME="${2}" &&
                    shift 2
            ;;
            --host-port)
                export HOST_PORT="${2}" &&
                    shift 2
            ;;
            --master-branch)
                export MASTER_BRANCH="${2}" &&
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
            --project-name)
                export PROJECT_NAME="${2}" &&
                    shift 2
            ;;
            --cloud9-port)
                export CLOUD9_PORT="${2}" &&
                    shift 2
            ;;
            --checkout-branch)
                export CHECKOUT_BRANCH="${2}" &&
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
            --gpg-key-id)
                export GPG_KEY_ID=$(pass show "${2}") &&
                    shift 2
            ;;
            --user-name)
                export USER_NAME="${2}" &&
                    shift 2
            ;;
            --user-email)
                export USER_EMAIL="${2}" &&
                    shift 2
            ;;
            --expiry)
                export EXPIRY=$(date --date "${2}" +%s) &&
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
    if [ -z "${HOST_NAME}" ]
    then
        echo Unspecified HOST_NAME &&
            exit 65
    fi &&
    if [ -z "${HOST_PORT}" ]
    then
        echo Unspecified HOST_PORT &&
            exit 66
    fi &&
    if [ -z "${MASTER_BRANCH}" ]
    then
        echo Unspecified MASTER_BRANCH &&
            exit 67
    fi &&
    if [ -z "${UPSTREAM_ID_RSA}" ]
    then
        echo Unspecified UPSTREAM_ID_RSA &&
            exit 68
    fi &&
    if [ -z "${UPSTREAM_ORGANIZATION}" ]
    then
        echo Unspecified UPSTREAM_ORGANIZATION &&
            exit 69
    fi &&
    if [ -z "${UPSTREAM_REPOSITORY}" ]
    then
        echo Unspecified UPSTREAM_REPOSITORY &&
            exit 70
    fi &&
    if [ -z "${ORIGIN_ID_RSA}" ]
    then
        echo Unspecified ORIGIN_ID_RSA &&
            exit 71
    fi &&
    if [ -z "${ORIGIN_ORGANIZATION}" ]
    then
        echo Unspecified ORIGIN_ORGANIZATION &&
            exit 72
    fi &&
    if [ -z "${ORIGIN_REPOSITORY}" ]
    then
        echo Unspecified ORIGIN_REPOSITORY &&
            exit 73
    fi &&
    if [ -z "${REPORT_ID_RSA}" ]
    then
        echo Unspecified REPORT_ID_RSA &&
            exit 74
    fi &&
    if [ -z "${REPORT_ORGANIZATION}" ]
    then
        echo Unspecified REPORT_ORGANIZATION &&
            exit 75
    fi &&
    if [ -z "${REPORT_REPOSITORY}" ]
    then
        echo Unspecified REPORT_REPOSITORY &&
            exit 76
    fi &&
    if [ -z "${CLOUD9_PORT}" ]
    then
        echo Unspecified CLOUD9_PORT &&
            exit 77
    fi &&
    if [ -z "${GPG_SECRET_KEY}" ]
    then
        echo Unspecified GPG_SECRET &&
            exit 78
    fi &&
    if [ -z "${GPG2_SECRET_KEY}" ]
    then
        echo Unspecified GPG2_SECRET_KEY &&
            exit 79
    fi &&
    if [ -z "${GPG_OWNER_TRUST}" ]
    then
        echo Unspecified GPG_OWNER_TRUST &&
            exit 80
    fi &&
    if [ -z "${GPG2_OWNER_TRUST}" ]
    then
        echo Unspecified GPG2_OWNER_TRUST &&
            exit 81
    fi &&
    if [ -z "${GPG_KEY_ID}" ]
    then
        echo Unspecified GPG_KEY_ID &&
            exit 82
    fi &&
    if [ -z "${USER_NAME}" ]
    then
        echo Unspecified USER_NAME &&
            exit 83
    fi &&
    if [ -z "${USER_EMAIL}" ]
    then
        echo Unspecified USER_EMAIL &&
            exit 84
    fi &&
    if [ -z "${EXPIRY}" ]
    then
        echo Unspecified EXPIRY &&
            exit 85
    fi &&
    CIDFILE=$(create-docker-id-file) &&
    export PROJECT_NAME="${PROJECT_NAME}" &&
    docker \
        container \
        create \
        --cidfile ${CIDFILE} \
        --env PROJECT_NAME \
        --env CLOUD9_PORT \
        --env UPSTREAM_ID_RSA \
        --env UPSTREAM_ORGANIZATION \
        --env UPSTREAM_REPOSITORY \
        --env ORIGIN_ID_RSA \
        --env ORIGIN_ORGANIZATION \
        --env ORIGIN_REPOSITORY \
        --env REPORT_ID_RSA \
        --env REPORT_ORGANIZATION \
        --env REPORT_REPOSITORY \
        --env USER_NAME \
        --env USER_EMAIL \
        --env HOST_NAME \
        --env HOST_PORT \
        --env MASTER_BRANCH \
        --env CHECKOUT_BRANCH \
        --env GPG_SECRET_KEY \
        --env GPG2_SECRET_KEY \
        --env GPG_OWNER_TRUST \
        --env GPG2_OWNER_TRUST \
        --env GPG_KEY_ID \
        --env USER_NAME \
        --env USER_EMAIL \
        --label expiry=${EXPIRY} \
        rebelplutonium/github:0.0.8 &&
    docker network connect --alias ${PROJECT_NAME} main $(cat ${CIDFILE}) &&
    docker container start $(cat ${CIDFILE})