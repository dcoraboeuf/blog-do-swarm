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

### SSH

Run the `./connect.sh` script to open a SSH session on the Docker Swarm master.

You can also append some commands to run them directy. For example:

```bash
./connect.sh docker service ls
```

### Docker

Once the Terraform state has been created (after the `apply` command has run), the IP of the swarm is available
using:

```bash
terraform output -no-color swarm_ip
```

In order to connect to the swarm, you can run:

```bash
export DOCKER_TLS_VERIFY=1
export DOCKER_HOST=`terraform output -no-color swarm_ip`
```

You can then run the Docker commands directly against the swarm.
