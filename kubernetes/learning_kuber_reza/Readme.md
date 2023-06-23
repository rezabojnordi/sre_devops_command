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

### Installing kubectl on your private pc
```
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
   curl -LO https://dl.k8s.io/release/v1.27.1/bin/linux/amd64/kubectl
   curl -LO https://dl.k8s.io/release/v1.27.0/bin/linux/arm64/kubectl
   curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
   echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
   sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
   chmod +x kubectl
   mkdir -p ~/.local/bin
   mv ./kubectl ~/.local/bin/kubectl
   # and then append (or prepend) ~/.local/bin to $PATH
   kubectl version --client
```

### How to access on your master with personal pc or laptop

‍‍‍```
complete -F __start_kubectl k
source <(kubectl completion bash)
export KUBECONFIG=/root/kube-aws.yaml
source <(kubectl completion bash)


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

kubectl get ns

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

‍‍``
FROM Ubuntu
entrypoint ["sleep"]
CMD ["5"]

kubectl create -f pod_command_definition.yml

kubectl describe pod ubuntu-sleep-pod

kubectl delete pod ubuntu-sleep-pod
``


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
```
sudo ctr run --rm docker.io/library/nginx:latest my-nginx \
nginx -g "daemon off;"
```

* Note: list container with choose namespace
‍‍```

ctr --namespace=k8s.io container ls


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

kubeadm join 172.16.16.100:6443 --token smc1ws.8bey6mkqz86sgxlf --discovery-token-ca-cert-hash sha256:90b287cb329be6e586f8a22fa0326aa241f6b32ade378320b0850a6aa555ee53 --control-plane --certificate-key 3a873067a998c23ba99e7ca88bcdc1e61d3b44e01f5e486b7d8d96bde43285dd 
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




## How to install microk8s

```
apt install snapd
sudo snap install microk8s --classic
 
sudo snap list

kubectl cluster-ifno


microk8s.kubectl cluster-info

microk8s.kubectl version --short

alias kubectl='microk8s.kubectl


kubectl get nodes -o wide

dpkg -l docker |grep docker

kubectl run nginx

kubectl get namespaces

kubectl get --all-namespaces -o wide

watch kubectl get all -o wide

kubectl run nginx --i mage=nignx

microk8s.docker images
microk8s.inspect

microk8s.reset

kubectl scale deploy nignx --replicas=2
 
or

microk8s.kubectl scale deploy nignx --replicas=2


kubectl expose deploy nginx --port 80 --target-port 80 type Cluster-Ip

apt install elinks

microk8s.reset

microk8s.enable dashboard

kubectl describe pod nignx-dfg66ec

kubectl describe node ubuntuvm0 | grep Taint
```



### How to deploy Dashboard on Kubernetes


```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl get ns
kubectl -n kubernetes-dashboard get all
kubectl -n kubernetes-dashboard describe service kubernetes-dashboard
kubectl -n kubernetes-dashboard  port-forward kubernetes-dashboard-6967859bff-9qr5g 8000:8443
kubectl proxy
```
* Note: Change kubernetes dashboard cluster ip to nodeport
```
 kubectl -n kubernetes-dashboard edit svc kubernetes-dashboard
```

