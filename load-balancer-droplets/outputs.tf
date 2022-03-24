output "load_balancer_ip" {
  value = digitalocean_loadbalancer.public.ip
}
