#!/bin/sh

/usr/bin/docker \
    container \
    run \
    --interactive \
    --tty \
    --rm \
    --volume /opt/cloud9/workspace:/opt/cloud9/workspace \
    $(compgen -v | while read ENV; do echo --env ${ENV}; done) \
    --workdir $(pwd) \
    docker:${DOCKER_SEMVER}-ce \
        "${@}"