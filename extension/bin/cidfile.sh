#!/bin/sh

CIDFILE=$(sudo mktemp /run/docker/unencrypted/XXXXXXXX.cid) &&
    sudo rm -f ${CIDFILE} &&
    echo ${CIDFILE}