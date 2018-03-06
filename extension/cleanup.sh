#!/bin/sh

ls -1 /home/user/workspace/docker/containers | while read FILE
do
    sudo /usr/bin/docker container stop $(cat /home/user/workspace/docker/containers/${FILE}) &&
        sudo /usr/bin/docker container rm --volumes $(cat /home/user/workspace/docker/containers/${FILE}) &&
        rm -f /home/user/workspace/docker/${FILE}
done &&
    ls -1 /home/user/workspace/docker/networks | while read FILE
    do
        sudo /usr/bin/docker network rm $(cat /home/user/workspace/docker/networks/${FILE}) &&
            rm -f /home/user/workspace/docker/${FILE}
    done &&
    ls -1 /home/user/workspace/docker/volumes | while read FILE
    do
        sudo /usr/bin/docker volume rm $(cat /home/user/workspace/docker/volumes/${FILE}) &&
            rm -f /home/user/workspace/docker/${FILE}
    done
        