```
apiVersion: v1
kind: Service
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"labels":{"k8s-app":"kubernetes-dashboard"},"name":"kubernetes-dashboard","namespace":"kubernetes-dashboard"},"spec":{"ports":[{"port":443,"targetPort":8443}],"selector":{"k8s-app":"kubernetes-dashboard"}}}
  creationTimestamp: "2023-05-28T05:50:32Z"
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
  resourceVersion: "3125811"
  uid: b07f2ee9-3b62-4780-a359-5f42ddd47bc0
spec:
  clusterIP: 10.107.126.22
  clusterIPs:
  - 10.107.126.22
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - port: 443
    protocol: TCP
    targetPort: 8443
  selector:
    k8s-app: kubernetes-dashboard
  sessionAffinity: None
  type: ClusterIP
status:
  loadBalancer: {}

```
```
apiVersion: v1
kind: Service
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"labels":{"k8s-app":"kubernetes-dashboard"},"name":"kubernetes-dashboard","namespace":"kubernetes-dashboard"},"spec":{"ports":[{"port":443,"targetPort":8443}],"selector":{"k8s-app":"kubernetes-dashboard"}}}
  creationTimestamp: "2023-05-28T05:50:32Z"
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
  resourceVersion: "3131229"
  uid: b07f2ee9-3b62-4780-a359-5f42ddd47bc0
spec:
  clusterIP: 10.107.126.22
  clusterIPs:
  - 10.107.126.22
  externalTrafficPolicy: Cluster
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - nodePort: 32323
    port: 443
    protocol: TCP
    targetPort: 8443
  selector:
    k8s-app: kubernetes-dashboard
  sessionAffinity: None
  type: NodePort
status:
  loadBalancer: {}

```

* Note: afther than save the file
```
kubectl -n kubernetes-dashboard get svc
kubectl get node -o wide

curl https://172.16.16.67:32323/

kubectl -n kubernetes-dashboard get sa

kubectl -n kubernetes-dashboard create token kubernetes-dashboard

```
* Note: If you deploy dashboard and got error You will deploy this config yaml on your clutser
```
kubectl create -f sa_cluster_admin.yaml

```

### create myshell with image on the kubernetes cluster
```
kubectl run myshell --rm -it --image busybox -- sh

kubectl run nginx --image nginx   ## lunch nginx on kubernetes

kubectl get all -o wide

kubectl port-forward nginx 8080:80

kubectl describe pod nginx

kubectl describe pods -o wide

kubectl logs nginx

kubectl run nginx -- image nginx --replicas 2

kubectl scale deploy nginx --replicas 2
```

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

```
kubectl get deployment  # get information about nginx-deployment
kubectl scale deploy nginx-deployment --replicas 3

kubectl expose deployment nginx --type NodePort --port 80

kubectl get deploy nginx - o yaml > /tmp/nginx.yaml

kubectl get svc nginx - o yaml > /tmp/nginx-service.yaml

kubectl delete deploy nginx-deployment


```

## Kubernetes pod replicasets deployment

* 1-nginx-deployment.yaml
```
 apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    run: nginx
  name: nginx-deploy
spec:
  replicas: 2
  selector:
    matchLabels:
      run: nginx
  template:
    metadata:
      labels:
        run: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
 
```  
* 1-nginx-pod.yaml
```
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
```
* 1-nginx-replicaset.yaml
```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  labels:
    run: nginx
  name: nginx-replicaset
spec:
  replicas: 2
  selector:
    matchLabels:
      run: nginx
  template:
    metadata:
      labels:
        run: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
```

```
kubectl create -f 1-nginx-pod.yml
kubectl get events
kubectl describe pods nginx
kubectl delete -f 1-nginx-pod.yaml

kubectl create -f 1-nginx-replicaset.yaml

kubectl delete pod nignx-replicaset

kubectl delete -f 1-nginx-replicaset.yaml
kubectl get all -o wide

kubectl create -f 1-nginx-deployment.yaml

kubctl scale deploy nginx-deploy --replicas=3
kubectl delete -f 1-nginx-deployment.yaml
kubectl delete deploy nginx-deploy


kubectl -n kube-system get pod kube-proxy-dfllj -o yaml > mypod.yaml

```

## Kubernetes Namespace and contexts

```
kubectl get ns

kubectl --namespace  kube-system get pods

kubectl create namespace demo

kubectl config view

kubectl config get-contexts

kubectl config set-context kubesys --namespace=kube-system --user=kubernetes-admin --cluster=kubernetes

kubectl config get-contexts

kubectl config current-context

kubectl config set-context demo --namespace=demo --user=kubernetes-admin --cluster=kubernetes

kubectl config get-contexts
kubectl config use-context demo
alias kcc='kubectl config current-context'
alias kuc='kubectl config use-context'
kuc demo
kubectl config use-context kubernetes-admin@kubernetes 



```

