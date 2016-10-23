resource "digitalocean_ssh_key" "default" {
    name = "${var.do_swarm_name}-ssh-key"
    public_key = "${file(var.do_ssh_key_public)}"
}

resource "digitalocean_droplet" "docker_swarm_master" {
   count = "${var.do_swarm_master_count}"
   image = "docker"
   size = "${var.do_agent_size}"
   region = "${var.do_region}"
   private_networking = true
   name = "${format("${var.do_swarm_name}-master-%02d", count.index)}"
}

resource "digitalocean_droplet" "docker_swarm_agent" {
   count = "${var.do_swarm_agent_count}"
   image = "docker"
   size = "${var.do_agent_size}"
   region = "${var.do_region}"
   private_networking = true
   name = "${format("${var.do_swarm_name}-agent-%02d", count.index)}"
}
