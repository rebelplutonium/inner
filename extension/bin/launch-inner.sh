#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
        --name)
            NAME="${2}" &&
                shift 2
        ;;
        --major)
            MAJOR="${2}" &&
                shift 2
        ;;
        --minor)
            MINOR="${2}" &&
                shift 2
        ;;
        --patch)
            PATCH="${2}" &&
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
    export WORKSPACE_DIR=$(mktemp -d ${WORKSPACE_DIR}/docker/XXXXXXXX) &&
    docker \
        container \
        create \
        --name ${NAME} \
        --privileged \
        --env CLOUD9_PORT \
        --env PROJECT_NAME="${NAME}" \
        --env USER_NAME \
        --env USER_EMAIL \
        --env GPG_SECRET_KEY \
        --env GPG2_SECRET_KEY \
        --env GPG_OWNER_TRUST \
        --env GPG2_OWNER_TRUST \
        --env GPG_KEY_ID \
        --env SECRETS_ORGANIZATION \
        --env SECRETS_REPOSITORY \
        --env DOCKER_SEMVER \
        --env DOCKER_HOST \
        --env DISPLAY \
        --env TARGET_UID \
        --env WORKSPACE_DIR \
        --mount type=bind,source=/opt/cloud9/workspace,destination=/opt/cloud9/workspace,readonly=false \
        --mount type=bind,source=/srv/host/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
        --label expiry=$(date --date "now + 1 month" +%s) \
        rebelplutonium/inner:${MAJOR}.${MINOR}.${PATCH} &&
    docker network connect --alias inner main ${NAME} &&
    docker start ${NAME}