#!/bin/sh

CIDFILE=$(mktemp /run/docker/unencrypted/XXXXXXXX.cid) &&
    rm -f ${CIDFILE} &&
    echo ${CIDFILE}