## Node Selector 

```
kubectl label node worker disktype=fast 
kubectl label node worker demoserver=true
kubectl get node worker --show-labels

kubectl scale deploy nginx-deploy --replicas=3
```
* Note: change deployment config for labels

```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    run: nginx
  name: nginx-deploy
spec:
  replicas: 2
  selector:
    matchLabels:
      run: nginx
  template:
    metadata:
      labels:
        run: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
      nodeSelector:
        demoserver: "true"
  
```
```
kubectl create -f 1-nginx-deployment.yml

kubectl describe pod nignx-deployment-85dsdcd-sasa | less
```

### Pod Node Selector admission 

* NOTE: worker1 = dev
* NOTE: worker2 = prod
* NOTE: create namespace for dev and prod
 
```
kubectl label node worker env=prod
kubectl label node worker env- # remove lable on controller
kubectl label node worker1 env= dev

kubectl create ns dev
kubectl create ns prod
kubectl get ns


```
* NOTE: add PodNodeSelector admission on the api file in the /etc/kubernetes/manifests

```
vim  /etc/kubernetes/manifests/kube-apiserver.yaml
- --enable-admission-plugins=NodeRestriction,PodNodeSelector

```

* How to edit namespace
```
kubectl edit ns dev
run his command on the vim = :syntax off

```

```
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: "2023-05-31T13:28:47Z"
  labels:
    kubernetes.io/metadata.name: dev
  name: dev
  annotations:
    scheduler.alpha.kubernetes.io/node-selector: "env=dev"
  resourceVersion: "3707135"
  uid: 67ae885c-3cb1-4c64-8b13-774c5e2d3a35
spec:
  finalizers:
  - kubernetes
status:
  phase: Active
```

* Note edit namespace for prod
```
kubectl edit ns prod

* change the edit namespace

  name: dev
  annotations:
    scheduler.alpha.kubernetes.io/node-selector: "env=prod"

```
* NOTE: crate nginx-deployment on dev's namespace
```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    run: nginx
  name: nginx-deploy
  namespace: dev
spec:
  replicas: 2
  selector:
    matchLabels:
      run: nginx
  template:
    metadata:
      labels:
        run: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
```

```
kubectl -n dev get pods
kubectl -n dev get deployment

kubectl -n dev get deploy nginx-deploy -o yaml | less

kubectl -n dev delete deploy nginx-deploy

kubectl -n prod run nginx --image nginx --replicas 3

kubectl describe ns dev


```

### Kubernetes DaemonSets

DeamonSets - Node Affinity
```
kubectl create -f daemon.yaml 

kubectl describe daemonsets nginx-daemonset 

kubectl describe pod nginx-deploy-cf67dbb86-95mbx 

kubectl delete daemonsets nginx-daemonset

kubectl get daemonsets -n kube-system 

kubectl get daemonsets kube-proxy -n kube-system  -o yaml |less

kubectl get nodes -l gpupresent=true

kubectl label node worker gpupresent=true

kubectl create -f daemon2.yaml ## add labels this yamls file
kubectl get daemonsets

```

### Kubernetes Jobs and Cronjobs
```
kubectl create -f job.yaml
kubectl get jobds
kubectl get all

kubectl logs helloworld-d82fh 

kubectl describe jobs helloworld 

kubectl delete job helloworld

kubectl create -f job2.yaml

kubectl create -f job3.yaml

kubectl create -f job_activedeadlineseconds.yaml


```

### Kubernetes Cronjob

