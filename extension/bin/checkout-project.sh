#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
        --project-name)
            export PROJECT_NAME="${2}" &&
                shift 2
        ;;
        --branch-name)
            export BRANCH_NAME="${2}" &&
                shift 2
        ;;
        *)
            echo Unknown Option &&
                echo ${0} &&
                echo ${@} &&
                exit 64
        ;;
    esac
done &&
    if [ ! -d ${WORKSPACE_DIR}/projects ]
    then
        mkdir ${WORKSPACE_DIR}/projects
    fi &&
    PROJECT_DIR=$(mktemp -d ${WORKSPACE_DIR}/projects/XXXXXXXX) &&
    git -C ${PROJECT_DIR} init &&
    git -C ${PROJECT_DIR} remote add origin https://github.com/nextmoose/${PROJECT_NAME}.git &&
    git -C ${PROJECT_DIR} fetch origin ${BRANCH_NAME} &&
    git -C ${PROJECT_DIR} checkout origin/${BRANCH_NAME} &&
    cd ${PROJECT_DIR} &&
    bash