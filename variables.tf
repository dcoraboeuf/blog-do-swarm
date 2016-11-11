## Digital Ocean credentials

variable "do_token" {
  description = "Your DigitalOcean API key"
}

## Digital Ocean settings

variable "do_region" {
  description = "DigitalOcean Region"
  default = "fra1"
}

variable "do_image" {
  description = "Slug for the image to install"
  // TODO Use coreos-stable when Docker 1.12.3 is available on it
  // At this moment:
  // stable -> 1.11
  // beta -> 1.12.1
  // alpha -> 1.12.3
  default = "coreos-alpha"
}

variable "do_agent_size" {
  description = "Agent Droplet Size"
  default = "2GB"
}

variable "do_ssh_key_public" {
  description = "Path to the SSH public key"
  default = "./do-key.pub"
}

variable "do_ssh_key_private" {
  description = "Path to the SSH private key"
  default = "./do-key"
}

variable "do_user" {
  description = "User to use to connect the machine using SSH. Depends on the image being installed."
  default = "core"
}

## Domain

variable "dns_domain" {
  description = "Name of the DNS domain for the swarm"
  default = "nemerosa.net"
}

variable "dns_domain_name" {
  description = "Name of the swarm in the DNS domain"
  default = "swarm"
}

## Swarm setup

variable "swarm_token_dir" {
  description = "Path (on the remote machine) which contains the generated swarm tokens"
  default = "/home/core"
}

variable "swarm_name" {
  description = "Name of the cluster, used also for networking"
  default = "swarm"
}

variable "swarm_master_count" {
  description = "Number of master nodes."
  default = "1"
}

variable "swarm_agent_count" {
  description = "Number of agents to deploy"
  default = "2"
}
