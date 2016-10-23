variable "do_token" {
  description = "Your DigitalOcean API key"
}

variable "docker_swarm_domain" {
   description = "Name of the DNS domain for the swarm"
   default = "nemerosa.net"
}

variable "docker_swarm_domain_name" {
   description = "Name of the swarm in the DNS domain"
   default = "swarm"
}

variable "do_region" {
  description = "DigitalOcean Region"
  default = "fra1"
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

variable "do_swarm_name" {
  description = "Name of the cluster, used also for networking"
  default = "swarm"
}

variable "do_swarm_master_count" {
  description = "Number of master nodes."
  default = "1"
}

variable "do_swarm_agent_count" {
  description = "Number of agents to deploy"
  default = "1"
}
