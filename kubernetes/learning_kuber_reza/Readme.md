## how to install kubernetes without docker on ubuntu 20.4.5


To install Kubernetes without Docker on Ubuntu 20.04.5, you can follow the below steps:

Install the dependencies required by Kubernetes:
```

sudo apt update
sudo apt install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd


sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
```
Add the Kubernetes signing key:
```

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

```
Add the Kubernetes repository:

```
sudo echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

```

Update the package list and install kubelet, kubeadm, and kubectl:
```
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

```

Prevent automatic updates of the kubelet package:
```
sudo apt-mark hold kubelet

```
Disable swap:
```
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
```
Initialize the Kubernetes cluster with kubeadm:
```
sudo kubeadm init
```
This will create a single-node Kubernetes cluster with kubelet and kubectl configured to use it. You can then deploy your applications on this cluster using Kubernetes manifests or other deployment tools. Note that this is just a basic setup, and you may need to configure additional components for a production environment.



```
cat > pod-definitions.yml
```

```

deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse

deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse

deb http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse

deb http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse

deb http://archive.canonical.com/ubuntu focal partner
deb-src http://archive.canonical.com/ubuntu focal partner
```

if you have this error You will run blow the command
```
root@master1:~# sudo kubeadm init
[init] Using Kubernetes version: v1.27.1
[preflight] Running pre-flight checks
error execution phase preflight: [preflight] Some fatal errors occurred:
        [ERROR FileContent--proc-sys-net-bridge-bridge-nf-call-iptables]: /proc/sys/net/bridge/bridge-nf-call-iptables does not exist
        [ERROR FileContent--proc-sys-net-ipv4-ip_forward]: /proc/sys/net/ipv4/ip_forward contents are not set to 1
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher
root@master1:~# cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf

```
```
modprobe br_netfilter
echo '1' > /proc/sys/net/ipv4/ip_forward
```
```
To make this boot-resistant, add br_netfilter to the list of kernel modules to load at boot time:
echo "br_netfilter" | sudo tee /etc/modules-load.d/netfilter.conf
```

### if you hava error like this 
```
root@master1:~# kubectl get nodes
E0415 12:55:55.691295   16272 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp [::1]:8080: connect: connection refused
E0415 12:55:55.692732   16272 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp [::1]:8080: connect: connection refused
E0415 12:55:55.694083   16272 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp [::1]:8080: connect: connection refused
E0415 12:55:55.694902   16272 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp [::1]:8080: connect: connection refused
E0415 12:55:55.697399   16272 memcache.go:265] couldn't get current server API group list: Get "http://localhost:8080/api?timeout=32s": dial tcp [::1]:8080: connect: connection refused

```


## fix it error
```
 mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  ```


## check the not ready worker and master
```
kubectl get pods -o wide -n kube-system
```


## how to deploy waeave net
```
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml --kubeconfig admin.conf

afther that

kubectl -n kube-system get deployment coredns -o yaml | \
  sed 's/allowPrivilegeEscalation: false/allowPrivilegeEscalation: true/g' | \
  kubectl apply -f -
```

## import command on kubernetes

```
kubectl get pods
```

```
kubectl get nodes
```

### replication controller and replica set

* replication contoller is older technolugay 

```
kubectl create -f rc-definition.yml

kubectl get pods

kubectl get replicationcontroller
```

### replicaset
```
kubectl create -f replicaset-definition.yml
kubectl get replicaset
```

## labels and selectors
 

 ### How to scale replicaset

 ```
 kubectl replace -f replicaset-definition.yml  ## change the replicas

 or

 kubectl scale --replicas=6 -f replicaset-definition.yml

 or

 kubectl scale --replicas=6 replicaset myapp-replicaset

 Type = replicaset
 Name = myapp-replicaset

 ```

### Deployment  
Note: rooling updates, under changes and pause and resume changes as required

```
kubectl create -f deployment-definition.yml

kubectl get deployments

kubectl get pods

kubectl get replicaset

kubectl get all

kubectl create deployment redis-deployment --image=redis --namespace=dev-ns -dry-run=client -o yaml > redis.yaml

kubectl apply -f redis.yml

kubectl get deployment.apps -n dev-ns


```

### Namespace 


```
kubectl get pods

kubectl get pods --namespace=kube-system

kubectl create -f pod-dfinition.yml

kubectl create namespace dev


kubectl create ns dev-ns

or
create namespace with yml file


kubectl create -f pod-definition.yml --namespace=dev

kubectl create -f pod-definition-namespace.yml

kubectl get pods --namesapce=dev

kubectl get pods --namespace=proc
```

### switch namespace

```
kubectl config set-context $(kubectl config current-context) --namespace=dev

kubectl get pods --namespace=default

kubectl get pods --all-namespaces

```

### REsource Quota

```
kubectl crete-f compute-quota.yml

kubectl get ns

kubectl get ns --no-headers

kubectl get ns --no-headers |wc -l

kubectl -n dev get pods --no-headers 

or

kubectl -n dev get pods --no-headers |wc -l

```

```
kubectl run reis --image=redis --dry-run=client -o yaml > pod.yaml
```
* create pod.yaml
```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: reis
  name: reis
  namespace: finance
spec:
  containers:
  - image: redis
    name: reis
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

```

```
kubectl get pods --all-namespaces |grep blue
```


### create nginx apine
```
kubectl run nginx-pod --image=nignx:alpine

kubectl run custome-nginx --image=nginx --port 8080

kubectl describe pods custome-nginx
```

### run redis with lables
```

kubectl run redis --image=redis:alpine --labels=tier=db

kubectl expose pod redis --name redis-service --port 6379 --target-port 6379

kubectl describe svc redis-service

kubectl deployment webapp --image=kodekloud/webapp-color

kubectl scale deployment --replicas=3 webapp

```

### create yml for http

```
kubectl run httpd --image=httpd:alpine --port 80 --expose --dry-run=client -o yaml

kubectl run httpd --image=httpd:alpine --port 80 --expose

kubectl get pod httpd


```


## Configuration

‍‍``` 
FROM Ubuntu
entrypoint ["sleep"]
CMD ["5"]
```
```
kubectl create -f pod_command_definition.yml

kubectl describe pod ubuntu-sleep-pod

kubectl delete pod ubuntu-sleep-pod 
```


