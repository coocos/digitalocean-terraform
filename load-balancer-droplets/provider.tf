terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.18.0"
    }
  }
}

provider "digitalocean" {
  token = var.api_token
}
