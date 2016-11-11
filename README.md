# do-swarm

> Work in progress - still experimental.

The goal is to create a Digital Ocean Docker Swarm.

## Prerequisites

Generate a Digital Ocean API key and expose it as a `TF_VAR_do_token` environment variable.

Generate a SSH key pair - your can use the `init.sh` script. The key pair will be generated with `do-key` and 
`do-key.pub` names in the current directory.

## Configuration

All configuration items are exposed as [Terraform variables](https://www.terraform.io/docs/configuration/variables.html)
in the `variables.tf` file. Read their description to get their meaning. Most of them have default values.

## Creating the swarm

In the local directory, just run:

```bash
terraform apply
```

## Using the swarm

To run a command against the Docker Swarm, run, for example:

```bash
./connect.sh docker service ls
```

To run a script file against the Docker Swarm, run, for example:

```bash
./run.sh infra.sh
```

where `infra.sh` contains for example:

```bash
#!/usr/bin/env bash
docker service create \
  --name=visualizer \
  --publish=8081:8080/tcp \
  --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  manomarks/visualizer
```

## Appendixes

### SSH to the Docker swarm

Run the `./connect.sh` script to open a SSH session on the Docker Swarm master.

You can also append some commands to run them directy. For example:

```bash
./connect.sh docker service ls
```
