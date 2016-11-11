#!/usr/bin/env bash

SCRIPT_PATH=$1
SWARM_IP=`terraform output -no-color swarm_ip`
SWARM_USER=`terraform output -no-color swarm_user`

cat ${SCRIPT_PATH} | ssh \
    -o StrictHostKeyChecking=no \
    -o NoHostAuthenticationForLocalhost=yes \
    -o UserKnownHostsFile=/dev/null \
    -i do-key \
    ${SWARM_USER}@${SWARM_IP} \
    "bash -s "
