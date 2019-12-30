#!/bin/sh

# Install and configure microk8s
sudo snap install microk8s --classic
sudo microk8s.status --wait-ready
sudo microk8s.enable rbac
sudo microk8s.enable dns registry helm
sudo microk8s.kubectl -n kube-system create serviceaccount tiller
sudo microk8s.kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
sudo microk8s.helm init --service-account tiller
sudo usermod -a -G microk8s multipass
sudo snap alias microk8s.kubectl kubectl
sudo snap alias microk8s.helm helm

# Install and configure docker
sudo addgroup --system docker
sudo adduser $USER docker
sudo apt-get update
sudo apt-get install -y make docker.io
