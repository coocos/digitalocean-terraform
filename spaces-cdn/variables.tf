variable "api_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "spaces_key_id" {
  description = "Spaces access key"
  type        = string
}

variable "spaces_key_secret" {
  description = "Spaces access key secret"
  type        = string
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "ams3"
}

variable "domain" {
  description = "CDN domain name"
  type        = string
}