```
kubectl create -f crontab.yaml

kubectl describe cronjobs helloworld-cron

kubectl delete cronjobs helloworld-cron

Cron wiki @hourly, @weekly, @monthly
deleting cronjobs
successfulJobHistoryLimit
failedJobHistoryLimit
suspending cron jobs (kubectl apply, patch)
concurrencyPolicy (Allow, Forbid & Replace)
idempotency

kubectl create -f crontab_job_history.yaml

kubectl patch cronjobs helloworld-cron-suspend -p '{"spec":{"suspend":false}}'

kubectl -n kube-system get pods
```

### How to add TTLAfterFinished
```
cd /etc/kubernetes/manifests/

vim kube-apiserver.yaml

adding blow command on the kube-apiserver.yaml

    - --authorization-mode=Node,RBAC
    - --feature-gates=TTLAfterFinished=true
  kubectl create -f job_ttl.yam

```

### Init Containers 

* Note: If I want to accees to the cluster with my pc I will run blow command
* Note: init container is cotainer for copying file on volume befor up nginx or product containers

```
mkdir ~/.kube
scp root@ip:/etc/kubernetes/admin.conf ~/.kube/config

kubectl cluster-info

kubectl get node

kubectl create -f init_container.yaml

kubectl describe deployments nginx-deploy |less 

kubectl expose deployment nginx-deploy --type NodePort --port 80

kubectl get all

curl http://172.16.16.67:31379/

kubectl scale deployment nginx-deploy --replicas=3

kubectl delete svc nginx-deploy 

kubectl delete deployments nginx-deploy

```


### persistent Volumes and Claims
```
1. create a pv (persistent volume)
2. Create a PVC (persistent volume claim)
3. Pod that uses the pvc -> pv


ReclaimPolicy
1. Retain
2. Recycle
3. Delete

Access Mode:
1. RWO
2. RWM
3. RO


PersistentVolume types are implemented as plugins. Kubernetes currently supports the following plugins:

cephfs - CephFS volume
csi - Container Storage Interface (CSI)
fc - Fibre Channel (FC) storage
hostPath - HostPath volume (for single node testing only; WILL NOT WORK in a multi-node cluster; consider using local volume instead)
iscsi - iSCSI (SCSI over IP) storage
local - local storage devices mounted on nodes.
nfs - Network File System (NFS) storage
rbd - Rados Block Device (RBD) volume

he following types of PersistentVolume are deprecated. This means that support is still available but will be removed in a future Kubernetes release.

awsElasticBlockStore - AWS Elastic Block Store (EBS) (deprecated in v1.17)
azureDisk - Azure Disk (deprecated in v1.19)
azureFile - Azure File (deprecated in v1.21)
cinder - Cinder (OpenStack block storage) (deprecated in v1.18)
flexVolume - FlexVolume (deprecated in v1.23)
gcePersistentDisk - GCE Persistent Disk (deprecated in v1.17)
portworxVolume - Portworx volume (deprecated in v1.25)
vsphereVolume - vSphere VMDK volume (deprecated in v1.19)
Older versions of Kubernetes also supported the following in-tree PersistentVolume types:

photonPersistentDisk - Photon controller persistent disk. (not available starting v1.15)
scaleIO - ScaleIO volume (not available starting v1.21)
flocker - Flocker storage (not available starting v1.25)
quobyte - Quobyte volume (not available starting v1.25)
storageos - StorageOS volume (not available starting v1.25)

```


### loca type in PersistentVolume

```
ssh worker
mkdir /kube
chmod 777 /kube

kubectl create pv-hostpath.yaml

kubectl get pv

kubectl get pvc
kubectl create pvc-hostpath.yaml  ## pvc connect to pv for container or pod

kubectl get pvc

kubectl get pvc-hostpath.yaml
```



