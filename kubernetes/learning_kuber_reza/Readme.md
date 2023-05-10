## how to install kubernetes without docker on ubuntu 20.4.5


Kubernetes--> Self-Healing, Automated Rollbacks, Horizontal Scaling

<img src="./image/k-architecture.png" width="900" height="300" />
<img src="./image/k-architecture1.png" width="900" height="300" />
<img src="./image/k-architecture2.png" width="900" height="300" />



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
<img src="./image/replication_controller.png" width="900" height="300" />
<img src="./image/replication_controller1.png" width="900" height="300" />
<img src="./image/replication_controller3.png" width="900" height="300" />
<img src="./image/replication_controller4.png" width="900" height="300" />
<img src="./image/replication_controller5.png" width="900" height="300" />



### replicaset
```
kubectl create -f replicaset-definition.yml
kubectl get replicaset
```
<img src="./image/replicaset.png" width="900" height="300" />


## labels and selectors
 
<img src="./image/lables_selector.png" width="900" height="300" />

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
<img src="./image/scale.png" width="900" height="300" />

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
<img src="./image/deployment.png" width="900" height="300" />
<img src="./image/deployment1.png" width="900" height="300" />
<img src="./image/deployment1.png" width="900" height="300" />


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
<img src="./image/nmap.png" width="900" height="300" />
<img src="./image/nmap3.png" width="900" height="300" />
<img src="./image/nmap4.png" width="900" height="300" />
<img src="./image/namespace5.png" width="900" height="300" />
<img src="./image/namespace6.png" width="900" height="300" />
<img src="./image/namespace7.png" width="900" height="300" />


### switch namespace

```
kubectl config set-context $(kubectl config current-context) --namespace=dev

kubectl get pods --namespace=default

kubectl get pods --all-namespaces

```
<img src="./image/switch_container.png" width="900" height="300" />

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

<img src="./image/configmap.png" width="900" height="300" />
<img src="./image/configmap2.png" width="900" height="300" />
<img src="./image/configmap3.png" width="900" height="300" />
<img src="./image/configmap4.png" width="900" height="300" />
<img src="./image/configmap4.png" width="900" height="300" />

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
<img src="./image/secret.png" width="900" height="300" />
<img src="./image/secret2.png" width="900" height="300" />
<img src="./image/resource.png" width="900" height="300" />
<img src="./image/resource2.png" width="900" height="300" />


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
<img src="./image/taint_toleration.png" width="900" height="300" />
<img src="./image/taint_toleration2.png" width="900" height="300" />
<img src="./image/taint_toleration2.png" width="900" height="300" />
<img src="./image/taint_toleration3.png" width="900" height="300" />
<img src="./image/taint_toleration4.png" width="900" height="300" />
<img src="./image/taint_toleration5.png" width="900" height="300" />

### Node Selectors


```
kubectl label nodes <node-name> <labe1-key>=<label-value>

kubectl label nodes worker1 size=Large

kubectl apply -f node-selector.yaml

```
<img src="./image/nodeselector.png" width="900" height="300" />
<img src="./image/NodeSelector1.png" width="900" height="300" />
<img src="./image/NodeSelector2.png" width="900" height="300" />
<img src="./image/NodeSelector3.png" width="900" height="300" />
<img src="./image/NodeSelector4.png" width="900" height="300" />

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
<img src="./image/affinity.png" width="900" height="300" />
<img src="./image/affinity1.png" width="900" height="300" />
<img src="./image/affinity3.png" width="900" height="300" />
<img src="./image/affinity4.png" width="900" height="300" />

### Taint and Toleration vs node Affinity

```

```
<img src="./image/afinity_vs_taint.png" width="900" height="300" />
<img src="./image/afinity_vs_taint1.png" width="900" height="300" />
<img src="./image/afinity_vs_taint3.png" width="900" height="300" />
<img src="./image/afinity_vs_taint4.png" width="900" height="300" />
<img src="./image/afinity_vs_taint5.png" width="900" height="300" />
<img src="./image/afinity_vs_taint6.png" width="900" height="300" />
<img src="./image/afinity_vs_taint9.png" width="900" height="300" />

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
<img src="./image/multi_container.png" width="900" height="300" />
<img src="./image/multy_container_ambassador.png" width="900" height="300" />

### Pod conditions


```
kubectl describe pod
```
<img src="./image/pod_condition.png" width="900" height="300" />
<img src="./image/pod_condition1.png" width="900" height="300" />
<img src="./image/pod_condition3.png" width="900" height="300" />

### Readiness Probe

