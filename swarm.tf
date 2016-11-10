##################################################################################################################
# SSH Key
##################################################################################################################

resource "digitalocean_ssh_key" "docker_swarm_ssh_key" {
  name = "${var.swarm_name}-ssh-key"
  public_key = "${file(var.do_ssh_key_public)}"
}

##################################################################################################################
# Initial master node
##################################################################################################################

resource "digitalocean_droplet" "docker_swarm_master_initial" {
  count = 1
  name = "${format("${var.swarm_name}-master-%02d", count.index)}"

  image = "${var.do_image}"
  size = "${var.do_agent_size}"
  region = "${var.do_region}"
  private_networking = true

  user_data = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file("${var.do_ssh_key_public}")}\"\n"
  ssh_keys = [
    "${digitalocean_ssh_key.docker_swarm_ssh_key.id}"
  ]

  connection {
    user = "${var.do_user}"
    private_key = "${file(var.do_ssh_key_private)}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm init --advertise-addr ${self.ipv4_address}",
      "docker swarm join-token --quiet worker > ${var.swarm_token_dir}/worker.token",
      "docker swarm join-token --quiet manager > ${var.swarm_token_dir}/manager.token"
    ]
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i ${var.do_ssh_key_private} ${var.do_user}@${self.ipv4_address}:${var.swarm_token_dir}/worker.token ."
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i ${var.do_ssh_key_private} ${var.do_user}@${self.ipv4_address}:${var.swarm_token_dir}/manager.token ."
  }

}

##################################################################################################################
# Floating IP / DNS entry
##################################################################################################################

resource "digitalocean_floating_ip" "docker_swarm_floating_ip" {
  droplet_id = "${digitalocean_droplet.docker_swarm_master_initial.id}"
  region = "${digitalocean_droplet.docker_swarm_master_initial.region}"
}

resource "digitalocean_record" "docker_swarm_dns_record" {
  domain = "${var.dns_domain}"
  type = "A"
  name = "${var.dns_domain_name}"
  value = "${digitalocean_floating_ip.docker_swarm_floating_ip.ip_address}"
}

##################################################################################################################
# TODO Other masters
##################################################################################################################

##################################################################################################################
# Swarm agents
##################################################################################################################

resource "digitalocean_droplet" "docker_swarm_agent" {
  count = "${var.swarm_agent_count}"
  name = "${format("${var.swarm_name}-agent-%02d", count.index)}"

  image = "${var.do_image}"
  size = "${var.do_agent_size}"
  region = "${var.do_region}"
  private_networking = true

  user_data = "#cloud-config\n\nssh_authorized_keys:\n  - \"${file("${var.do_ssh_key_public}")}\"\n"
  ssh_keys = [
    "${digitalocean_ssh_key.docker_swarm_ssh_key.id}"]

  connection {
    user = "${var.do_user}"
    private_key = "${file(var.do_ssh_key_private)}"
    agent = false
  }

  provisioner "file" {
    source = "worker.token"
    destination = "${var.swarm_token_dir}/worker.token"
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm join --token $(cat ${var.swarm_token_dir}/worker.token) ${digitalocean_droplet.docker_swarm_master_initial.ipv4_address}:2377"
    ]
  }
}
