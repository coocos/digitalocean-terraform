# Kubernetes & HTTPS load balancer

A simple example of creating a single node DigitalOcean Kubernetes cluster using Terraform and exposing an Nginx deployment under a custom domain via an HTTPS load balancer. By the end of this example, you should be able to point your browser to https://yourveryhipdomain.com and see an HTTP response from an Nginx pod.

## Usage

### Create Kubernetes cluster with Terraform

Create a `terraform.tfvars` file (or use `export TF_VAR_variable=...`) with your API token and the name of your domain:

```shell
api_token = "yourapitokenshouldgohere"
domain    = "yourveryhipdomain.com"
```

The API token is used by Terraform to create your infrastructure and the domain will be pointed to a load balancer. The domain should not yet exist as a resource in the control panel as Terraform will create it, but you do need to [point your domain to the DigitalOcean nameservers](https://docs.digitalocean.com/tutorials/dns-registrars/) so that DigitalOcean can create DNS records on your behalf and automatically register an SSL certificate for HTTPS.

Next, initialize Terraform and create the cluster and the other resources:

```
terraform init
terraform apply
```

It will take a while but eventually the cluster will be created and Terraform should output a certificate UUID, which we will need to configure the load balancer to use HTTPS:

```
Outputs:

certificate_id = your-certificate-uuid-here
```

Note that the load balancer is not created by Terraform. Instead, we will create the load balancer as a Kubernetes service and DigitalOcean will handle the rest.

### Deploy Nginx and load balancer with kubectl

Once the cluster is up, you can use [doctl](https://github.com/digitalocean/doctl) to grab the kubeconfig for the cluster and set it as the current context:

```
doctl kubernetes cluster kubeconfig save example-cluster
```

You should now be able to use kubectl to access the cluster. You can test this out for example by listing all the currently running pods:

```
kubectl get pods --all-namespaces

NAMESPACE     NAME                               READY   STATUS    RESTARTS        AGE
kube-system   cilium-6trt8                       2/2     Running   1 (5m55s ago)   6m37s
kube-system   cilium-operator-55d7d6bbd7-k5jvv   1/1     Running   0               9m56s
...
```

Next, replace [the value of the do-load-balancer-certificate-id annotation in the load balancer definition in manifests/manifests.yaml](./manifests/manifest.yaml) using the certificate ID outputted by Terraform. You can also grab the certificate ID via `doctl compute certificate list` and for example just use `sed` to replace it. Or perhaps you might even want to use the Terraform Kubernetes provider to create the load balancer and read the certificate ID using a data source. No matter how you go about creating your annotated load balancer, DigitalOcean will use the annotation behind the scenes to enable HTTPS for the load balancer and also to create an A record to the external load balancer IP.

Now you can finally deploy Nginx and create the load balancer via `kubectl apply -f manifests/manifest.yaml`. It will take a while for DigitalOcean to fully create the load balancer but eventually you should be able to see an external IP for your load balancer via `kubectl get svc`:

```
NAME              TYPE           CLUSTER-IP     EXTERNAL-IP       PORT(S)         AGE
https-with-cert   LoadBalancer   10.245.20.10   178.125.121.231   443:32206/TCP   8m18s
kubernetes        ClusterIP      10.245.0.1     <none>            443/TCP         22m
```

It will also take quite a bit of time for the DNS changes to take effect but sooner or later you should be able to access `https://yourveryhipdomain.com` and see your Nginx deployment running.
