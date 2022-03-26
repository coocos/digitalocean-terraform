locals {
  app_port = 8000
}

resource "digitalocean_vpc" "vpc" {
  region   = var.region
  name     = "custom-vpc"
  ip_range = "10.10.10.0/24"
}

resource "digitalocean_tag" "load_balancer_target" {
  name = "load-balancer-target"
}

resource "digitalocean_droplet" "web" {
  region   = var.region
  name     = "web"
  image    = "ubuntu-20-04-x64"
  size     = "s-1vcpu-1gb"
  vpc_uuid = digitalocean_vpc.vpc.id
  count    = var.droplet_count

  user_data = file("http_server.sh")
  tags      = [digitalocean_tag.load_balancer_target.id]
}

resource "digitalocean_firewall" "web" {
  name        = "load-balancer-traffic-only"
  droplet_ids = digitalocean_droplet.web[*].id

  inbound_rule {
    protocol                  = "tcp"
    port_range                = local.app_port
    source_load_balancer_uids = [digitalocean_loadbalancer.public.id]
  }
}

resource "digitalocean_domain" "site" {
  name = var.domain
}

resource "digitalocean_certificate" "cert" {
  name    = "load-balancer-cert"
  type    = "lets_encrypt"
  domains = [digitalocean_domain.site.name]

  lifecycle {
    create_before_destroy = true
  }
}

resource "digitalocean_loadbalancer" "public" {
  region   = var.region
  name     = "public-lb-1"
  size     = "lb-small"
  vpc_uuid = digitalocean_vpc.vpc.id

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = local.app_port
    target_protocol = "http"

    certificate_name = digitalocean_certificate.cert.name
  }

  healthcheck {
    port     = local.app_port
    protocol = "http"
    path     = "/"
  }

  droplet_tag = digitalocean_tag.load_balancer_target.name
}
