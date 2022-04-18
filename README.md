# digitalocean-terraform

Terraform examples / experiments for setting up infrastructure like Kubernetes clusters @ DigitalOcean.

## Examples

Examples include:

* [creating a droplet with SSH access and pointing a domain to it](./basic-droplet/)
* [placing multiple droplets behind an HTTPS load balancer](./load-balancer-droplets/)
* [creating an S3 compatible Spaces bucket + CDN using a custom subdomain](./spaces-cdn/)
* [launching a Kubernetes cluster and exposing Nginx pods using an HTTPS load balancer](./kubernetes-https-load-balancer)
* [creating an autoscaling Kubernetes cluster and a private container registry, deploying microservices from the registry and exposing one of them via an HTTPS load balancer](./kubernetes-container-registry/)