### creating container with Volume
```
kubectl create busybox-pv-hostpath.yaml

kubectl get all -o wide

kubectl exec busybox ls  ## depricated
* Note: kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
kubectl exec busybox -- ls

kubectl exec busybox -- ls /mydata

kubectl exec busybox -- touch /mydata/hello.txt

kubectl exec busybox -- ls /mydat

kubectl delete pod busybox.

kubectl get pv,pvc

kubectl delete pvc pvc-hostpath

ssh worker

ls /kube/

kubectl delete pv pv-hostpath


kubectl create -f 4-pv-hostpath.yaml 

kubectl create -f pvc-hostpath.yaml

kubectl get pv,pvc

kubectl get nodes -l demoserver=true 

* Note: If there are not worker when you up comand You will run blow command

kubectl label node worker demoserver=true

kubectl get all

kubectl create -f busybox-pv-hostpath_nodeselector.yaml

kubectl exec busybox -- touch /mydata/reza

```

### How to change policy on the claimed

```
kubectl get pv pv-hostpath -o yaml 

* Note: by the default policy is Retain
     persistentVolumeReclaimPolicy: Retain
Note: if you change polict on pv you need to delete pod,pvc and pv
kubectl delete pod busybox 
kubectl delete pvc pvc-hostpath
kubectl delete pv pv-hostpath
kubectl create -f pv-hostpath_delete.yaml
kubectl get pv
kubectl create -f pvc-hostpath.yaml
kubectl get pvc
kubectl get pvc,pv
kubectl delete pvc pvc-hostpath   #if you add policy on the pv and then you delete pvc your pv was changed status 
kubectl get pv
kubectl describe pv pv-hostpath 
kubectl delete pv pv-hostpath

kubectl get pv,pvc

* Note: 

```

### Installing Nfs on server 
```
apt install nfs-server,
vim /etc/exports
  #/srv/nfs/kube/ 172.16.16.67/24(rw,sync)
  /srv/nfs/kube/ *(rw,sync)

sudo exportfs -f
sudo showmount -e

ssh worker and run blow command
   * mount 172.16.16.67:/srv/nfs/kube /mnt

  
kubectl create -f pv-hostpath_nfs.yaml

```


### pv-nfs.yaml

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-nfs-pv1
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  nfs:
    server: <nfs server ip>
    path: "/srv/nfs/kubedata"

```

### pvc-nfs.yaml
‍‍‍
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-nfs-pv1
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 500Mi

```


### Using Secrets in Kubernetes


‍‍‍‍```
echo -n 'kubeadmin' | base64  #username
echo -n 'mypassword' | base64  #password
```
```
apiVersion: v1
kind: Secret
metadata:
  name: secret-demo
type: Opaque
data:
  username: a3ViZWFkbWlu
  password: bXlwYXNzd29yZA==
```


```
kubectl get secret
kubectl get secret -o yaml
kubectl describe secret secret-demo

kubectl delete secrets secret-demo

kubectl create secret --help

kubectl create secret generic --help |less

kubectl create secret generic secret-demo --from-literal=username=kubeadmin --from-literal=password=mypassword

vim username  ## adding kubeadmin

vim password ## adding mypassword

kubectl create secret generic secret-demo --from-file=./username --from-file=./password

kubectl get secrets

kubectl describe secrets secret-demo 

kubectl get secrets secret-demo -o yaml

kubectl describe secrets secret-demo 

kubectl exec -it busybox -c containername

kubectl exec -it busybox -- sh
  env | grep myusername


kubectl delete pod busybox


vim pod-secret-volume.yaml
kubectl create -f pod-secret-volume.yaml

kubectl get pods -o wide

kubectl exec -it busybox -- sh
   ls /mydata/

```

* Note: How to change secret key You can add parameter or string on secret.yaml
```
kubectl apply -f secret.yaml
kubectl describe secrets secret-demo

kubectl exec -it busybox -- sh
```
* Note: you don't need to recreate pod because automatically updated

  kubectl exec -it busybox -- sh
```

## ConfigMaps

```
kubectl get configmaps
kubectl get cm

kubect create -f configmap-1.yaml

kubectl describe configmaps demo-configmap

kubectl get configmaps demo-configmap -o yaml
kubectl get cm demo-configmap -o yaml

