variable "api_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "ssh_key" {
  description = "Name of SSH key used for droplet access"
  type        = string
}

variable "domain" {
  description = "Name of domain to point to the droplet"
  type        = string
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "ams3"
}
