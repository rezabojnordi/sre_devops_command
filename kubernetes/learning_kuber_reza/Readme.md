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
<img src="./image/replication_controller.png" width="600" height="300" />
<img src="./image/replication_controller1.png" width="600" height="300" />
<img src="./image/replication_controller3.png" width="600" height="300" />
<img src="./image/replication_controller4.png" width="600" height="300" />
<img src="./image/replication_controller5.png" width="600" height="300" />



### replicaset
```
kubectl create -f replicaset-definition.yml
kubectl get replicaset
```
<img src="./image/replicaset.png" width="600" height="300" />


## labels and selectors
 
<img src="./image/lables_selector.png" width="600" height="300" />

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
<img src="./image/scale.png" width="600" height="300" />

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
<img src="./image/deployment.png" width="600" height="300" />
<img src="./image/deployment1.png" width="600" height="300" />
<img src="./image/deployment1.png" width="600" height="300" />


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
<img src="./image/nmap.png" width="600" height="300" />
<img src="./image/nmap3.png" width="600" height="300" />
<img src="./image/nmap4.png" width="600" height="300" />
<img src="./image/namespace5.png" width="600" height="300" />
<img src="./image/namespace6.png" width="600" height="300" />
<img src="./image/namespace7.png" width="600" height="300" />


### switch namespace

```
kubectl config set-context $(kubectl config current-context) --namespace=dev

kubectl get pods --namespace=default

kubectl get pods --all-namespaces

```
<img src="./image/switch_container.png" width="600" height="300" />

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


### creating container with run command

```
kubectl apply -f pod-ubuntu-sleeper

kubectl describe pod ubuntu-sleeper-2


kubectl run webapp-green --image=kodekloud/webapp-color --restart=Never --dry-run=client -o yaml > pod-webapp.yaml


```

### Creating config map

```
config-map create

apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  key: value
```

<img src="./image/configmap.png" width="600" height="300" />
<img src="./image/configmap2.png" width="600" height="300" />
<img src="./image/configmap3.png" width="600" height="300" />
<img src="./image/configmap4.png" width="600" height="300" />
<img src="./image/configmap4.png" width="600" height="300" />

## other exam

Note: 1 and 2 are the same
```
1. docker run -e APP_COLOR=pink simple-webapp-color



2. 
apiVersion: v1
kind: Pod
ma:
  name: simple-webapp-color
spec:
  containers:
  - name: simple-webapp-color
    image: simple-webapp-color
    ports:
      - containerPort: 8080
    env:
      - name: APP_COLOR
        value: pink

```

## How many configmap on the cluster

```
kubectl get cm

kubectl describe cm kube-root-ca.crt

kubectl create cm webapp-color --from-literal=APP_COLOR=darkblue

kubectl explain pods --recursive | grep envFrom -A3

```

### secret

```
kubectl create -f secret-data.yaml

kubectl ger secrets
   
kubectl describe secrets app-secret

kubectl get secret app-secret -o yaml

kubectl create -f pod-definition.yaml

kubectl get pods

kubectl create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123

kubectl describe secrets db-secret


```
<img src="./image/secret.png" width="600" height="300" />
<img src="./image/secret2.png" width="600" height="300" />
<img src="./image/resource.png" width="600" height="300" />
<img src="./image/resource2.png" width="600" height="300" />


### Encode Secrets
```
echo -n 'mysql' | base64

echo -n 'root' | base64

echo -n 'paswrd' |base64
```

### Decode Secrets
```
echo -n 'bXlzcW=' | base64 --decode
```


### create dashboard on kuber
```
kubectl create serviceaccount dashboard-sa

kubectl get serviceaccount

kubectl describe serviceaccount dashboard-sa
```

### exec on container with kubectl

```
kubectl exec -it my-kubernetes-dashboard ls /etc/
```


### Respurce Requests
```

kubectl apply -f resource-request.yml
```


### Taints - Node
Note Noschedule | PrefereNoschedule | NoExecute
```
kubectl taint nodes node-name key=value:taint-effect

kubectl taint nodes node1 app=blue:NoSchedule

kubectl apply -f taint.yaml

kubectl describe node master | grep Taint  # prevant kubernetes deploy pod on master node

kubectl taint node worker1 spray=mortein:NoSchedule

kubectl describe node worker1 |grep -i taint

```
<img src="./image/taint_toleration.png" width="600" height="300" />
<img src="./image/taint_toleration2.png" width="600" height="300" />
<img src="./image/taint_toleration2.png" width="600" height="300" />
<img src="./image/taint_toleration3.png" width="600" height="300" />
<img src="./image/taint_toleration4.png" width="600" height="300" />
<img src="./image/taint_toleration5.png" width="600" height="300" />

### Node Selectors


```
kubectl label nodes <node-name> <labe1-key>=<label-value>

kubectl label nodes worker1 size=Large

kubectl apply -f node-selector.yaml

```
<img src="./image/nodeselector.png" width="600" height="300" />
<img src="./image/NodeSelector1.png" width="600" height="300" />
<img src="./image/NodeSelector2.png" width="600" height="300" />
<img src="./image/NodeSelector3.png" width="600" height="300" />
<img src="./image/NodeSelector4.png" width="600" height="300" />

