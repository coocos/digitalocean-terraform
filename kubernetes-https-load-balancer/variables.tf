variable "api_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "ams3"
}

variable "domain" {
  description = "Name of domain to point to the load balancer"
  type        = string
}
