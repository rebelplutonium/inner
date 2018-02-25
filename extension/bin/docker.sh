#!/bin/sh

/usr/bin/docker \
    container \
    run \
    --interactive \
    --tty \
    --rm \
    --volume /home/user/workspace:/home/user/workspace \
    $(compgen -v | while read ENV; do echo --env ${ENV}; done) \
    --workdir $(pwd) \
    docker:${DOCKER_SEMVER}-ce \
        "${@}"