```

kubectl apply -f reading_probe_http.yaml
kubectl apply -f reading_probe_tcp.yaml
kubectl apply -f reading_probe_command.yaml

```


### Liveness Probes

```


```
<img src="./image/liveness_probes.png" width="900" height="300" />
<img src="./image/liveness_probes1.png" width="900" height="300" />




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
<img src="./image/monitoring.png" width="900" height="300" />
<img src="./image/monitoring1.png" width="900" height="300" />
<img src="./image/monitor_container.png" width="900" height="300" />

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
* Note: list container with choose namespace
```
ctr --namespace=k8s.io container ls
```
* Note change namespace on containerd
‍‍‍```
alias ctr="ctr --address=/run/containerd/containerd.sock --namespace k8s.io"
* Note: This will create a new container running the Nginx software with the name "my-nginx". The "-g" option is used to specify the Nginx configuration.

* Note: Access the Nginx server: Once the container is running, you can access the Nginx server by opening a web browser and navigating to http://localhost. You should see the default Nginx welcome page.

* Stop the container: When you are finished using the Nginx container, you can stop it using the following command:



## Label, Selectors & Annotations


```
kubectl get pods --selector app=App1

```
<img src="./image/labels.png" width="900" height="300" />
<img src="./image/selectors.png" width="900" height="300" />
<img src="./image/labels_selector.png" width="900" height="300" />
<img src="./image/labels_kubernetes.png" width="900" height="300" />
<img src="./image/labels2.png" width="900" height="300" />
<img src="./image/selector2.png" width="900" height="300" />



## rollout and Versioning

```
kubectl rollout status deployment/myapp-deployemnt
kubectl rollout history deployment/myapp-deployemnt


```

## Upgrades deployment

```
kubectl get replicasets
```
<img src="./image/replicaset_label.png" width="900" height="300" />
<img src="./image/deployment2.png" width="900" height="300" />
<img src="./image/deployment_upgrade.png" width="900" height="300" />

## Rollback

```
kubectl rollout undo deployment/myapp-deployment

kubectl get replicasets

kubectl rollout status deployment/myapp-deployment

kubectl rollout history deployment/myapp-deployment

kubectl delete deployment myapp-deployment

kubectl create -f deployment-definition.yml --record

kubectl rollout status deployment/myapp-deployment

kubectl rollout history deployment/myapp-deployment
    REVISION  CHANGE-CAUSE
         kubectl create --filename=deployment-definition.yml --record=true


Note: change the nginx's version after that run blow command

kubectl apply -f deployment-definition.ymlن
Note: You can see status update with blow command

kubectl rollout status deployment/myapp-deployment
Waiting for deployment "myapp-deployment" rollout to finish: 1 out of 3 new replicas have been updated...

kubectl describe deployment

kubectl rollout history deployment/myapp-deployment

ctr --namespace=k8s.io container ls
alias ctr="ctr --address=/run/containerd/containerd.sock --namespace k8s.io"

kubectl set image deployment/myapp-deployment nginx-contaoner=nginx:1.12-perl

kubectl rollout history deployment/myapp-deployment

kubectl rollout undo deployment/myapp-deployment
   Note: deployment.apps/myapp-deployment rolled back

kubectl describe deployment

kubectl create -f deployment-definition.yml --record


```
<img src="./image/rollback.png" width="900" height="300" />
<img src="./image/summay_deployment_rollback.png" width="900" height="300" />



## JOB

```
docker run ubuntu expr 3 + 2
docker ps -a

kubectl create -f pod_expr_definition.yaml

kubectl create -f job-definition.yaml

kubectl get pods

kubectl logs math-add-job-8b9mz

kubectl delete job math-add-job
```
<img src="./image/jobs.png" width="900" height="300" />
<img src="./image/job2.png" width="900" height="300" />

## CronJob

```
kubectl create -f cronjob.yaml
kubectl get cronjob

```
<img src="./image/cronjob.png" width="900" height="300" />



## Service
Services is helping to connect pods together

If pods want to connect other pods that they need to use clusterip and 
If client want to connect to service or microservice on pod they need to use NodePort.
You can use loadbalance on cloud provider likes AWS and GCP.

<img src="./image/service.png" width="900" height="300" />
<img src="./image/services2.png" width="900" height="300" />
<img src="./image/service3.png" width="900" height="300" />
<img src="./image/service4.png" width="900" height="300" />
<img src="./image/service5.png" width="900" height="300" />
<img src="./image/service6.png" width="900" height="300" />

### NodePort

```
kubectl create -f service-definition.yaml

