#!/bin/sh

docker \
    container \
    run \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --volume /run/docker/encrypted:/run/docker/encrypted \
    --volume /run/docker/unencrypted:/run/docker/unencrypted \
    --env DISPLAY \
    docker:18.06.0-ce \
    "${@}"