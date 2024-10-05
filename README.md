# import_linux_command

## lets start kubenetes

### One Node Master and worker
```bash 
sudo nano /etc/fstab

sudo swapoff -a

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
overlay
br_netfilter
EOF
sudo sysctl --system
sudo modprobe overlay
sudo modprobe br_netfilter

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/containerd.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update


sudo apt install containerd.io -y

sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd


sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/k8s.gpg

echo "deb [signed-by=/etc/apt/keyrings/k8s.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update

sudo apt install kubelet kubeadm kubectl -y
sudo apt-mark hold kubelet kubeadm kubectl
==========================================================================
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

```

### import kubenetes command
```
kubeadm token create --print-join-command

kubectl get nodes

kubectl get pods --all-namespaces --watch
```

### import command kubectl
```
kubectl cluster-info

kubectl get nodes
kubectl get nodes -o wide
kubectl get pods --namespace kube-system

kubectl get pods --namespace kube-system -o wide

kubectl get pods --all-namespaces --watch

kubectl get pods pod1 --output=yaml

kubectl create deployment nginx --image=nginx

kubectl get all --all-namespace | more


kubectl api-resouces | more


kubectl api-resource |grep pod


#explain

kubectl explain pod | more

kubectl explain pod.spec | more

kubectl explain pod.spec.containers | more


kubectl describe nodes worker1 | more

kubectl get -h | more

kubectl get -h | more

sudo apt install bash-completion

echo "source <(kubectl completion bash)" >> ~/.bashrc

source ~/.bashrc

kubectl g[tab]

```


### Application Deployment in kubernetes

```
kubectl create deployment nginx --image=nginx

kubectl run nginx --image=nginx

* Declarative

Define out desired state in code 

Manifest

kubectl apply -f deployment.yaml


```

#### sample1

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world
spec:
  replicas: 1
  selector:
    matchiLabels:
      app: hello-world
template:
   metadata:
    labels:
        app: hello-word
    spec:
      containers:
      - image: gcr.io/google-sample/hello-app:1.0
        name: hello-app
```

```
kubectl apply -f deployment.yaml
```


### Generating Manifests with dry-run

```
kubectl create deployment hello-world --image=gcr.io/google-sample/hello-app:1.0 --dry-run=client -o yaml > deployment.yaml
```

### Demo

```
kubectl create deployment hello-world --image=gcr.io/google-samples/hello-app:1.0

kubectl run hello-world-pod --image=gcr.io/google-samples/hello-app:1.0

* if made mistake

kubectl delete deployment hello-world
kubectl create deployment hello-world --image=gcr.io/google-samples/hello-app:1.0

or
kubectl delete pod hello-world-pod

kubectl get pods
kubectl get pods -o wide

```

#### When containerd is your container runtime, use crictl to get a listing of the containers running
#### Check out this for more details http://kubernetes.io/docs/tasks/debug-application-cluster/crictl

```
sudo crictl --runtime-endpoint unix:///run/containerd/containerd.sock ps

or 

ctr container ls

```

#### back on c1-cp1 we can pull the logs from the container
#### Lanunch a shell into the container
```
kubectl logs hello-world-pod

kubectl exec -it hello-world-pod -- /bin/sh
hostname
ip addr


```

#### Deployment

```
kubectl get deployment hello-world
kubectl get replicast
kubectl get pods

kubectl describe replicaset hello-world |more

kubectl describe pod hello-world |more

```

#### export deployment as service

```
kubectl expose deployment hello-world --port=80 --target-port=8080

```

#### Check out the Cluster-ip

```
kubectl get service hello-world

kubectl describe service hello-world

curl http://$serverIp:$port


```
#### Using kubnect to generate yaml or json
```
kubectl get deployment hello-world -o yaml | more
kubectl get deployment hello-world -o json | more
```


#### Deleting the deployment will delete the replicaset and all deployment test

```
kubectl get all
kubectl delete service hello-world
kubectl delete deployment hello-world
kubectl delete pod hello-world-pod
kubectl get all



```
