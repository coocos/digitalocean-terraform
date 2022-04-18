# Kubernetes & private container registry

This example demonstrates how to use Terraform to create an autoscaling DigitalOcean Kubernetes cluster and a private container registry, deploy a few microservices from that registry and expose one of them over an HTTPS load balancer.

## Explanation

The project is structured into two dummy microservices follows:

* `/api` contains a simple Python service built on top of [FastAPI](https://fastapi.tiangolo.com). The service exposes a REST API which can be used to submit dummy events to be "processed". However, the events are not processed by the service itself - instead they are submitted to a Redis queue.
* `/processor` contains a Go service which reads events from the Redis queue and "processes" them.
* `/manifests` contains Kubernetes manifests for deploying Redis, the two microservices and an external load balancer.

## Usage

### Create the infrastructure

We will use Terraform to create three things:

* Kubernetes cluster
* container registry
* domain & HTTPS certificate

To create these resources, you need to define the following variables in `terraform.tfvars` (or use environment variables like `export TF_VAR_api_token=...`):

```shell
api_token = "yourapitokenshouldgohere"
domain    = "yourveryhipdomain.com"
```

The API token is used by Terraform to create your infrastructure and the domain will be pointed to a load balancer. The domain should not yet exist as a resource in the control panel as Terraform will create it, but you do need to [point your domain to the DigitalOcean nameservers](https://docs.digitalocean.com/tutorials/dns-registrars/) so that DigitalOcean can create DNS records on your behalf and automatically register a certificate for HTTPS.

Next, initialize Terraform and create the cluster and the other resources:

```
terraform init
terraform apply
```

It will take a few minutes, but eventually both your Kubernetes cluster and container registry should be up and running. You can now set the kubeconfig of the created cluster as the current kubectl context:

```
doctl kubernetes cluster kubeconfig save example-cluster
```

### Push container images to the registry

In order for your cluster to be able to deploy your microservices as pods, you need to push the container images to the registry. First, build your microservice container images locally:

```shell
# Platform flag needs to be explicitly set if you're using an arm64 platform like M1
docker build -t api:0.1 --platform linux/amd64 ./api
docker build -t processor:0.1 --platform linux/amd64 ./processor
```

Now use `doctl` to authenticate to your newly built container image registry and push your service images to it:

```
doctl registry login

docker tag api:0.1 registry.digitalocean.com/your-unique-container-registry-name/api:0.1
docker push registry.digitalocean.com/your-unique-container-registry-name/api:0.1

docker tag processor:0.1 registry.digitalocean.com/your-unique-container-registry-name/processor:0.1
docker push registry.digitalocean.com/your-unique-container-registry-name/processor:0.1
```

### Enable the cluster to use your registry

The cluster still needs to be able to pull from your registry in order to create pods out of your container images. For that you can use `doctl` to create a secret containing the registry credentials and patch the default service account to use those credentials:

```shell
# Create a secret containing the registry credentials
doctl registry kubernetes-manifest | kubectl apply -f -

# Patch the default service account to use the credentials
kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "registry-your-unique-container-registry-name"}]}'
```

### Deploy the microservices

Now it's time to deploy Redis and our microservices:

```shell
# Deploy Redis first since both microservices depend on it
kubectl apply -f manifests/redis.yaml

kubectl apply -f manifests/api.yaml
kubectl apply -f manifests/processor.yaml
```

If everything went okay, `kubectl get pods` should show you that the pods are running. If not, take a look at `kubectl logs pod-name` to see what went wrong.

### Deploy the load balancer

Finally, let's deploy a load balancer so we can use https://yourveryhipdomain.com to access our API. DigitalOcean already knows about our domain but we still need to create a Kubernetes load balancer with an annotation which refers to our certificate. DigitalOcean will use the annotation to create an A record which will point to the external IP of our load balancer. So let's do just that:

```shell
# Replace the placeholder annotation with the actual certificate UUID and apply the manifest. Note that using list only works if you have a single certificate.
LB_CERT=$(doctl compute certificate list --format ID --no-header) && sed "s/your-certificate-uuid-here/${LB_CERT}/" manifests/load-balancer.yaml | kubectl apply -f -
```

You should be able to see the load balancer being created and eventually receiving its external IP via `kubectl get svc load-balancer-with-https-cert`:

```
NAME                            TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)         AGE
load-balancer-with-https-cert   LoadBalancer   10.245.36.209   143.198.251.79   443:32208/TCP   3m25s
```

If you take a look at the DNS records via `dig yourveryhipdomain.com`, you should also see an A record pointing to the external IP of the load balancer.

### Testing our service

Now that our API is exposed over HTTPS via the load balancer, we can test it out by hitting it with curl:

```shell
curl --request POST --header "Content-Type: application/json" -d '{"title": "hello world"}' https://yourveryhipdomain.com/api/v1/events
```

You should now not only receive an HTTP response from the API, but also be able to use `kubectl logs pod-name` to see both the HTTP request being handled by the API, as well as the event processor receiving the event via the Redis queue. Hooray!

### Cleaning up

Remember to tear down your cluster and clean up your resources after you're done:

```
terraform destroy
```