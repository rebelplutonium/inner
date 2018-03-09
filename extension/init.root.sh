#!/bin/sh

dnf update --assumeyes &&
    if [ ! -z "${TARGET_UID}" ]
    then
        usermod -u ${TARGET_UID} user
    fi