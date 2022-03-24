# Basic droplet

A barebones example for creating a single droplet running a toy HTTP server and pointing a domain to it. The droplet is behind a [cloud firewall](https://docs.digitalocean.com/products/networking/firewalls/) but allows SSH access in addition to HTTP.

## Usage

Create a `terraform.tfvars` file with the name of your SSH key @ DigitalOcean, your API token and the name of your domain:

```shell
api_token = "yourapitokenshouldgohere"
ssh_key   = "nameofyoursshkey"
domain    = "yourveryhipdomain.com
```

Or alternatively you can define them using environment variables like `export TF_VAR_api_token=...`.

The API token is used by Terraform to create your infrastructure and the SSH key can be used to connect to the created droplet. You can create these at the DigitalOcean control panel. The domain should not yet exist as a resource in the control panel as Terraform will create it, but you do need to [point your domain to the DigitalOcean nameservers](https://docs.digitalocean.com/tutorials/dns-registrars/).

Next, install the DigitalOcean provider and initialize Terraform:

```
terraform init
```

Then you can create the droplet:

```
terraform apply
```

Terraform should output the public IPv4 address of the droplet:

```shell
Outputs:

droplet_ip = "123.123.123.123"
```

Now, if you configured your SSH keys correctly, you should be able to use SSH to connect to your droplet:

```
ssh root@123.123.123.123
```

You can also use your domain name to access the droplet:

```html
~ curl yourveryhipdomain.com

<!doctype html><html><head><meta charset="utf-8"><title>Droplet</title></head><body><h1>Hello droplet 12345678!</h1></body></html>
```