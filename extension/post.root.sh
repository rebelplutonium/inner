#!/bin/sh

docker image pull rebelplutonium/github:1.0.9 &&
    docker image pull rebelplutonium/secret-editor:2.0.2 &&
    dnf update --assumeyes