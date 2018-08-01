#!/bin/sh

dnf update --assumeyes &&
    docker image pull rebelplutonium/github:1.0.4 &&
    docker image pull rebelplutonium/secret-editor:2.0.2