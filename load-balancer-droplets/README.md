# Load balancer + droplets

A simple example for creating an HTTPS load balancer which forwards traffic to multiple droplets. The droplets are placed in a custom VPC and use a cloud firewall to accept traffic only from the load balancer.

## Usage

Create a `terraform.tfvars` file your API token, the name of your domain and how many droplets you want to place behind the load balancer:

```shell
api_token     = "yourapitokenshouldgohere"
domain        = "yourveryhipdomain.com"
droplet_count = 3
```

Or alternatively you can define them using environment variables like `export TF_VAR_api_token=...`.

The API token is used by Terraform to create your infrastructure. You can create one at the DigitalOcean control panel. The domain should not yet exist as a resource in the control panel as Terraform will create it, but you do need to [point your domain to the DigitalOcean nameservers](https://docs.digitalocean.com/tutorials/dns-registrars/) so that DigitalOcean can create an A record to the load balancer.

Next, install the DigitalOcean provider and initialize Terraform:

```
terraform init
```

Then you can create the infrastructure:

```
terraform apply
```

It will take a minute or two but eventually your load balancer and the droplets will up. After a while the DNS changes have also taken effect and you should be able to use your domain name to access the load balancer:

```html
~ curl https://yourveryhipdomain.com

<!doctype html><html><head><meta charset="utf-8"><title>Droplet</title></head><body><h1>Hello droplet 12345678!</h1></body></html>
```

If you keep sending HTTP requests, the response might change as the load balancer balances traffic between the multiple droplets.