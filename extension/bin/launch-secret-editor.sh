#!/bin/sh

export CLOUD9_PORT=10604 &&
    export EXPIRY="now + 1 month" &&
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
            --origin-id-rsa)
                export ORIGIN_ID_RSA="$(pass show \"${2}\")" &&
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
            --host-name)
                export HOST_NAME="${2}" &&
                    shift 2
            ;;
            --host-port)
                export HOST_PORT="${2}" &&
                    shift 2
            ;;
            --user-name)
                export USER_NAME="${2}" &&
                    shift 2
            ;;
            --user-email)
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
            --expiry)
                export EXPIRY=$(date --date "${2}" +%s) &&
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
    CIDFILE=$(create-docker-id-file --type containers) &&
    rm -f ${CIDFILE} &&
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
        --env GPG_KEY_ID \
        --env USER_EMAIL \
        --env ORIGIN_ORGANIZATION \
        --env ORIGIN_REPOSITORY \
        --env ORIGIN_ID_RSA \
        --env HOST_NAME \
        --env HOST_PORT \
        --env USER_NAME \
        --env USER_EMAIL \
        --env READ_WRITE \
        --env READ_ONLY \
        --label expiry=${EXPIRY} \
        rebelplutonium/secret-editor:1.0.0 &&
    docker network connect --alias ${PROJECT_NAME} main $(cat ${CIDFILE}) &&
    docker container start $(cat ${CIDFILE})
