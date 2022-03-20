output "droplet_ip" {
  value = resource.digitalocean_droplet.web.ipv4_address
}
