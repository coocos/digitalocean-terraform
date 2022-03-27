resource "random_pet" "bucket_prefix" {
  length = 4
}

resource "digitalocean_spaces_bucket" "assets" {
  name          = "${random_pet.bucket_prefix.id}-assets"
  region        = var.region
  acl           = "public-read"
  force_destroy = true

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3600
  }
}

resource "digitalocean_spaces_bucket_object" "index" {
  bucket       = digitalocean_spaces_bucket.assets.name
  region       = digitalocean_spaces_bucket.assets.region
  acl          = "public-read"
  key          = "index.html"
  source       = "content/index.html"
  content_type = "text/html"
}

resource "digitalocean_domain" "cdn" {
  name = var.domain
}

resource "digitalocean_certificate" "cert" {
  name    = "cdn-cert"
  type    = "lets_encrypt"
  domains = ["assets.${digitalocean_domain.cdn.name}"]
}

resource "digitalocean_cdn" "cdn" {
  origin           = digitalocean_spaces_bucket.assets.bucket_domain_name
  certificate_name = digitalocean_certificate.cert.name
  custom_domain    = "assets.${digitalocean_domain.cdn.name}"
}