kubectl get service 
```
<img src="./image/nodeport.png" width="900" height="300" />
<img src="./image/nodeport1.png" width="900" height="300" />
<img src="./image/nodeport4.png" width="900" height="300" />
<img src="./image/nodeport5.png" width="900" height="300" />
<img src="./image/nodeport6.png" width="900" height="300" />
<img src="./image/nodeport7.png" width="900" height="300" />


### ClusterIp
```
kubectl create -f service-definiti-clusterip.yaml

kubectl get services
kubectl get svc
kubectl describe service kubernetes

```
<img src="./image/clusterip.png" width="900" height="300" />


### Ingress
```
kubectl create -f ingrees_nginx.yaml

kubectl get deployment

kubectl get ingress

kubectl describe ingress ingress-wear-watch

```

* Note: Create a service for the Nginx ingress controller:

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-ingress
  namespace: ingress-nginx
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
    name: http
  - port: 443
    targetPort: 443
    name: https
  selector:
    app: nginx-ingress-controller

```

* Note: Now you can create an Ingress resource to define your routing rules:
yaml


```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /foo
        pathType: Prefix
        backend:
          service:
            name: my-service
            port:
              name: http

```

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /path1
        pathType: Prefix
        backend:
          service:
            name: backend-service1
            port:
              name: http
      - path: /path2
        pathType: Prefix
        backend:
          service:
            name: backend-service2
            port:
              name: http

```
<img src="./image/ingress.png" width="900" height="300" />
<img src="./image/ingress1.png" width="900" height="300" />
<img src="./image/ingress5.png" width="900" height="300" />
<img src="./image/ingress7.png" width="900" height="300" />
<img src="./image/ingress8.png" width="900" height="300" />
<img src="./image/ingress9.png" width="900" height="300" />
<img src="./image/ingress10.png" width="900" height="300" />
<img src="./image/ingress11.png" width="900" height="300" />
<img src="./image/ingress12.png" width="900" height="300" />
<img src="./image/ingress13.png" width="900" height="300" />




## On kmaster
* Initialize Kubernetes Cluster
* Update the below command with the ip address of kmaster

```
kubeadm init --apiserver-advertise-address=172.16.16.100 --pod-network-cidr=192.168.0.0/16  --ignore-preflight-errors=all
```

### Deploy Calico network
```
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml
```
### Cluster join command
```
kubeadm token create --print-join-command
```

### To be able to run kubectl commands as non-root user
If you want to be able to run kubectl commands as non-root user, then as a non-root user perform these
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

```
kubectl get node
kubectl get nodes -o wide

kubectl get componentstatus

kubectl cluster-info

 kubectl version

 kubectl version --short
```

### kubadm multi master

* Join other nodes to the cluster (kmaster2 & kworker1)
Use the respective kubeadm join commands you copied from the output of kubeadm init command on the first master.

IMPORTANT: You also need to pass --apiserver-advertise-address to the join command when you join the other master node.

* Downloading kube config to your local machine
On your host machine

mkdir ~/.kube
scp root@172.16.16.101:/etc/kubernetes/admin.conf ~/.kube/config


# Set up a Highly Available Kubernetes Cluster using kubeadm
Follow this documentation to set up a highly available Kubernetes cluster using __Ubuntu 20.04 LTS__.

This documentation guides you in setting up a cluster with two master nodes, one worker node and a load balancer node using HAProxy.

## Vagrant Environment
|Role|FQDN|IP|OS|RAM|CPU|
|----|----|----|----|----|----|
|Load Balancer|loadbalancer.example.com|172.16.16.100|Ubuntu 20.04|1G|1|
|Master|kmaster1.example.com|172.16.16.101|Ubuntu 20.04|2G|2|
|Master|kmaster2.example.com|172.16.16.102|Ubuntu 20.04|2G|2|
|Worker|kworker1.example.com|172.16.16.201|Ubuntu 20.04|1G|1|

> * Password for the **root** account on all these virtual machines is **kubeadmin**
> * Perform all the commands as root user unless otherwise specified

## Pre-requisites
If you want to try this in a virtualized environment on your workstation
* Virtualbox installed
* Vagrant installed
* Host machine has atleast 8 cores
* Host machine has atleast 8G memory

## Bring up all the virtual machines
```
vagrant up
```

## Set up load balancer node
##### Install Haproxy
```
apt update && apt install -y haproxy
```
##### Configure haproxy
Append the below lines to **/etc/haproxy/haproxy.cfg**
```
frontend kubernetes-frontend
    bind 172.16.16.100:6443
    mode tcp
    option tcplog
    default_backend kubernetes-backend

