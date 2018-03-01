#!/bin/sh

source /usr/local/bin/artifacts-env &&
(
    pass show aws-access-key-id &&
        pass show aws-secret-access-key &&
        echo us-east-1 &&
        echo text
) | aws configure &&
    aws s3 mb s3://${BUCKET}