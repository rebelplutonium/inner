#!/bin/sh

ls -1 /srv/docker/containers | while read FILE
do
    sudo /usr/bin/docker container stop $(cat /srv/docker/containers/${FILE}) &&
        sudo /usr/bin/docker container rm --volumes $(cat /srv/docker/containers/${FILE}) &&
        rm -f /srv/docker/${FILE}
done &&
    ls -1 /srv/docker/images | while read FILE
    do
        sudo /usr/bin/docker image rm $(cat /srv/docker/images/${FILE}) &&
            rm -f /srv/docker/${FILE}
    done &&
    ls -1 /srv/docker/networks | while read FILE
    do
        sudo /usr/bin/docker network rm $(cat /srv/docker/networks/${FILE}) &&
            rm -f /srv/docker/${FILE}
    done &&
    ls -1 /srv/docker/volumes | while read FILE
    do
        sudo /usr/bin/docker volume rm $(cat /srv/docker/volumes/${FILE}) &&
            rm -f /srv/docker/${FILE}
    done
        