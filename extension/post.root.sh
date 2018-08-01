#!/bin/sh

dnf update --assumeyes &&
    docker image pull rebelplutonium/github:1.0.3 rebelplutonium/secret-editor:2.0.2