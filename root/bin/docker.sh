#!/bin/sh

/usr/bin/docker \
    container \
    run \
    --interactive \
    --tty \
    --rm \
    $(compgen -v | while read ENV; do echo --env ${ENV}; done) \
    --workdir $(pwd) \
    docker:${DOCKER_SEMVER}-ce \
        "${@}"