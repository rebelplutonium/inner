#!/bin/sh

/usr/bin/docker container ls --quiet | while read CONTAINER
do
    /usr/bin/docker container stop ${CONTAINER} &&
        /usr/bin/docker container rm --volumes ${CONTAINER}
done &&
    /usr/bin/docker network ls --quiet | while read NETWORK
    do
        /usr/bin/docker network rm ${NETWORK}
    done &&
    /usr/bin/docker volume ls --quiet | while read VOLUME
    do
        /usr/bin/docker volume rm ${VOLUME}
    done
        