#!/bin/sh

/usr/bin/docker \
    container \
    run \
    --interactive \
    --tty \
    --rm \
    --mount type=bind,source=/srv/docker,destination=/srv/docker,readonly=false \
    $(compgen -v | while read ENV; do echo --env ${ENV}; done) \
    --workdir $(pwd) \
    docker:${DOCKER_SEMVER}-ce \
        "${@}"