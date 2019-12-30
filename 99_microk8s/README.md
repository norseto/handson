# What can I do with Microk8s?

This document describes how to use Kubernetes on your local environment and simple debug/test your code with Microk8s. You can check docker build, push images to your local registry, deploy Pods with helm, and so on. This document is described as macOS environment. So, please replace some OS oriented commands.

# Prerequisite

Microk8s is offered with Ubuntu snap package. So, install Canonical’s multipass first. You can install multipass as Microk8s site. If you’re using mac and installed brew, you can simply use brew to install.”$” is a command prompt.

```
$ brew cask install multipass
```

The output will be as follows as below. If you were requested to enter password, enter.

```
Updating Homebrew...
==> Downloading https://github.com/CanonicalLtd/multipass/releases/download/v0.8.0/multipass-0.8.0+mac-Darwin.pkg
Already downloaded: /Users/norihiro.seto/Library/Caches/Homebrew/downloads/be90916c3ef31e1cae6f22d0379725a45e965edbb3a0716ea50a8a28d7158348--multipass-0.8.0+mac-Darwin.pkg
==> Verifying SHA-256 checksum for Cask 'multipass'.
==> Installing Cask multipass
==> Running installer for multipass; your password may be necessary.
==> Package installers may write to any location; options such as --appdir are ignored.
Password:
installer: Package name is multipass
installer: Installing at base path /
installer: The install was successful.
🍺  multipass was successfully installed!
```

# Install Microk8s

## Create a VM
Now we can progress as Microk8s getting started page. First, create a virtual machine under multipass.

```
$ multipass launch --name microk8s-vm --mem 4G --disk 40G
```

The output will be as follows as below. You can reply as you want with “Send usage data“ question.

```
One quick question before we launch … Would you like to help                    
the Multipass developers, by sending anonymous usage data?
This includes your operating system, which images you use,
the number of instances, their properties and how long you use them.
We’d also like to measure Multipass’s speed.

Send usage data (yes/no/Later)? no
Launched: microk8s-vm
```

Next, enter into the virtual machine created now.

```
$ multipass shell microk8s-vm
```

Congrats. VM is running.

```
Welcome to Ubuntu 18.04.3 LTS (GNU/Linux 4.15.0-72-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Thu Dec 12 17:22:06 JST 2019

  System load:  0.0               Processes:             102
  Usage of /:   2.6% of 38.60GB   Users logged in:       0
  Memory usage: 3%                IP address for enp0s2: 192.168.64.2
  Swap usage:   0%

 * Overheard at KubeCon: "microk8s.status just blew my mind".

     https://microk8s.io/docs/commands#microk8s.status

0 packages can be updated.
0 updates are security updates.


To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.
```

## Install Microk8s and setup
Next, copy and paste below.
```
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
```

## Connect Microk8s from outside VM

To connect Microk8s from outside VM, we need to get the configuration file for Microk8s.Enter VM and get configuration by kubectl command.

```
multipass@microk8s-vm:~$ kubectl config view --raw
```

This may like as follows. We can copy this output and paste it outside VM and create the configuration file.In this example, the configuration file is saved as microk8s.config. You can also create the configuration file directly into the host machine. To do so, we should mount the host directory to VM.

```
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTi...TooLong...S0tLQo=
    server: https://127.0.0.1:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
current-context: microk8s
kind: Config
preferences: {}
users:
- name: admin
  user:
    password: aHZjVEhUVXJzTTFPaE9IL3Y1UWNXV3BCdFNFTUpTcWxobXBIMjBaOUQvUT0K
    username: admin
```

We should change server: https://127.0.0.1:16443 to actual VM IP address. Logout VM and get VM IP address by multipass list command. In this example, replace 127.0.0.1 to 192.168.64.2

```
$ multipass list
Name                    State             IPv4             Image
microk8s-vm             Running           192.168.64.2     Ubuntu 18.04 LTS
```

Then use --kubeconfig option of kubectl command to connect to Microk8s.

```
$ kubectl --kubeconfig microk8s.config get ns
NAME                 STATUS   AGE
container-registry   Active   18m
default              Active   19m
kube-node-lease      Active   19m
kube-public          Active   19m
kube-system          Active   19m
```

## Local container registry
Microk8s have a local container registry in it. And already enabled. Its port is 32000. So, you can pull/push with this port like `localhost:32000/yourimage:latest`.

