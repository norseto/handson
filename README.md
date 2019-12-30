# Directory Contents

Directory and files.
```
.
|-- .devcontainer                : VSCode remote container files
|   |-- Dockerfile               : Docker file for container
|   |-- devcontainer.json        : VSCode config file
|   |-- Dockerfile_withgo        : Docker file for container with golang
|   `-- devcontainer_withgo.json : VSCode config file with golang
|-- 01_terraform                 : GCP infrastructure terraform files
|   |-- 01_initial               : Initial setup
|   |   |-- backend.tf           : Backend definition(Commented)
|   |   |-- provider.tf          : GCP provider definition
|   |   |-- serviceaccount.tf    : Resource for GCP Service Account
|   |   |-- static_adress.tf     : Static(Global/Region) IP addresses
|   |   `-- vpc.tf               : VPC resource
|   `-- 02_cluster               : GKE cluster setup
|       |-- backend.tf           : Backend definition(Commented)
|       |-- data.tf              : Datasource of GCP infrastructure
|       |-- gkecluster.tf        : GKE cluster resource
|       |-- nat.tf               : NAT resource for GKE node can pull
|       `-- provider.tf          : GCP provider definition
|-- 02_k8s                       : Files for Kubernetes
|   |-- 01_alpine.yaml           : [Pod] Alpine
|   |-- 02_nginx.yaml            : [Deployment] nginx servers
|   |-- 03_cluster_ip.yaml       : [Service] nginx service (ClusterIP)
|   |-- 04_loadbalancer.yaml     : [Service] nginx service (LoadBalancer)
|   |-- 04_tf                    : [Service] terraform nginx service (LoadBalancer)
|   |   |-- data.tf              : Datasource of GCP infrastructure and K8s
|   |   |-- loadbalancer.tf      : [Service] nginx service (LoadBalancer)
|   |   `-- provider.tf          : GCP and K8s provider definition
|   `-- 05_ingress.yaml          : [Ingress] nginx ingress
|-- 99_microk8s                  : Docs about Microk8s
|   |-- README.md                : How to setup Microk8s
|   `-- install.sh               : Setup shell
|-- LICENSE                      : License file
`-- README.md                    : This file
```

# Prerequisite
## Environment
- VS Code
	```
	$ brew cask install visual-studio-code
	```
- Docker
	```
	$ brew cask install docker
	```
- VS Code Remote-Containers extension

## Edit to your environment
- **[project-id]** in `provider.tf` to your project ID.
- **[your_IP_address]** in `gkecluster.tf` to your IP address.
- **[backend-name]** in `backend.tf` to your GCS bucket name.

## GCP
- GCP account
- GCP project
- GCP subscription

You need to login to GCP
```
$ gcloud auth application-default login
```

If you use GCS as a backend, remember to enable versioning.
```
gsutil versioning set on gs://backend-name
```

## Kubernetes
You need to login to GKE cluster after creating it.
```
$ gcloud container clusters get-credentials --zone asia-east1-a hands-on
```

## Terraform provider files
In this hands-on, provider terraform file is hard-coded. So you should update project.

# Docker/K8s Hands on

microk8s : How to install/use microk8s