### node Affinity

```
kubectl create -f affinity.yaml
kubectl create -f affinity-nolabel.yaml
kubectl create -f affinity-small.yaml

kubectl get nodes worker1 --show-labels

kubectl label nodes worker1 color=blue  # afther tha run previus command


kubectl create deployment blue --image=nginx
kubectl scale deployment blue --replicas=6
kubectl get deployment
kubectl get pods -o wide

kubectl get deployment.apps blue -o yaml > blue.yaml
vim blue.yaml # I changed the blue.yaml with this link  (https://kubernetes.io/docs/tasks/configure-pod-container assign-pods-nodes-using-node-affinity/)

kubectl apply -f blue.yaml  


```
<img src="./image/affinity.png" width="600" height="300" />
<img src="./image/affinity1.png" width="600" height="300" />
<img src="./image/affinity3.png" width="600" height="300" />
<img src="./image/affinity4.png" width="600" height="300" />

### Taint and Toleration vs node Affinity

```

```
<img src="./image/afinity_vs_taint.png" width="600" height="300" />
<img src="./image/afinity_vs_taint1.png" width="600" height="300" />
<img src="./image/afinity_vs_taint3.png" width="600" height="300" />
<img src="./image/afinity_vs_taint4.png" width="600" height="300" />
<img src="./image/afinity_vs_taint5.png" width="600" height="300" />
<img src="./image/afinity_vs_taint6.png" width="600" height="300" />
<img src="./image/afinity_vs_taint9.png" width="600" height="300" />

### Multiy container Pods
```
kubectl apply -f multiy-container.yaml
 
kubectl run yellow --image=busybox --restart=Never --dry-run=client -o yaml > yellow.yaml
kubectl apply -f yellow.pod

kubectl describe pods yellow.yaml

kubectl -n elastic-stack get pod,svc   # n is argumant for namespaces

kubectl -n elastick-stack logs app

kubectl -n elastic-stack get pod  app -o yaml > app.yaml



```
<img src="./image/multi_container.png" width="600" height="300" />
<img src="./image/multy_container_ambassador.png" width="600" height="300" />

### Pod conditions


```
kubectl describe pod
```
<img src="./image/pod_condition.png" width="600" height="300" />
<img src="./image/pod_condition1.png" width="600" height="300" />
<img src="./image/pod_condition3.png" width="600" height="300" />

### Readiness Probe

```

kubectl apply -f reading_probe_http.yaml
kubectl apply -f reading_probe_tcp.yaml
kubectl apply -f reading_probe_command.yaml

```


### Liveness Probes

```


```
<img src="./image/liveness_probes.png" width="600" height="300" />
<img src="./image/liveness_probes1.png" width="600" height="300" />




### Logs

```
kubectl create -f event-similator.yaml

kubectl logs -f event-similator-pod

kubectl logs -f event-simulator-pod event-similator  # if you deploye multipod you will need to clarify your container's name

```


#### Monitoring Kubernetes cluster
```

minikube addons enable metrics-server

git clone https://github.com/kubernetes-sigs/metrics-server

kubectl create -f deploy/1.8+/

kubectl top node

```
<img src="./image/monitoring.png" width="600" height="300" />
<img src="./image/monitoring1.png" width="600" height="300" />
<img src="./image/monitor_container.png" width="600" height="300" />

### How to work with containerd

```
sudo ctr image pull docker.io/library/nginx:latest
```
* Note: This will download the latest version of the Nginx image from Docker Hub and store it in the containerd image store.

* Note: Create a container: Once you have the Nginx image, you can create a container using the following command:
‍‍‍
‍‍‍```
sudo ctr run --rm docker.io/library/nginx:latest my-nginx \
  nginx -g "daemon off;"
```

* Note: This will create a new container running the Nginx software with the name "my-nginx". The "-g" option is used to specify the Nginx configuration.

* Note: Access the Nginx server: Once the container is running, you can access the Nginx server by opening a web browser and navigating to http://localhost. You should see the default Nginx welcome page.

* Stop the container: When you are finished using the Nginx container, you can stop it using the following command:



## Label, Selectors & Annotations


```
kubectl get pods --selector app=App1

```
<img src="./image/labels.png" width="600" height="300" />
<img src="./image/selectors.png" width="600" height="300" />
<img src="./image/labels_selector.png" width="600" height="300" />
<img src="./image/labels_kubernetes.png" width="600" height="300" />
<img src="./image/labels2.png" width="600" height="300" />
<img src="./image/selector2.png" width="600" height="300" />



## rollout and Versioning

```
kubectl rollout status deployment/myapp-deployemnt
kubectl rollout history deployment/myapp-deployemnt


```

## Upgrades deployment

```
kubectl get replicasets
```
<img src="./image/replicaset_label.png" width="600" height="300" />
<img src="./image/deployment2.png" width="600" height="300" />
<img src="./image/deployment_upgrade.png" width="600" height="300" />

## Rollback

```
kubectl rollout undo deployment/myapp-deployment

kubectl get replicasets

```
<img src="./image/rollback.png" width="600" height="300" />
<img src="./image/summay_deployment_rollback.png" width="600" height="300" />