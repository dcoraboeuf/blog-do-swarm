resource "digitalocean_ssh_key" "docker_swarm_ssh_key" {
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
   user_data = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file("${var.do_ssh_key_public}")}\"\n"
   ssh_keys = [ "${digitalocean_ssh_key.docker_swarm_ssh_key.id}" ]

   connection {
      user = "root"
      key_file = "${file(var.do_ssh_key_private)}"
   }

   provisioner "remote-exec" {
      inline = [
         "docker swarm init --advertise-addr ${self.ipv4_address}",
         "docker swarm join-token --quiet worker > /var/lib/docker/worker.token"
      ]
   }
}

/*
resource "digitalocean_droplet" "docker_swarm_agent" {
   count = "${var.do_swarm_agent_count}"
   image = "docker"
   size = "${var.do_agent_size}"
   region = "${var.do_region}"
   private_networking = true
   name = "${format("${var.do_swarm_name}-agent-%02d", count.index)}"
}
*/
