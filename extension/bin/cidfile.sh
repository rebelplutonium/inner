#!/bin/sh

CIDFILE=$(mktemp) &&
    rm -f ${CIDFILE} &&
    echo ${CIDFILE}