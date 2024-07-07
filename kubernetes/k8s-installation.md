
# Kubernetes cheatsheet 

First install docker:
```
apt install docker.io
```

### How to install master:
Run this for all nodes
```
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```
### set hostname
```
hostnamectl set-hostname master1 --static
hostnamectl set-hostname worker1 --static
```
### Change native cgroup to systemd
Run this for all nodes
```
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
```
```
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF
```

```
systemctl restart docker
```

### add bridge and off swap
```
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
sudo swapoff -a
```
### For debian:
```
sysctl -p
```
### To start master:
```
kubeadm init
```

### error CRI
```
“[ERROR CRI]: container runtime is not running: output:” Code Answer
rm /etc/containerd/config.toml
systemctl restart containerd
kubeadm init

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf
  
source: https://github.com/containerd/containerd/issues/4581
```
```
To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  export KUBECONFIG=/etc/kubernetes/admin.conf

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 85.208.253.140:6443 --token 18z0lj.3l2bv63tf63or2m9 \
        --discovery-token-ca-cert-hash sha256:aa2518bdc0a2beb02a6aaeaec9da358b95cdcb1d6d498fbca10f0eff6f908
```

Join a node with this command :
```
kubeadm join xxx.xxx.xxx.xxx:6443 --token wqjxpm.vqupwqtp5xyvf1cg \
        --discovery-token-ca-cert-hash sha256:637711c34b8e97dcd7531c8a1eda15725657d84dd39dfcbc8702050927ffe075
```
To join each new node you need to get new token from master master:
```
kubeadm token create --print-join-command
```
Then you will have join command to enter on new node and join
If an error says that: `[ERROR Swap]: running with swap on is not supported. Please disable swap` simply enter `swapoff -a` on the node

```
apt-get install bash-completion
```

Add these to .bashrc for master in root user
```
complete -F __start_kubectl k
source <(kubectl completion bash)
export KUBECONFIG=/etc/kubernetes/admin.conf        
```
```
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```
or
```
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
```
### if you don't have token You can generate it with this command
```
kubeadm token create --print-join-command
```
### check status weave net
```
kubectl get pods --all-namespaces

```
### add autocomplition
```
apt install bash-completion
kubectl completion bash > /etc/bash_completion.d/kubectl
and
kubectl completion bash > ~/.bashrc
```

### get error to join worker
```
kubeadm reset
```

### Get upload certs:
```
kubeadm init phase upload-certs --experimental-upload-certs
```

### In case you want to have access to your cluster though a domain, you can allow it like this:
```
kubeadm init --apiserver-cert-extra-sans ha.doomain.ir
```

### In case you want to pull images from another repository create `config.yaml`
```yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
imageRepository: "registry.myrepo.com/kubernetes" 
kubernetesVersion: v1.22.1
controlPlaneEndpoint: xxx.xxx.xxx.xxx:6443
```
then specify like this:
```
kubeadm init --config config.yaml
```

### Only pull kubernetes images:
```
kubeadm config images pull
```

## check api on openstack
```
kubectl auth can-i create deployment                yes
kubectl auth can-i create deployment --as linda     no
kubectl auth can-i create deployment --namespace secret  yes
