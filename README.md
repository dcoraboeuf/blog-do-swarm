# do-swarm

> Work in progress - still experimental.

The goal is to create a Digital Ocean Docker Swarm.

## Prerequisites

Generate a Digital Ocean API key and expose it as a `TF_VAR_do_token` environment variable.

Generate a SSH key pair - your can use the `init.sh` script. The key pair will be generated with `do-key` and `do-key.pub` names in the current directory.

## Configuration

All configuration items are exposed as [Terraform variables](https://www.terraform.io/docs/configuration/variables.html) in the `variables.tf` file. Read their description to get their meaning. Most of them have default values.

## Running

In the local directory, just run:

```bash
terraform apply
```

## Resources

The resources created by the Terraform setup are:

* one or several master nodes (default to one) - the first master being created - `master-00` - is used to generate the worker and manager tokens. Those files - `worker.token` and `manager.token` - are stored locally and must not be lost if the swarm must be extended later on.

* one or several swarm agents (or slaves)

* one floating IP

* one DNS A record pointing to the floating IP. The domain name is defined as a variable. It would be straightforward to define the [domain](https://www.terraform.io/docs/providers/do/r/domain.html) as a resource but I consider this out-of-scope in this very case. The name of the record is also a variable and defaults to `swarm`.

## Connection

To connect to the swarm defined at `swarm.nemerosa.net` (or whatever has been configured as variables), the easiest is to create a machine:

```bash
docker-machine create --driver generic \
   --generic-ip-address=swarm.nemerosa.net \
   --generic-ssh-key ./do-key swarm
```

where `do-key` is the private key which has been generated as a prerequisite.

To use this swarm machine as your docker environment, you can then run:

```bash
eval $(docker-machine env swarm)
```

You should now see the list of nodes created by the Terraform setup:

```bash
$ docker node ls
ID                           HOSTNAME        STATUS  AVAILABILITY  MANAGER STATUS
20iw98tuhpg1fsmbvd38kymmj *  swarm           Ready   Active        Leader
cdemrd1r5mmguf57p7og4bxpb    swarm-agent-00  Ready   Active    
```

## Monitoring

### Visualizer

Basic and visual monitoring of the swarm can be done using the [`visualizer`](https://github.com/ManoMarks/docker-swarm-visualizer) container. You can run:

```bash
docker run --name visualizer -d \
    -p 8083:8083 \
    -e HOST=$(docker-machine ip swarm) \
    -e PORT=8083 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    manomarks/visualizer
```

The visualizer is now available on port 8083 of the master node:

```bash
open http://$(docker-machine ip swarm):8083
```