kubectl create configmap demo-configmap-1 --from-literal=channel.name=justmeandopensource --from-literal=channel.owner="Venkat Nagappan"

kubectl get cm demo-configmap-1 -o yaml 

kubectl create -f pod-configmap-env.yaml

kubectl get pods

kubectl exec -it busybox -- sh
   * env
   * env |grep -i channel
* Note: Using pod configmap
kubectl create -f pod-configmap-volume.yaml
kubectl get pods

kubectl exec -it busybox -- sh
  * cd /mydata/


kubectl get cm

kubectl edit cm demo-configmap


```
* Mysql config Map

```
mkdir misc
vim my.cnf
```
* my.ncnf
```
[mysqld]
pid-file	= /var/run/mysqld/mysqld.pid
socket		= /var/run/mysqld/mysqld.sock
port		= 9999
datadir		= /var/lib/mysql
default-storage-engine = InnoDB
character-set-server = utf8
bind-address		= 127.0.0.1
general_log_file        = /var/log/mysql/mysql.log
log_error = /var/log/mysql/error.log

```

```
kubectl create configmap mysql-demo-config --from-file=misc/my.cnf

kubectl get cm mysql-demo-config  -o yaml

kubectl get cm

```

or

```
kubectl create -f configmap-2.yaml

kubectl crete -f configmap-mysql-volume.yaml

kubectl  get pod

kubectl exec -it busybox -- sh

```


### Immutable Secrets & ConfigMap

```
kubectl create secret generic mysecret --from-literal=username=kubeadmin --from-literal=password=mypassword

kubectl get secret

kubectl describe secrets mysecret 

kubectl edit secrets mysecret 

```
* Note: If you add immutables parameter on the Secret You wont changed it.

```
apiVersion: v1
data:
  password: bXlwYXNzd29yZA==
  username: YWxpY2UK
immutable: true
kind: Secret
metadata:
  creationTimestamp: "2023-06-14T06:45:44Z"
  name: mysecret
  namespace: default
  resourceVersion: "6053759"
  uid: 1601cfc5-822f-40af-a831-4a2a69cefcbb
type: Opaque

```


## Resource Quotas & Limits

```
kubectl create namespace quota-demo-ns
kubectl get ns
kubectl create -f quota-count.yaml
kubectl get resourcequotas -n quota-demo-ns
kubectl describe resourcequotas -n quota-demo-ns
kubectl -n quota-demo-ns describe quota quota-demo1  
* Note: if you uo command that you see configma aqual one blow command won't run it.
kubectl -n quota-demo-ns create configmap cm1 --from-literal=name=venkatn

kubectl -n quota-demo-ns create configmap cm1 --from-literal=name=venkatn
* output: error: failed to create configmap: configmaps "cm1" is forbidden: exceeded quota: quota-demo1, requested: configmaps=1, used: configmaps=1, limited: configmaps=1
```


* pod-quota-mem


```
kubectl create -f pod-quota-mem.yaml

kubectl get pod -n quota-demo-ns
kubectl describe -n quota-demo-ns resourcequotas quota-demo1 

kubectl -n quota-demo-ns describe quota quota-demo1
```
* Limiting mem on the resurce
```
 kubectl create -f quota-mem.yaml 
kubectl get -n quota-demo-ns resourcequotas quota-demo-mem
or 
kubectl get -n quota-demo-ns quota quota-demo-mem

```

* Adding limitation on the pods
```
kubectl create -f pod-quota-mem-exceed.yaml
kubectl get pods -n quota-demo-n
kubectl -n quota-demo delete cm cm1
kubectl delete pod -n quota-demo-ns mem-limit
 
```
### Renaming kubernetes Name

```
ssh worker

hostname set-hostname kubeworker1.example.com

reboot

journalctl --until=kubelet

systemctl status kubelet.service

```

```
ssh master

kubectl edit node worker
  :%s/worker/kubeworker1/g

kubect get node

kubectl delete node worker

kubectl get nodes

ssh worker

kubeadm reset

