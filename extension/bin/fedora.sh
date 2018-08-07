#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
        --package)
            export PACKAGE="${2}" &&
                shift 2
            ;;
        --entrypoint)
            export ENTRYPOINT="${2}" &&
                shift 2
            ;;
        *)
            echo Unknown Option &&
                echo ${1} &&
                echo ${0} &&
                echo ${@} &&
                exit 64
    esac
done &&
    if [ -z "${PACKAGE}" ]
    then
        echo Unspecified PACKAGE &&
            exit 65
    elif [ -z "${ENTRYPOINT}" ]
    then
        echo Unspecified ENTRYPOINT &&
            exit 66
    fi &&
    DIR=$(mktemp -d) &&
    (cat > ${DIR}/Dockerfile <<EOF
FROM fedora:28
RUN dnf update --assumeyes && dnf install --assumeyes ${PACKAGE} && adduser user && dnf clean all
USER user
ENTRYPOINT ["sh", "${ENTRYPOINT}"]
CMD []
EOF
    ) &&
    IIDFILE=$(mktemp) &&
    docker image build --iidfile ${IIDFILE} --quiet ${DIR} &&
    rm -rf ${DIR} &&
    cat ${IIDFILE} &&
    rm -f ${IIDFILE}