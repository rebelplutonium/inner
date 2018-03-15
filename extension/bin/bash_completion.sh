#!/bin/sh

for ${BCFILE} in ${HOME}/.bash_completion.d/*
do
    source ${BCFILE}
done