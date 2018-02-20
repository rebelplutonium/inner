#!/bin/sh

for TYPE in containers images networks volumes workspaces
do
    if [ ! -d /srv/docker/${TYPE}
    then
        mkdir /srv/docker/${TYPE} &&
        chown user:user /srv/docker/${TYPE}
    fi
done