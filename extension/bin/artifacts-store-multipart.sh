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
    TSTAMP=$(date +%Y%b%d) &&
    source /usr/local/bin/artifacts-env &&
    (
        pass show aws-access-key-id &&
            pass show aws-secret-access-key &&
            echo us-east-1 &&
            echo text
    ) | aws configure &&
    cd $(mktemp -d) &&
    sudo tar --verbose --create --file ${NAME}-${TSTAMP}.tar --directory ${SOURCE} . &&
    sudo gzip -9 ${NAME}-${TSTAMP}.tar &&
    sudo chown user:user ${NAME}-${TSTAMP}.tar.gz &&
    stat ${NAME}-${TSTAMP}.tar.gz &&
    mkdir alpha beta &&
    split --bytes 10000000 --numeric-suffixes=1 --suffix-length 8 ${NAME}-${TSTAMP}.tar.gz alpha/ &&
    UPLOAD_ID=$(aws s3api create-multipart-upload --acl private --bucket ${BUCKET} --key ${NAME}-${TSTAMP}.tar.gz --metadata md5=$(md5sum ${NAME}-${TSTAMP}.tar.gz | cut -f1 -d " ") --query "UploadId") &&
    (cat > fileparts <<EOF
{
    "Parts": [
EOF
    ) &&
    ls -1 parts | while read FILE
    do
        echo aws s3api upload-part --bucket ${BUCKET} --key ${NAME}-${TSTAMP}.tar.gz --part-number $(pwd)/${FILE##+(0)} --body alpha/${FILE} --upload-id ${UPLOAD_ID} --query "ETag" &&
            BEFORE=$(date +%s) &&
            ETAG=$(aws s3api upload-part --bucket ${BUCKET} --key ${NAME}-${TSTAMP}.tar.gz --part-number $(pwd)/${FILE##+(0)} --body alpha/${FILE} --upload-id ${UPLOAD_ID} --query "ETag") &&
            if [ ${?} != 0 ]
            then
                echo FAILED TO PREPARE PART -- ${FILE} -- ${ETAG}
            fi &&
            AFTER=$(date +%s) &&
            echo PREPARED PART -- ${FILE} -- ${ETAG} -- $((${AFTER}-${BEFORE})) &&
            if [ ${FILE##+(0)} -gt 1 ]
            then
                (cat >> fileparts <<EOF
    ,
EOF
                )
            fi &&
            (cat >> fileparts <<EOF
    { "ETag": "${ETAG}", "PartNumber": ${FILE##+(0)} }
EOF
            )
    done
    (cat >> fileparts <<EOF
    ]
}
EOF
    ) &&
    echo aws s3api complete-multipart-upload --multipart-upload file://$(pwd)/fileparts --bucket ${BUCKET} --key ${NAME}-${TSTAMP}.tar.gz --upload-id ${UPLOAD_ID} &&
    aws s3api complete-multipart-upload --multipart-upload file://$(pwd)/fileparts --bucket ${BUCKET} --key ${NAME}-${TSTAMP}.tar.gz --upload-id ${UPLOAD_ID} &&
    ls -1 alpha | while read FILE
    do
        aws s3api get-object --bucket ${BUCKET} --key ${NAME}-${TSTAMP}.tar.gz --part ${FILE##+(0)} beta/${FILE} &&
            if ! diff -qrs alpha/${FILE} beta/${FILE}
            then
                echo ${FILE} is corrupted &&
                    exit 65
            fi
    done &&
    echo IT WORKED &&
    true