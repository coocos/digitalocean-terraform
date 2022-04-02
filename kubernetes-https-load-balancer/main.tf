data "digitalocean_kubernetes_versions" "versions" {}

resource "digitalocean_domain" "top" {
  name = var.domain
}

resource "digitalocean_certificate" "lb_cert" {
  name    = "load-balancer-cert"
  type    = "lets_encrypt"
  domains = [digitalocean_domain.top.name]
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = "example-cluster"
  region  = var.region
  version = data.digitalocean_kubernetes_versions.versions.latest_version

  node_pool {
    name       = "default"
    size       = "s-1vcpu-2gb"
    node_count = 1
  }
}
