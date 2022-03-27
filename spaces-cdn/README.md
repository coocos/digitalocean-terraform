# Spaces + CDN

This example creates a new randomly named [Spaces bucket](https://docs.digitalocean.com/products/spaces/quickstart/), uploads an HTML file to it, puts the bucket behind a CDN with a custom subdomain like assets.whateveryourdomainis.com and configures a LetsEncrypt certificate for the subdomain.

## Usage

Create a `terraform.tfvars` file with your API token, a Spaces access key and secret, as well as the domain you want to use as the custom domain for the CDN:

```shell
api_token         = "token"
spaces_key_id     = "id"
spaces_key_secret = "secret"
domain            = "yourveryhipdomain.com"
```

Or alternatively you can define them using environment variables like `export TF_VAR_api_token=...`.

The API token is used by Terraform to create your infrastructure and the Spaces keys are used to access the bucket. You can create these at the DigitalOcean control panel. The domain should not yet exist as a resource in the control panel as Terraform will create it, but you do need to [point your domain to the DigitalOcean nameservers](https://docs.digitalocean.com/tutorials/dns-registrars/).

Next, initialize Terraform and create the bucket and the CDN:

```
terraform init
...
terraform apply
```

Terraform should output the CDN address after a while:

```shell
Outputs:

cdn_url = "https://assets.yourveryhipdomain.com"
```

Then you can retrieve the uploaded HTML file via the CDN using your custom subdomain:

```html
~ curl https://assets.yourveryhipdomain.com/index.html

<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Spaces example</title>
  </head>
  <body>
    <header>
        <h1>Hello Spaces!</h1>
    </header>
    <main>
        <p>
            See <a href="https://www.digitalocean.com/products/spaces">Spaces</a> for more information.
        </p>
    </main>
  </body>
</html>
```