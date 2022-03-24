variable "api_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "ams3"
}

variable "droplet_count" {
  description = "How many droplets to create"
  type        = number
  default     = 2
}