```


or

```
kubectl drain worke31  # this command remove worker3 from the kubernetes cluster

kubectl get all -o wide
ssh worker3
kubeadm reset

vim /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
  $KUBELET_EXTRA_ARGS --hostname-override=kubeworker


systemctl deamon-reload


kubeadm reset

ssh master

kubectl get nodes

ssh worker2
kubeadm join ip --token tokens --descovery-token-ca-cert-hash

ssh master
kubectl delete node kworker2

kubectl get all -o wide
```


## How to setup Rancher to manage your Kubernetes Cluster


* Start the server
To install and run Rancher, execute the following Docker command on your host:
```
sudo docker run --privileged -v /opt/rancher -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher
or 
sudo docker run --privileged --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher

curl localhost

  

```

## Performing Rolling Updates in Kubernetes
```
kubectl create -f nginx-rolling-update.yml
* Change nginx 1:14 to 1.14.2

kubectl apply -f nginx-rolling-update.yml


kubectl rollout status deployment nginx-deploy  #back to old version

kubectl rollout history deployment nginx-deploy

kubectl set image deployment nginx-deploy nginx=nignx:1.15  # set nginx:1.15 insted of 1.14.2

kubectl rollout history deployment nginx-deploy --revision 3

kubectl rollout status deployment nginx-deploy

ctr image pull docker.io/library/nginx:1.15

kubectl set image deployment nginx-deploy nginx=nginx:latest


kubectl rollout status deployment nginx-deploy

kubectl delete deployments.apps nginx-deploy

kubectl annotate deployments.apps nginx-deploy kubernetes.io/change-cause="Update to version latest"

kubectl rollout history deployment nginx-deploy  # up command can help to you that realize your history version

kubectl set image deployment nginx-deploy nginx=nginx:latest --record

kubectl rollout history deployment nginx-deploy 

kubectl create -f nginx-rolling-update-annotation.yaml

kubectl describe deployments.apps nginx-deploy |less

kubectl rollout undo deployment nginx-deploy --to-revision=2 ## reversion 

kubectl rollout pause deployment nginx-deploy

kubectl rollout resume deployment nginx-deploy

kubectl rollout status deployment nginx-deploy


* Note: If your image version doesn't work you must run checkout last version

kubectl set image deployment nginx-deployng nginx=nginx:0.0.0.0  # does'nt work

kubectl rollout status deploy nginx-deploy 

kubectl create -f nginx-rolling-update-recreate.yaml  # rollback to recreate

kubectl set image deploy nginx-deploy nginx=nginx:latest  # all of pod terminated

kubectl delete deployments.apps nginx-deploy

```


## NFS Persistent Volume

<img src="./image/persistent_volume.png" width="1024" height="300" />

```
sudo mkdir -p /srv/nfs/kubedata

sudo chmod -R 777 /srv/nfs

sudo vim /etc/exports
  /srv/nfs/kubedata   *(rw,sync,no_subtree_check,insecure)


sudo exportfs -rav

sudo exportfs -v
showmount -e

ssh worker
ping nfs-server(ip)
showmount -e nfs-server(ip)
mount -t nfs ip:/srv/nfs/kubedata /mnt

mount |grep kube


kubectl create -f pv-nfs.yaml

kubectl get pv

kubectl create -f pvc-nfs.yaml

kubectl get pvc

kubectl create -f nfs-nginx.yaml
kubectl get all -o wide

kubectl exec -it nginx-deploy-559c7cff6c-h65nq -- sh

kubectl expose nginx-deploy --port 80 --type NodePort

kubectl delete svc nginx-deploy 

kubectl delete deploy nginx-deploy

```


## How to use Statefulsets in Kubernetes Cluster

<img src="./image/Statefulsets.png" width="1024" height="300" />
<img src="./image/Statefulsets2.png" width="1024" height="300" />


```
installing nfs server on storage server

cd /srv/nfs/kubedata/
 mkdir {pv0,pv1,pv2,pv3,pv4}
