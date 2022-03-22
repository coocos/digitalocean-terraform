data "digitalocean_ssh_key" "ssh_key" {
  name = var.ssh_key
}

resource "digitalocean_domain" "site" {
  name       = var.domain
  ip_address = digitalocean_droplet.web.ipv4_address
}

resource "digitalocean_firewall" "http_ssh" {
  name        = "http-ssh-only"
  droplet_ids = [digitalocean_droplet.web.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = 22
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = 80
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = 80
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = 443
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = 53
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = 53
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-20-04-x64"
  region = var.region
  name   = "web"
  size   = "s-1vcpu-1gb"

  ssh_keys  = [data.digitalocean_ssh_key.ssh_key.id]
  user_data = file("http_server.sh")
}