backend kubernetes-backend
    mode tcp
    option tcp-check
    balance roundrobin
    server kmaster1 172.16.16.101:6443 check fall 3 rise 2
    server kmaster2 172.16.16.102:6443 check fall 3 rise 2
```
##### Restart haproxy service
```
systemctl restart haproxy
```

## On all kubernetes nodes (kmaster1, kmaster2, kworker1)
##### Disable Firewall
```
ufw disable
```
##### Disable swap
```
swapoff -a; sed -i '/swap/d' /etc/fstab
```
##### Update sysctl settings for Kubernetes networking
```
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```
##### Install docker engine
```
{
  apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  apt update && apt install -y docker-ce=5:19.03.10~3-0~ubuntu-focal containerd.io
}
```
### Kubernetes Setup
##### Add Apt repository
```
{
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
}
```
##### Install Kubernetes components
```
apt update && apt install -y kubeadm=1.19.2-00 kubelet=1.19.2-00 kubectl=1.19.2-00
```
## On any one of the Kubernetes master node (Eg: kmaster1)
##### Initialize Kubernetes Cluster
```
kubeadm init --control-plane-endpoint="172.16.16.100:6443" --upload-certs --apiserver-advertise-address=172.16.16.101 --pod-network-cidr=192.168.0.0/16
```
Copy the commands to join other master nodes and worker nodes.
##### Deploy Calico network
```
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.15/manifests/calico.yaml
```

## Join other nodes to the cluster (kmaster2 & kworker1)
> Use the respective kubeadm join commands you copied from the output of kubeadm init command on the first master.

> IMPORTANT: You also need to pass --apiserver-advertise-address to the join command when you join the other master node.

## Downloading kube config to your local machine
On your host machine
```
mkdir ~/.kube
scp root@172.16.16.101:/etc/kubernetes/admin.conf ~/.kube/config
```
Password for root account is kubeadmin (if you used my Vagrant setup)

## Verifying the cluster
```
kubectl cluster-info
kubectl get nodes
kubectl get cs
```

## haproxy and keepalived
# Set up a Highly Available Kubernetes Cluster using kubeadm
Follow this documentation to set up a highly available Kubernetes cluster using __Ubuntu 20.04 LTS__ with keepalived and haproxy

This documentation guides you in setting up a cluster with three master nodes, one worker node and two load balancer node using HAProxy and Keepalived.



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



   kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```



### How to add new master on kubernetes
```
kubeadm token create --print-join-command

kubeadm certs certificate-key


kubeadm join 172.16.16.100:6443 --token smc1ws.8bey6mkqz86sgxlf --discovery-token-ca-cert-hash sha256:90b287cb329be6e586f8a22fa0326aa241f6b32ade378320b0850a6aa555ee53 --certificate-key c2b2e0b5a4ff13e1f758fe30a9906ea5a9c3096d93b2ca4bef7d20fc06011688


if you want to add new master, You must add controle-plan's parametr

kubeadm init phase upload-certs --upload-certs

kubeadm join 172.16.16.100:6443 --token smc1ws.8bey6mkqz86sgxlf --discovery-token-ca-cert-hash sha256:90b287cb329be6e586f8a22fa0326aa241f6b32ade378320b0850a6aa555ee53 --control-plane --certificate-key 540ba8d81c927ba2e0930df5cca5ca24ae9b54d4ea6b35ba49423d90b63b61e2
```

## Vagrant Environment
|Role|FQDN|IP|OS|RAM|CPU|
|----|----|----|----|----|----|
|Load Balancer|loadbalancer1.example.com|172.16.16.51|Ubuntu 20.04|512M|1|
|Load Balancer|loadbalancer2.example.com|172.16.16.52|Ubuntu 20.04|512M|1|
|Master|kmaster1.example.com|172.16.16.101|Ubuntu 20.04|2G|2|
|Master|kmaster2.example.com|172.16.16.102|Ubuntu 20.04|2G|2|
|Master|kmaster3.example.com|172.16.16.103|Ubuntu 20.04|2G|2|
|Worker|kworker1.example.com|172.16.16.201|Ubuntu 20.04|2G|2|

> * Password for the **root** account on all these virtual machines is **kubeadmin**
> * Perform all the commands as root user unless otherwise specified

### Virtual IP managed by Keepalived on the load balancer nodes
|Virtual IP|
|----|
|172.16.16.100|

## Pre-requisites
If you want to try this in a virtualized environment on your workstation
* Virtualbox installed
* Vagrant installed
* Host machine has atleast 12 cores
* Host machine has atleast 16G memory

