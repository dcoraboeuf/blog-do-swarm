#!/usr/bin/env bash

SWARM_IP=`terraform output -no-color swarm_ip`
SWARM_USER=`terraform output -no-color swarm_user`

ssh \
    -o StrictHostKeyChecking=no \
    -o NoHostAuthenticationForLocalhost=yes \
    -o UserKnownHostsFile=/dev/null \
    -i do-key \
    ${SWARM_USER}@${SWARM_IP} \
    $*
