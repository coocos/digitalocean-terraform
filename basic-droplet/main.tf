data "digitalocean_ssh_key" "ssh_key" {
  name = var.ssh_key
}

resource "digitalocean_domain" "site" {
  name       = var.domain
  ip_address = resource.digitalocean_droplet.web.ipv4_address
}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-20-04-x64"
  region = var.region
  name   = "web"
  size   = "s-1vcpu-1gb"

  ssh_keys  = [data.digitalocean_ssh_key.ssh_key.id]
  user_data = file("http_server.sh")
}
