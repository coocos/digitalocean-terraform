# Basic droplet

A barebones example for creating a single droplet.

## Usage

Create a `terraform.tfvars` file with the name of your SSH key @ DigitalOcean, as well as your API token:

```shell
api_token = "yourapitokenshouldgohere"
ssh_key   = "nameofyoursshkey"
```

The API token is used by Terraform to create your infrastructure and the SSH key can be used to connect to the created droplet. You can create these at the DigitalOcean control panel.

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
