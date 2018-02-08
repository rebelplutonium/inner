#!/bin/sh

/usr/bin/docker \
    container \
    run \
    --interactive \
    --tty \
    --rm \
    --workdir $(pwd})
    docker:${DOCKER_SEMVER}-ce \
        "${@}"