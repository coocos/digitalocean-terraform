variable "api_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "ams3"
}

variable "registry_name" {
  description = "DigitalOcean Container Registry name"
  type        = string
  default     = "your-unique-container-registry-name"
}

variable "domain" {
  description = "Name of domain to point to the load balancer"
  type        = string
}
