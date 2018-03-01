#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
        --source)
            export SOURCE="${2}" &&
                shift 2
        ;;
        --name)
            export NAME="${2}" &&
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
    source /usr/local/bin/artifacts-env &&
    (
        pass show aws-access-key-id &&
            pass show aws-secret-access-key &&
            echo us-east-1 &&
            echo text
    ) | aws configure &&
    cd $(mktemp -d) &&
    sudo tar --verbose --create --file ${NAME}-$(date +%Y%b%d).tar --directory ${SOURCE} . &&
    sudo gzip -9 ${NAME}-$(date +%Y%b%d).tar &&
    sudo chown user:user ${NAME}-$(date +%Y%b%d).tar.gz &&
    stat ${NAME}-$(date +%Y%b%d).tar.gz &&
    aws s3 cp --expected-size $(stat --format %s ${NAME}-$(date +%Y%b%d).tar.gz ) ${NAME}-$(date +%Y%b%d).tar.gz s3://${BUCKET}/${NAME}-$(date +%Y%b%d).tar.gz