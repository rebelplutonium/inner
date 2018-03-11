#!/bin/sh

mkdir --parents /opt/cloud9/workspace/docker &&
    ID_FILE=$(mktemp /opt/cloud9/workspace/XXXXXXXX) &&
    rm --force ${ID_FILE} &&
    echo ${ID_FILE}