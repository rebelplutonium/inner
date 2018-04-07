#!/bin/sh

export MONIKER=e4e46485-843a-4421-8563-00fd04693a4f &&
    while [ ${#} -gt 0 ]
    do
        case ${1} in
            --moniker)
                export MONIKER="${2}" &&
                    shift 2
            ;;
            --inner-semver)
                export INNER_SEMVER="${2}" &&
                    shift 2
            ;;
            --middle-semver)
                export MIDDLE_SEMVER="${2}" &&
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
    WORKDIR=$(mktemp -d ${WORKSPACE_DIR}/XXXXXXXX) &&
    (cat > ${WORKDIR}/public.env <<EOF
#!/bin/sh

export MONIKER=$(uuidgen) &&
    export PROJECT_NAME=inner &&
    export CLOUD9_PORT=10604 &&
    export USER_NAME="Emory Merryman" &&
    export USER_EMAIL=emory.merryman@gmail.com &&
    export GPG_KEY_ID=D65D3F8C &&
    export SECRETS_ORGANIZATION=nextmoose &&
    export SECRETS_REPOSITORY=secrets &&
    export DOCKER_SEMVER=18.02.0 &&
    export BROWSER_SEMVER=0.0.0 &&
    export MIDDLE_SEMVER=${MIDDLE_SEMVER} &&
    export INNER_SEMVER=${INNER_SEMVER}

EOF
    ) &&
    mkdir ${WORKDIR}/public ${WORKDIR}/private &&
    echo "${GPG_SECRET_KEY}" > ${WORKDIR}/private/gpg.secret.key &&
    echo "${GPG2_SECRET_KEY}" > ${WORKDIR}/private/gpg2.secret.key &&
    echo "${GPG_OWNER_TRUST}" > ${WORKDIR}/public/gpg.owner.trust &&
    echo "${GPG2_OWNER_TRUST}" > ${WORKDIR}/public/gpg2.owner.trust &&
    cd ${WORKDIR} &&
    docker \
        run \
        --interactive \
        --rm \
        --label expiry=$(($(date +%s)+60*60*24)) \
        --mount type=bind,source=/srv/hostuuidgen
        /var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
        --mount type=bind,source=$(pwd),destination=/srv/working \
        --env DISPLAY \
        rebelplutonium/outer:${MAJOR}.${MINOR}.${PATCH} \
            "${@}"
