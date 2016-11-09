#!/usr/bin/env bash

SWARM_IP=`terraform output -no-color swarm_ip`

ssh \
    -o StrictHostKeyChecking=no \
    -o NoHostAuthenticationForLocalhost=yes \
    -o UserKnownHostsFile=/dev/null \
    -i do-key \
    root@${SWARM_IP} \
    $*
