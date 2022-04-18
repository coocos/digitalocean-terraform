resource "digitalocean_domain" "domain" {
  name = var.domain
}

resource "digitalocean_certificate" "lb_cert" {
  name    = "load-balancer-cert"
  type    = "lets_encrypt"
  domains = [digitalocean_domain.domain.name]
}

resource "digitalocean_container_registry" "registry" {
  name                   = var.registry_name
  subscription_tier_slug = "basic"
  region                 = var.region
}

data "digitalocean_kubernetes_versions" "versions" {}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = "example-cluster"
  region  = var.region
  version = data.digitalocean_kubernetes_versions.versions.latest_version

  node_pool {
    name       = "autoscale-pool"
    size       = "s-2vcpu-2gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 3
  }
}
