terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.18.0"
    }
  }
}

provider "digitalocean" {
  token             = var.api_token
  spaces_access_id  = var.spaces_key_id
  spaces_secret_key = var.spaces_key_secret
}
