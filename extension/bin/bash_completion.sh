#!/bin/sh

for BCFILE in /opt/cloud9/extension/completion/*
do
    source ${BCFILE}
done