## Bring up all the virtual machines
```
vagrant up
```
If you are on Linux host and want to use KVM/Libvirt
```
vagrant up --provider libvirt
```

## Set up load balancer nodes (loadbalancer1 & loadbalancer2)
##### Install Keepalived & Haproxy
```
apt update && apt install -y keepalived haproxy
```
##### configure keepalived
On both nodes create the health check script /etc/keepalived/check_apiserver.sh
```
cat >> /etc/keepalived/check_apiserver.sh <<EOF
#!/bin/sh

errorExit() {
  echo "*** $@" 1>&2
  exit 1
}

curl --silent --max-time 2 --insecure https://localhost:6443/ -o /dev/null || errorExit "Error GET https://localhost:6443/"
if ip addr | grep -q 172.16.16.100; then
  curl --silent --max-time 2 --insecure https://172.16.16.100:6443/ -o /dev/null || errorExit "Error GET https://172.16.16.100:6443/"
fi
EOF

chmod +x /etc/keepalived/check_apiserver.sh
```
Create keepalived config /etc/keepalived/keepalived.conf
```
cat >> /etc/keepalived/keepalived.conf <<EOF
vrrp_script check_apiserver {
  script "/etc/keepalived/check_apiserver.sh"
  interval 3
  timeout 10
  fall 5
  rise 2
  weight -2
}

vrrp_instance VI_1 {
    state BACKUP
    interface eth1
    virtual_router_id 1
    priority 100
    advert_int 5
    authentication {
        auth_type PASS
        auth_pass mysecret
    }
    virtual_ipaddress {
        172.16.16.100
    }
    track_script {
        check_apiserver
    }
}
EOF
```
##### Enable & start keepalived service
```
systemctl enable --now keepalived
```

##### Configure haproxy
Update **/etc/haproxy/haproxy.cfg**
```
cat >> /etc/haproxy/haproxy.cfg <<EOF

frontend kubernetes-frontend
  bind *:6443
  mode tcp
  option tcplog
  default_backend kubernetes-backend

backend kubernetes-backend
  option httpchk GET /healthz
  http-check expect status 200
  mode tcp
  option ssl-hello-chk
  balance roundrobin
    server kmaster1 172.16.16.101:6443 check fall 3 rise 2
    server kmaster2 172.16.16.102:6443 check fall 3 rise 2
    server kmaster3 172.16.16.103:6443 check fall 3 rise 2

EOF
```
##### Enable & restart haproxy service
```
systemctl enable haproxy && systemctl restart haproxy
```
## Pre-requisites on all kubernetes nodes (masters & workers)
##### Disable swap
```
swapoff -a; sed -i '/swap/d' /etc/fstab
```
##### Disable Firewall
```
systemctl disable --now ufw
```
##### Enable and Load Kernel modules
```
{
cat >> /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter
}
```
##### Add Kernel settings
```
{
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system
}
```
##### Install containerd runtime
```
{
  apt update
  apt install -y containerd apt-transport-https
  mkdir /etc/containerd
  containerd config default > /etc/containerd/config.toml
  systemctl restart containerd
  systemctl enable containerd
}
```
##### Add apt repo for kubernetes
```
{
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
  apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
}
```
##### Install Kubernetes components
```
{
  apt update
  apt install -y kubeadm=1.22.0-00 kubelet=1.22.0-00 kubectl=1.22.0-00
}
```
## Bootstrap the cluster
## On kmaster1
##### Initialize Kubernetes Cluster
```
kubeadm init --control-plane-endpoint="172.16.16.100:6443" --upload-certs --apiserver-advertise-address=172.16.16.101 --pod-network-cidr=192.168.0.0/16
```
Copy the commands to join other master nodes and worker nodes.
##### Deploy Calico network
```
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml
```

## Join other master nodes to the cluster
> Use the respective kubeadm join commands you copied from the output of kubeadm init command on the first master.

> IMPORTANT: Don't forget the --apiserver-advertise-address option to the join command when you join the other master nodes.

## Join worker nodes to the cluster
> Use the kubeadm join command you copied from the output of kubeadm init command on the first master


## Downloading kube config to your local machine
On your host machine
```
mkdir ~/.kube
scp root@172.16.16.101:/etc/kubernetes/admin.conf ~/.kube/config
```
Password for root account is kubeadmin (if you used my Vagrant setup)

## Verifying the cluster
```
kubectl cluster-info
kubectl get nodes
kubectl get nodes -o wide
kubectl get pods -A
```