chmod 777 -R /srv/nfs/kubedata/*

sudo exportfs -rav
sudo exportfs -v
sudo showmount -e

kubectl create -f sts-pv.yaml

kubectl get pv



````

<img src="./image/StatefulSets.webp" width="1024" height="300" />

```
kubectl create -f sts-nginx.yaml

kubectl get all -o wide

kubectl get pv,pvc
 
kubectl exec -it nginx-sts-0 -- /bin/sh
  cd /var/www/
  touch hello
  exit
kubectl delete pod nginx-sts-0
  cd /var/www/
  touch hello

kubectl scale sts nginx-sts --replicas=0

kubectl delete pvc --all
kubectl delete pv --all
kubectl delete svc nginx-headless
kubectl delete sts nginx-sts

```


## Containerd and Docker

<img src="./image/docker_containerd.png" width="1024" height="300" />


#### Docker to containerd transition
* better performance
* less overhead
* docker cli ->crictl
* existing image work
* no changes to build images


```
kubectl run nginx --iamge nginx
kubectl get all
kubectl scale deploy nginx replicas=3
kubectl scale deploy nginx-deploy --replicas=3 

```

<img src="./image/docker_to_containerd.png" width="1024" height="300" />

* if you installed docker then containerd is installed so you needed to change kubelet config

```
kubectl cordon worker2   # disable your worker
kubectl drain worker2 --ignore-deamonsets
ssh worker2 or ssh master
  ctr namespace list
  ctr --namespace moby container list
  systemctl stop kubelet
  systemctl stop docker
  apt remove --purge docker*
  ctr namespace list
  ctr --namespace moby container list
  dpkg -L containerd.io |grep toml
  vim /etc/containerd/config.toml
   #disabled_plugins = ["cri"]
  systemctl restart containerd
  vim /var/lib/kubelet/kubeadm-flags.env
   *Note: adding blow string the end of line
   --container-runtime=remote  --container-runtime-endpoint=unix:///run/containerd/containerd.sock"
  systemctl restart kubelet
  kubectl uncordon worker2
ctr namespace list
ctr --namespace k8s.io container list
```

<img src="./image/docker_to_containerd2.png" width="1024" height="300" />
<img src="./image/docker_to_containerd3.png" width="1024" height="300" />
<img src="./image/docker_to_containerd4.png" width="1024" height="300" />



## Dynamic NFS Provisioning

<img src="./image/provision.png" width="1024" height="300" />

```
kubectl cluster-info
kubectl get nodes
kubectl get cs
kubernetes version --shourt

ssh storage-server
apt install nfs-server && apt install nfs-commond
sudo mkdir /srv/nfs/kubedata -p
systemctl enable nfs-server
systemctl status nfs-server
```
```
vim /etc/exports

/srv/nfs/kubedata *(rw,sync,no_subtree_check,no_root_squash,no_all_squash,insecure)

sudo exportfs -rav

sudo exportfs -v
```


```
kubectl get clusterrole,clusterrolebinding,role,rolebind

kubectl create -f rbac.yaml
kubectl get clusterrole,clusterrolebinding,role,rolebind |grep nfs

kubectl create -f class.yaml

kubectl get storageclass

kubectl create -f deployment.yaml

kubectl describe pod nfs-client-provisioner-74cb946769-zqghs |less

kubectl get pv,pvc

vim pvc

```


## Prometheus and Grafana

<img src="./image/prometheus.png" width="1024" height="300" />
<img src="./image/prometheus2.png" width="1024" height="300" />
<img src="./image/prometheus3.png" width="1024" height="300" />


* Secret
* ConfigMap
* service Account
* pvc (perssiten volume Claim)
* Deployment
* Replicaset
* Pod
* DeamonSet
* role Binding or Clutser Role Binding

```
kubectl cluster-ifno
kubectl get nodes
kubectl get pods
kubectl get namespace
kubectl version --short

```
