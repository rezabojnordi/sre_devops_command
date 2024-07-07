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
### How to install NFS provisioner

```
$ helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
$ helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=x.x.x.x \
    --set nfs.path=/exported/path
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



## How to change persistent volume to default storage
```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: nfs-client
  uid: ee0ac2f8-0605-4af7-88f9-f9baebf79124
  resourceVersion: '474287'
  creationTimestamp: '2023-06-30T18:34:09Z'
  labels:
    app: nfs-subdir-external-provisioner
    app.kubernetes.io/managed-by: Helm
    chart: nfs-subdir-external-provisioner-4.0.18
    heritage: Helm
    k8slens-edit-resource-version: v1
    release: nfs-subdir-external-provisioner
  annotations:
    meta.helm.sh/release-name: nfs-subdir-external-provisioner
    meta.helm.sh/release-namespace: default
    storageclass.kubernetes.io/is-default-class: 'true'
  managedFields:
    - manager: helm
      operation: Update
      apiVersion: storage.k8s.io/v1
      time: '2023-06-30T18:34:09Z'
      fieldsType: FieldsV1
      fieldsV1:
        f:allowVolumeExpansion: {}
        f:metadata:
          f:annotations:
            .: {}
            f:meta.helm.sh/release-name: {}
            f:meta.helm.sh/release-namespace: {}
          f:labels:
            .: {}
            f:app: {}
            f:app.kubernetes.io/managed-by: {}
            f:chart: {}
            f:heritage: {}
            f:release: {}
        f:parameters:
          .: {}
          f:archiveOnDelete: {}
        f:provisioner: {}
        f:reclaimPolicy: {}
        f:volumeBindingMode: {}
    - manager: node-fetch
      operation: Update
      apiVersion: storage.k8s.io/v1
      time: '2023-07-01T06:34:14Z'
      fieldsType: FieldsV1
      fieldsV1:
        f:metadata:
          f:annotations:
            f:storageclass.kubernetes.io/is-default-class: {}
          f:labels:
            f:k8slens-edit-resource-version: {}
  selfLink: /apis/storage.k8s.io/v1/storageclasses/nfs-client
provisioner: cluster.local/nfs-subdir-external-provisioner
parameters:
  archiveOnDelete: 'true'
reclaimPolicy: Delete
allowVolumeExpansion: true
volumeBindingMode: Immediate
```

```
storageclass.kubernetes.io/is-default-class: 'true'

or

kubectl patch storageclass nfs-client -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

```

## Ingress and LoadBalancer






<img src="./image/ingress-service.png"/>


<img src="./image/ingress_controller.png"/>

<img src="./image/ingress_controller.png"/>
<img src="./image/clusterip_service.png"/>
<img src="./image/service_communicate.png"/>

### Nginx Ingree controller

if you want to deploy haproxy for sending trrafic beetwen workers nodes


<img src="./image/haproxy_worker.png"/>

``` bash
frontend http_front
  bind *:80
  stats uri /haproxy?stats
  default_backend http_back

backend http_back
  balance roundrobin
  server worker1 <worker-node1-ip>:80
  server worker2 <worker-node2-ip>:80


```
```
https://github.com/kubernetes/ingress-nginx

https://github.com/kubernetes/ingress-nginx.git
```




<img src="./image/database_service.png"/>

<img src="./image/multi_port.png"/>

<img src="./image/cockroachdb.png"/>



<img src="./image/headless.png"/>


<img src="./image/node_port.png"/>

<img src="./image/node_port2.png"/>

```
Range 30000 - 32767
```

<img src="./image/wrap_up.png"/>

## Installing wordpress with Helmchart
```
helm install my-release oci://registry-1.docker.io/bitnamicharts/nginx-ingress-controller
kubectl create -f ingress-resource.yaml
helm upgrade -i my-release --values values_ingree.yaml oci://registry-1.docker.io/bitnamicharts/nginx-ingress-controller --namespace ingress-nginx

* cheacking the webhook in ingress

kubectl get validatingwebhookconfigurations.admissionregistration.k8s.io


helm install wordpress  oci://registry-1.docker.io/bitnamicharts/wordpress --namespace wordpress --create-namespace

echo Username: reza
echo Password: $(kubectl get secret --namespace wordpress wordpress -o jsonpath="{.data.wordpress-password}" | base64 -d)

```
* Note: if you unistall wordpress and other applications that you must remove your application's volumes
## Using nerdctl on your new kubernetes' version

```
wget https://github.com/containerd/nerdctl/releases/download/v1.4.0/nerdctl-1.4.0-linux-amd64.tar.gz

tar xvf nerdctl-1.4.0-linux-amd64.tar.gz

cp nerdctl /bin/

vim ~/.bashrc
  alias docker="nerdctl --namespace k8s.io
source ~/.bashrc
```


## Kubernetes Ingress with TLS/SSL

```
https://artifacthub.io/packages/search?org=cert-manager
```

This repo is demoing the configuration for Ingress and HTTPS/TLS/SSL in Kubernetes.

In Kubernetes, we can expose the services publicly by choosing the type LoadBalancer. That will create a public IP address for each service. But, we want to reduce the number of IP adresses to make some saving. And we want to map a URL like mycompany.com/login and mycompany.com/products to the right service object.
Well, this could be done through Kubernetes Ingress resources.

Kubernetes API doesn't provide an implementation for an ingress controller. So, we need to install it ourself.

Many ingress controllers are supported for Kubernetes:

1) Nginx Controller
2) HAProxy Ingress, Contour, Citrix Ingress Controller
3) API Gatways like Traeffic, Kong and Ambassador
4) Service mesh like Istio
5) Cloud managed ingress controllers like Application Gateway Ingress Controller (AGIC), AWS ALB Ingress Controller, Ingress GCE

The first part will start by configuring Ingress:

1) Installing an ingress controller (NGINX) into Kubernetes.
2) Deploying 2 different applications/services.
3) Configuring ingress to route traffic depending on the URL.

The second part will deal with configuring SSL/TLS using Cert Manager.

```bash

# Create a namespace for the apps
kubectl apply -f app-namespace.yaml

kubectl get namespace
# Deploy the 2 sample apps into Kubernetes
kubectl apply -f app1-deploy-svc.yaml
kubectl apply -f app2-deploy-svc.yaml

kubectl get svc --namespace app

# Get the 2 public IP addresses
kubectl get services --namespace app

# Add the Helm chart for Nginx Ingress
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install the Helm (v3) chart for nginx ingress controller
# (If using Bash instead of Powershell, replace ` with \)
helm install app-ingress ingress-nginx/ingress-nginx `
     --namespace ingress `
     --create-namespace `
     --set controller.replicaCount=2 `
     --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux `
     --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux

# Get the Ingress Controller public IP address
kubectl get services --namespace ingress

# Update the service type to ClusterIP instead of LoadBalancer
# in app-deploy.yaml file
# Delete and redeploy the service for the update to take effect
kubectl delete -f app1-deploy-svc.yaml
kubectl delete -f app2-deploy-svc.yaml
kubectl apply -f app1-deploy-svc.yaml
kubectl apply -f app2-deploy-svc.yaml

# Deploy the Ingress resource into Kubernetes
kubectl apply -f app-ingress.yaml

# Cleanup resources
kubectl delete -f app1-deploy-svc.yaml
kubectl delete -f app2-deploy-svc.yaml
kubectl delete -f app-namespace.yaml
helm delete app-ingress --namespace ingress
kubectl delete namespace ingress

```




IMPORTANT NOTE: The Ingress and the Services should be inside the same Namespace.
Otherwise, the Ingress won't find the Service even with its full name:
<service-name>.<namespace>.svc.local

In this second part of the lab, we will enable HTTPS in Kubernetes using Cert Manager and Lets Encrypt.
The Cert Manager is used to automatically generate and configure Let's Encrypt certificates.

```bash

# Create a namespace for Cert Manager
kubectl create namespace cert-manager

# Get the Helm Chart for Cert Manager
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Install Cert Manager using Helm charts
kubectl apply --validate=false -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.2/cert-manager.yaml

# Check the created Pods
kubectl get pods --namespace cert-manager

# Install the Cluster Issuer
kubectl apply --namespace app -f ssl-tls-cluster-issuer.yaml

# Install the Ingress resource configured with TLS/SSL
kubectl apply --namespace app -f ssl-tls-ingress.yaml

# Verify that the certificate was issued
kubectl describe cert app-web-cert --namespace app

# Check the services
kubectl get services -n app

# Now test the app with HTTPS: https://frontend.<ip-address>.nip.io

# Cleanup resources
helm delete cert-manager --namespace cert-manager
kubectl delete namespace cert-manager
kubectl delete --namespace app -f ssl-tls-cluster-issuer.yaml
kubectl delete --namespace app -f ssl-tls-ingress.yaml

```










# Kubeconf2022
# Kubernetes Networking 101

Welcome to the Kubernetes Networking 101 lab!!

This lab will walk you through five hands on exploratory steps, each step will give you a look at a different aspect of
Kubernetes networking. The steps are designed to take about 10-15 minutes but make a good jumping off point for hours of
further exploration.

The lab systems provided for people joining in-person are 2CPU/4GB/30GB Ubuntu 20.04 cloud instances. If you are virtual
or running the labs after the tutorial session, the lab should work fine on any base Ubuntu 20.04 box. If you would like
to run a local Ubuntu 20.04 VM on your laptop to complete the lab, you can find instructions for doing so here:
https://github.com/RX-M/classfiles/blob/master/lab-setup.md

Let the networking begin!!!

> N.B. The lab steps below show you commands to run and sample output from a demo system. Read the lab steps carefully
> as you will need to change many commands to use your own IP addresses, pod names, etc., all of which will be different
> from those shown in the lab examples.


## 1. Pod Networking

To begin our Kubernetes networking journey we'll need to setup a Kubernetes cluster to work with. We can quickly stand
up a Kubernetes cluster on a plain vanilla Ubuntu server using the rx-m `k8s-no-cni.sh` shell script.

Let's do it!


### SSH to your lab system

When you arrived you received a "login creds" sheet for your private lab machine with the following info:

- Lab machine IP
- Lab key URL

To ssh to your machine you will need the IP, key and a username, which is "ubuntu".

Download the key file and make it private:

```
$ wget <YOUR KEY URL HERE>  net.pem  # or use a browser

$ chmod 400 net.pem
```

Now log in to your assigned cloud instance with ssh:

> N.B. ssh instructions for mac/windows/linux are here if you need them:
>     https://github.com/RX-M/classfiles/blob/master/ssh-setup.md

```
$ ssh -i net.pem ubuntu@<YOUR LAB MACHINE IP HERE>

The authenticity of host 'x.x.x.x (x.x.x.x)' can't be established.
ECDSA key fingerprint is SHA256:avCAN9BTeFbPGaZl2Ao+j7NBE89oGNaSYU1fL5FBHbY.

Are you sure you want to continue connecting (yes/no)? yes

Warning: Permanently added 'x.x.x.x' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.13.0-1022-aws x86_64)

...

Last login: Tue May 17 09:46:05 2022 from 172.58.27.10

ubuntu@ip-172-31-24-84:~$
```

You're in!


### Install Kubernetes

You can poke around if you like (who, id, free, ps, whathaveyou) but we are on the clock, so the next step is
to stand up a Kubernetes cluster. Run the RX-M K8s install script as follows:

> N.B. This will take a minute or two.

```
ubuntu@ip-172-31-24-84:~$ curl https://raw.githubusercontent.com/RX-M/classfiles/master/k8s-no-cni.sh | sh


  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  3446  100  3446    0     0  19691      0 --:--:-- --:--:-- --:--:-- 19691
# Executing docker install script, commit: 614d05e0e669a0577500d055677bb6f71e822356


...  <SOME TIME PASSES HERE> ...


You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 172.31.24.84:6443 --token e29j76.vgcjt3mkfpe6s50h \
        --discovery-token-ca-cert-hash sha256:4b71b7abad35eedf9846be61f513d329a1783cd840f4ebddaf536b411b3ce91e
node/ip-172-31-24-84 untainted
node/ip-172-31-24-84 untainted

ubuntu@ip-172-31-24-84:~$
```

> N.B. Do not run any of the commands suggested in the output above.

Boom. K8s up. So what just happened? Well you can take a look at the script if you like, but this command just installed
the latest version of Kubernetes (1.24 at the time of this writing), using docker with the dockerd-shim as the CRI. This
is a one node cluster, so the node is configured to perform the control plane tasks of a control plane node, but
untainted so that we can also use it as a worker node to run pods.

Take a look at your cluster by getting the nodes:

```
ubuntu@ip-172-31-24-84:~$ kubectl get nodes

NAME              STATUS     ROLES           AGE   VERSION
ip-172-31-24-84   NotReady   control-plane   10s   v1.24.0

ubuntu@ip-172-31-24-84:~$
```

Hey, why is our node "NotReady"?!

During the Kubernetes install you may have seen the following statement 7 or 8 lines from the end of the output:

"You should now deploy a pod network to the cluster."

Kubernetes is not opinionated, it let's you choose your own CNI solution. Until a CNI plugin is installed our cluster
will be inoperable. Time to install Cilium!


### Install Cilium

We're going to use Cilium as our CNI networking solution. Cilium is an incubating CNCF project that implements a wide
range of networking, security and observability features, much of it through the Linux kernel eBPF facility. This makes
Cilium fast and resource efficient.

Cilium offers a command line tool that we can use to install the CNI components. Download, extract and test the Cilium
CLI:


#### Download

```
ubuntu@ip-172-31-24-84:~$ wget https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz

...

cilium-linux-amd64.tar.gz     100%[==============================================>]  21.33M  4.55MB/s    in 4.8s

2022-05-17 11:15:04 (4.47 MB/s) - ‘cilium-linux-amd64.tar.gz’ saved [22369103/22369103]

ubuntu@ip-172-31-24-84:~$ sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin

cilium

ubuntu@ip-172-31-24-84:~$ cilium version

cilium-cli: v0.11.6 compiled with go1.18.2 on linux/amd64
cilium image (default): v1.11.4
cilium image (stable): v1.11.5
cilium image (running): unknown. Unable to obtain cilium version, no cilium pods found in namespace "kube-system"

ubuntu@ip-172-31-24-84:~$
```

Looks good! Now install the cilium CNI:

```
ubuntu@ip-172-31-24-84:~$ cilium install

ℹ️  using Cilium version "v1.11.4"
🔮 Auto-detected cluster name: kubernetes
🔮 Auto-detected IPAM mode: cluster-pool
ℹ️  helm template --namespace kube-system cilium cilium/cilium --version 1.11.4 --set cluster.id=0,cluster.name=kubernetes,encryption.nodeEncryption=false,ipam.mode=cluster-pool,kubeProxyReplacement=disabled,operator.replicas=1,serviceAccounts.cilium.name=cilium,serviceAccounts.operator.name=cilium-operator
ℹ️  Storing helm values file in kube-system/cilium-cli-helm-values Secret
🔑 Created CA in secret cilium-ca
🔑 Generating certificates for Hubble...
🚀 Creating Service accounts...
🚀 Creating Cluster roles...
🚀 Creating ConfigMap for Cilium version 1.11.4...
🚀 Creating Agent DaemonSet...
level=warning msg="spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[1].matchExpressions[0].key: beta.kubernetes.io/os is deprecated since v1.14; use \"kubernetes.io/os\" instead" subsys=klog
🚀 Creating Operator Deployment...
level=warning msg="spec.template.metadata.annotations[scheduler.alpha.kubernetes.io/critical-pod]: non-functional in v1.16+; use the \"priorityClassName\" field instead" subsys=klog
⌛ Waiting for Cilium to be installed and ready...
♻️  Restarting unmanaged pods...
♻️  Restarted unmanaged pod kube-system/coredns-6d4b75cb6d-2qmpv
♻️  Restarted unmanaged pod kube-system/coredns-6d4b75cb6d-xxjv7
✅ Cilium was successfully installed! Run 'cilium status' to view installation health

ubuntu@ip-172-31-24-84:~$
```

Crazy progress characters aside... Looks good! Check the cilium status:

```
ubuntu@ip-172-31-24-84:~$ cilium status

    /¯¯\
 /¯¯\__/¯¯\    Cilium:         OK
 \__/¯¯\__/    Operator:       OK
 /¯¯\__/¯¯\    Hubble:         disabled
 \__/¯¯\__/    ClusterMesh:    disabled
    \__/

Deployment        cilium-operator    Desired: 1, Ready: 1/1, Available: 1/1
DaemonSet         cilium             Desired: 1, Ready: 1/1, Available: 1/1
Containers:       cilium-operator    Running: 1
                  cilium             Running: 1
Cluster Pods:     2/2 managed by Cilium
Image versions    cilium             quay.io/cilium/cilium:v1.11.4@sha256:d9d4c7759175db31aa32eaa68274bb9355d468fbc87e23123c80052e3ed63116: 1
                  cilium-operator    quay.io/cilium/operator-generic:v1.11.4@sha256:bf75ad0dc47691a3a519b8ab148ed3a792ffa2f1e309e6efa955f30a40e95adc: 1

ubuntu@ip-172-31-24-84:~$
```

Sweet. Cilium is happy so we're happy.

The installation we just used runs two different types of pods:

- Cilium Operator
- Cilium [the CNI plugin]

The Cilium "operator" (like a human operator but in code) manages the Cilium CNI components and supports various CLI and
control plane functions. Kubernetes "operators" run in pods typically managed by a Deployment (runs the pod[s] somewhere
in the cluster). The CNI plugin networking agents that configure pod network interfaces, generally run under a
DaemonSet, which ensures that one copy of the CNI plugin pod runs on each node. This way, when an administrator adds a
new node, the CNI agent is automatically started on the new node by the DaemonSet. As "system pods", DaemonSet pods are
also treated specially by the nodes (there are never evicted and so on).

Now let's take a look at the cluster:

```
ubuntu@ip-172-31-24-84:~$ kubectl get nodes

NAME              STATUS   ROLES           AGE   VERSION
ip-172-31-24-84   Ready    control-plane   91m   v1.24.0

ubuntu@ip-172-31-24-84:~$
```

Yes! Our node is now "Ready". We have a working, network enabled, Kubernetes cluster.

Take a look at the pods running in the cluster:

```
ubuntu@ip-172-31-24-84:~$ kubectl get pod -A

NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
kube-system   cilium-5gp4t                              1/1     Running   0          14m
kube-system   cilium-operator-6d86df4fc8-g2z66          1/1     Running   0          14m
kube-system   coredns-6d4b75cb6d-fzsbw                  1/1     Running   0          14m
kube-system   coredns-6d4b75cb6d-wvnvv                  1/1     Running   0          14m
kube-system   etcd-ip-172-31-24-84                      1/1     Running   0          105m
kube-system   kube-apiserver-ip-172-31-24-84            1/1     Running   0          105m
kube-system   kube-controller-manager-ip-172-31-24-84   1/1     Running   0          105m
kube-system   kube-proxy-929xs                          1/1     Running   0          105m
kube-system   kube-scheduler-ip-172-31-24-84            1/1     Running   0          105m

ubuntu@ip-172-31-24-84:~$
```

Note that all of the pods we have so far are part of the Kubernetes system itself, so they run in a namespace called
`kube-system`. We'll run our test pods in the `default` namespace. The `-A` switch shows pods in all namespaces.

These are the pods we have so far (your lab system will have different random suffixes on some of the names):

- cilium-5gp4t - the Cilium CNI plugin on our one and only node
- cilium-operator-6d86df4fc8-g2z66 - the cilium controller providing control plane functions for cilium
- coredns-6d4b75cb6d-fzsbw - the Kubernetes DNS server
- coredns-6d4b75cb6d-wvnvv - a DNS replica to ensure DNS never goes down
- etcd-ip-172-31-24-84 - the Kubernetes database used by the API server to store... well, everything
- kube-apiserver-ip-172-31-24-84 - the Kubernetes control plane API
- kube-controller-manager-ip-172-31-24-84 - manager for the built in controllers (Deployments, DaemonSets, etc.)
- kube-proxy-929xs - the Kubernetes service proxy, more on this guy in a bit
- kube-scheduler-ip-172-31-24-84 - the Pod scheduler, which assigns new Pods to nodes in the cluster

Alright, let's look into all of this stuff!


### Explore the network

Think over the network environment that we have setup. We have three IP spaces:

- The Public internet: the virtual IP you sshed to is Internet routable over the public internet
- The Cloud network: the host IPs of the machines you are using in the cloud provider environment
- The Pod network: the Pod IPs used by the containers in your Kubernetes cluster make up the Pod network

Let's look at each of these networks and think about how they operate.


#### The Internet - public IP

In our case, the public IP address we use to ssh into our computer reaches a cloud gateway which is configured to
translate the public destination address to your Host IP address. This allows us to have a large number of hosts in the
cloud while using a small number of scarce public IPs to map to the few hosts that need to be exposed to the internet.
Once you have sshed into a cloud instance using a public IP, you can use that system as a "jump box" to ssh into the
hosts without public IPs.

In many clouds, you can discover a host's public IP by querying the cloud's metadata servers. Try it:

```
ubuntu@ip-172-31-24-84:~$ curl http://169.254.169.254/latest/meta-data/public-ipv4

18.185.35.194

ubuntu@ip-172-31-24-84:~$
```

In our case this public IP is 1:1 NATed (network address translated) with our Host private IP. In some cases, a host
may receive a different outbound address (SNAT, source network address translation) when connecting out. This allows
even hosts that do not have an inbound public IP to reach out to the internet. You can check your outbound public IP
address like this:

```
ubuntu@ip-172-31-24-84:~$ curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'

18.185.35.194

ubuntu@ip-172-31-24-84:~$
```

In our case (1:1 NAT) they are the same.


#### The Cloud Network - host private IP

The host network, known as a virtual private cloud (VPC) in many cloud provider environments, uses IP addresses in
one of the standard IANA reserved address ranges designed for local communications within a private network:

- 10.0.0.0/8
- 172.16.0.0/12
- 192.168.0.0/16

Identify your `host IP` address:

```
ubuntu@ip-172-31-24-84:~$ ip address | head

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc mq state UP group default qlen 1000
    link/ether 06:26:53:92:f4:7c brd ff:ff:ff:ff:ff:ff
    altname enp0s5
    inet 172.31.24.84/20 brd 172.31.31.255 scope global dynamic ens5

ubuntu@ip-172-31-24-84:~$
```

The ens5 interface is the host's external interface. Our host IP is within the 172.16.0.0/12 address space which is not
routable over the internet. Because all of the lab machines were created within the same VPC they can reach each other
within the cloud. Ask your neighbor for their private (host) IP address and try to ping it:

> N.B. There are many machines in this lab environment and they are spread across multiple VPCs. If you can not ping
> your neighbor's private IP, they are in a different VPC, try their public IP.

```
ubuntu@ip-172-31-24-84:~$ ping -c 3 172.31.24.122

PING 172.31.24.122 (172.31.24.122) 56(84) bytes of data.
64 bytes from 172.31.24.122: icmp_seq=1 ttl=63 time=0.388 ms
64 bytes from 172.31.24.122: icmp_seq=2 ttl=63 time=0.230 ms
64 bytes from 172.31.24.122: icmp_seq=3 ttl=63 time=0.232 ms

--- 172.31.24.122 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2044ms
rtt min/avg/max/mdev = 0.230/0.283/0.388/0.074 ms

ubuntu@ip-172-31-24-84:~$
```


#### The Pod Network - Pod IP

If the Internet is the outermost network in our milieu, the host network is in the middle and the Pod network is the
innermost. Let's create a pod and examine it's network features.

Run an Apache Webserver container (`httpd`) in a pod on your Kubernetes cluster:

```
ubuntu@ip-172-31-24-84:~$ kubectl run web --image=httpd

pod/web created

ubuntu@ip-172-31-24-84:~$
```

Great! It may take the pod a few seconds to start. List your pods until the web pod is running:

```
ubuntu@ip-172-31-24-84:~$ kubectl get pod -o wide

NAME   READY   STATUS              RESTARTS   AGE   IP       NODE              NOMINATED NODE   READINESS GATES
web    0/1     ContainerCreating   0          8s    <none>   ip-172-31-24-84   <none>           <none>

ubuntu@ip-172-31-24-84:~$ kubectl get pod -o wide

NAME   READY   STATUS    RESTARTS   AGE   IP           NODE              NOMINATED NODE   READINESS GATES
web    1/1     Running   0          18s   10.0.0.128   ip-172-31-24-84   <none>           <none>

ubuntu@ip-172-31-24-84:~$
```

Note that our pod has a 10.x.x.x network address. This is the default range of addresses provided to pods by the cilium
CNI plugin. Check the Cilium IP Address Manager (IPAM) configuration:

```
ubuntu@ip-172-31-24-84:~$ cilium config view | grep cluster-pool

cluster-pool-ipv4-cidr                 10.0.0.0/8
cluster-pool-ipv4-mask-size            24
ipam                                   cluster-pool

ubuntu@ip-172-31-24-84:~$
```

As configured, all of our pods will be in a network with a 10.x.x.x prefix (10.0.0.0/8). Each host will have a 24-bit
subnet, making it easy to determine where to route pod traffic amongst the hosts. You can also see the node that
Kubernetes scheduled the pod to, in the example above: `ip-172-31-24-84`. In a typical cluster there would be many nodes
and the Cilium network would allow all of the pods to communicate with each other, regardless of the node they run on.
This is in fact a Kubernetes requirement, all pods must be able to communicate with all other pods, though it is
possible to block undesired pod communications with network policies.

In this default configuration, traffic between pods on the same node is propagated by the Linux kernel and traffic
between pods on different nodes uses the host network. Thus the pod network overlays the host network. This overlay
encapsulates traffic between nodes in UDP tunnels. Cilium supports both VXLAN and Geneve encapsulation schemes.

Check your tunnel type:

```
ubuntu@ip-172-31-24-84:~$ cilium config view | grep tunnel

tunnel                                 vxlan

ubuntu@ip-172-31-24-84:~$
```

We can also disable tunneling in cilium, in which case the pod packets will be routed to the host network. This makes
things a little faster and more efficient but it means that your Pod network must integrate with your host network.
Using a tunneled (aka. overlay) network hides the Pod traffic within host to host communications tunnels making the Pod
network more independent, avoiding entanglement with the configuration of the cloud or bare metal network used by the
hosts.


### Test the Pod Network

To make sure that our Pod network is operating correctly we can run a test client Pod with an interactive shell where
we can perform diagnostics. Start a Pod running the busybox container image:

```
ubuntu@ip-172-31-24-84:~$ kubectl run client -it --image=busybox

If you don't see a command prompt, try pressing enter.
/ #
```

This prompt is the prompt of a new shell running inside the `busybox` container in the `client` pod. Check the ip
address of the new Pod:

```
/ # ip a

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
15: eth0@if16: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 9001 qdisc noqueue qlen 1000
    link/ether 42:a5:ba:f7:76:97 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.231/32 scope global eth0
       valid_lft forever preferred_lft forever
/ #
```

Note that your IP addresses will likely be different than the example here. Try pinging the web pod from the client pod:

> N.B. Be sure to use the IP of your web pod from the earlier get pod command, not the IP in the example below.

```
/ # ping -c 3 10.0.0.128

PING 10.0.0.128 (10.0.0.128): 56 data bytes
64 bytes from 10.0.0.128: seq=0 ttl=63 time=0.502 ms
64 bytes from 10.0.0.128: seq=1 ttl=63 time=0.202 ms
64 bytes from 10.0.0.128: seq=2 ttl=63 time=0.079 ms

--- 10.0.0.128 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.079/0.261/0.502 ms
/ #
```

Try using wget to reach the web server:

```
/ # wget -qO -  10.0.0.128

<html><body><h1>It works!</h1></body></html>

/ #
```

Success! We have a functioning Pod network, congratulations!!


### Clean up

To start our next step with a clean slate let's delete the web and client pods we created above. Exit out of
the client pod:

```
/ # exit
Session ended, resume using 'kubectl attach client -c client -i -t' command when the pod is running

ubuntu@ip-172-31-24-84:~$
```

> N.B. The exit shell command terminates the shell, which Kubernetes will immediately restart.

Now delete the `client` and `web` pods.

```
ubuntu@ip-172-31-24-84:~$ kubectl delete pod client web

pod "client" deleted
pod "web" deleted

ubuntu@ip-172-31-24-84:~$
```


## 2. Services

A typical pattern in microservice systems is that of replicating a stateless service many times to scale out and to
provide resilience. In Kubernetes a Deployment can be used to create a ReplicaSet which will in turn create several
copies of the same pod. Each update to the Deployment creates a new ReplicaSet under the covers allowing the Deployment
to roll forward and back.

Clients of such a replicated pod have challenges. Which pod to connect to? All of them? One of them? Which one?

Kubernetes Services provide an abstraction designed to make it easy for clients to connect to a dynamic, replicated
set of pods. The default Service type provides a virtual IP address, known as a Cluster IP, which clients can connect
to. Behind the scenes the Linux kernel forwards the connection to one of the pods in the set.


### Create some Pods

Let's explore the operation of a basic service. To begin create a set of three pods running the httpd web server:


```
ubuntu@ip-172-31-24-84:~$ kubectl create deployment website --replicas=3 --image=httpd

deployment.apps/website created

ubuntu@ip-172-31-24-84:~$
```

Display the Deployment and the pods it created:

```
ubuntu@ip-172-31-24-84:~$ kubectl get deploy

NAME      READY   UP-TO-DATE   AVAILABLE   AGE
website   3/3     3            3           52s

ubuntu@ip-172-31-24-84:~$ kubectl get pod --show-labels

NAME                      READY   STATUS    RESTARTS   AGE   LABELS
website-5746f499f-f967r   1/1     Running   0          61s   app=website,pod-template-hash=5746f499f
website-5746f499f-qzjjq   1/1     Running   0          61s   app=website,pod-template-hash=5746f499f
website-5746f499f-v9shz   1/1     Running   0          61s   app=website,pod-template-hash=5746f499f

ubuntu@ip-172-31-24-84:~$
```

In perhaps the best case, Deployments are created by a Continuous Deployment (CD) server in a software delivery
pipeline. In the example above we used `kubectl create deployment` to quickly establish a set of three httpd pods. As
you can see, the pods all have the `app=website` label. In Kubernetes, labels are arbitrary key/value pairs associated
with resources. Deployments use labels to identify the pods they own. We can also use labels to tell a Service which
pods to direct traffic to.


### Create a ClusterIP Service

Let's create a simple service to provide a stable interface to our set of pods. Create a Service manifest in yaml and
apply it to your cluster:

```
ubuntu@ip-172-31-24-84:~$ vim service.yaml

ubuntu@ip-172-31-24-84:~$ cat service.yaml

```
```yaml
apiVersion: v1
kind: Service
metadata:
  name: website
spec:
  ports:
  - port: 80
    name: http
  selector:
    app: website
```
```

ubuntu@ip-172-31-24-84:~$ kubectl apply -f service.yaml

service/website created

ubuntu@ip-172-31-24-84:~$
```

List your service:

```
ubuntu@ip-172-31-24-84:~$ kubectl get service

NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP   35h
website      ClusterIP   10.111.148.30   <none>        80/TCP    4m29s

ubuntu@ip-172-31-24-84:~$
```

> N. B. The `kubernetes` service is built in and front ends the cluster's API Server.

Our service, `website`, is of type ClusterIP and has an IP address of 10.111.148.30 in the example. Much like pod IP
addresses, the range for ClusterIPs can be defined at the time the cluster is setup. Unlike Pod IPs, which are typically
assigned by the CNI plugin, Cluster IPs are assigned by the Kubernetes control plane when the service is created. The
Cluster IP range must not overlap with any IP ranges assigned to nodes or pods.

Examine the default ClusterIP CIDR (Classless Inter-Domain Routing) address range:

```
ubuntu@ip-172-31-24-84:~$ kubectl cluster-info dump | grep -m 1 service-cluster-ip-range

                            "--service-cluster-ip-range=10.96.0.0/12",

ubuntu@ip-172-31-24-84:~$
```

Given IPv4 addresses are 4 octets (bytes), 10.96.0.0 in binary is:

- 0000 1010
- 0110 0000
- 0000 0000
- 0000 0000

Given this is a stroke 12 (/12), the range of addresses available include anything with the first 12 bits:

- 0000 1010
- 0110

The address received by our service is selected randomly from this range. In the example above, 10.111.148.30, in binary
is:

- 0000 1010
- 0110 1111
- 1001 0100
- 0001 1110

Note also, that our service specifies a specific port, `80`. Services can list as many ports as a user may require.
Ports can be listed in ranges and ports can be translated by a service as well. When the target port is different from
the connecting port, the `targetPort` field can be specified. Our service simply forwards connections on port 80 to port
80 on one of the pods.

Kubernetes creates `endpoint` resources to represent the IP addresses of Pods that have labels that match the service
selector. Endpoints are a sub-resource of the service that owns them. List the endpoints for the website service:

```
ubuntu@ip-172-31-24-84:~$ kubectl get endpoints website

NAME      ENDPOINTS                                 AGE
website   10.0.0.1:80,10.0.0.177:80,10.0.0.202:80   28m

ubuntu@ip-172-31-24-84:~$
```

The service has identified all three of the pods we created as targets. Test the service function by curling the service
ClusterIP (be sure to use the IP of the service on your machine):

```
ubuntu@ip-172-31-24-84:~$ curl 10.111.148.30

<html><body><h1>It works!</h1></body></html>

ubuntu@ip-172-31-24-84:~$
```

It works! Indeed.

Which pod did you hit? Who cares? They are replicas, it doesn't matter, that's the point!!


### Service Routing

So how does the connection get redirected? Like all good tech questions, the answer is, it depends. The default
Kubernetes implementation is to let the kube-proxy (which usually runs under a DaemonSet on every node in the cluster)
modify the iptables with DNAT rules (Destination Network Address Translation).

Look for your service in the NAT table (again, be sure to use the IP address of **your** ClusterIP):

```
ubuntu@ip-172-31-24-84:~$ sudo iptables -L -vn -t nat | grep '10.111.148.30'

    1    60 KUBE-SVC-RYQJBQ5TR32XWAUN  tcp  --  *      *       0.0.0.0/0            10.111.148.30
    /* default/website:http cluster IP */ tcp dpt:80

ubuntu@ip-172-31-24-84:~$
```

This rule says, jump to chain KUBE-SVC-RYQJBQ5TR32XWAUN when processing tcp connections heading to 10.111.148.30 on
port 80. Display the rule chain **reported by your system**:

```
ubuntu@ip-172-31-24-84:~$ sudo iptables -L -vn -t nat | grep -A4 'Chain KUBE-SVC-RYQJBQ5TR32XWAUN'

Chain KUBE-SVC-RYQJBQ5TR32XWAUN (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 KUBE-SEP-SUZPWGKL5FHWPETE  all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* default/website:http -> 10.0.0.177:80 */ statistic mode random probability 0.33333333349
    1    60 KUBE-SEP-FFKEUBR5SKHPYVCQ  all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* default/website:http -> 10.0.0.1:80 */ statistic mode random probability 0.50000000000
    0     0 KUBE-SEP-OPDTLPWI6RF27F2I  all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* default/website:http -> 10.0.0.202:80 */

ubuntu@ip-172-31-24-84:~$
```

Note that the packets column (the first column titled "pkts") shows one packet processed by the second rule in the
example above. That tells us which pod processed our curl request.

In the example above we see our three target pods selected at random. Rules are evaluated sequentially and the first
matching rule is applied 33% of the time (1/3) via the condition:

`statistic mode random probability 0.33333333349`

If the random generated value is over 0.33... then there are two pods left, so the next rule hits 50% of the time and if
that rule misses then the final pod is always selected. Kube-proxy is constantly updating these rules as pods com and
go.

Examine one of the pod chains (again select a chain name for your machine's output):

```
ubuntu@ip-172-31-24-84:~$ sudo iptables -L -vn -t nat | grep -A3 'Chain KUBE-SEP-FFKEUBR5SKHPYVCQ'

Chain KUBE-SEP-FFKEUBR5SKHPYVCQ (1 references)
 pkts bytes target     prot opt in     out     source               destination
    0     0 KUBE-MARK-MASQ  all  --  *      *       10.0.0.1             0.0.0.0/0            /* default/website:http */
    1    60 DNAT       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            /* default/website:http */ tcp to:10.0.0.1:80

ubuntu@ip-172-31-24-84:~$
```

The first rule marks the packet to avoid processing loops and the second rule DNATs the packet to the target pod ip
address and port, 10.0.0.1:80 in the above case.

Now that we know which pod was hit by our curl command, let's verify it by looking at the pod log. First look up the
name of the pod with the IP from the tables dump and then display the pod logs:

```
ubuntu@ip-172-31-24-84:~$ kubectl get pod -o wide | grep '10.0.0.1 '

website-5746f499f-qzjjq   1/1     Running   0          74m   10.0.0.1     ip-172-31-24-84   <none>           <none>

ubuntu@ip-172-31-24-84:~$ kubectl logs website-5746f499f-qzjjq

AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 10.0.0.1. Set the 'ServerName' directive globally to suppress this message
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 10.0.0.1. Set the 'ServerName' directive globally to suppress this message
[Wed May 18 20:52:18.134335 2022] [mpm_event:notice] [pid 1:tid 140535473859904] AH00489: Apache/2.4.53 (Unix) configured -- resuming normal operations
[Wed May 18 20:52:18.134633 2022] [core:notice] [pid 1:tid 140535473859904] AH00094: Command line: 'httpd -D FOREGROUND'
172.31.24.84 - - [18/May/2022:21:45:00 +0000] "GET / HTTP/1.1" 200 45

ubuntu@ip-172-31-24-84:~$
```

The last entry shows our curl request: "GET / ...".

You can dump the logs of all the pods with the `app=website` label to verify that the other pods have no hits:

```
ubuntu@ip-172-31-24-84:~$ kubectl logs -l app=website

AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 10.0.0.177. Set the 'ServerName' directive globally to suppress this message
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 10.0.0.177. Set the 'ServerName' directive globally to suppress this message
[Wed May 18 20:52:16.872163 2022] [mpm_event:notice] [pid 1:tid 139726115282240] AH00489: Apache/2.4.53 (Unix) configured -- resuming normal operations
[Wed May 18 20:52:16.872488 2022] [core:notice] [pid 1:tid 139726115282240] AH00094: Command line: 'httpd -D FOREGROUND'
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 10.0.0.1. Set the 'ServerName' directive globally to suppress this message
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 10.0.0.1. Set the 'ServerName' directive globally to suppress this message
[Wed May 18 20:52:18.134335 2022] [mpm_event:notice] [pid 1:tid 140535473859904] AH00489: Apache/2.4.53 (Unix) configured -- resuming normal operations
[Wed May 18 20:52:18.134633 2022] [core:notice] [pid 1:tid 140535473859904] AH00094: Command line: 'httpd -D FOREGROUND'
172.31.24.84 - - [18/May/2022:21:45:00 +0000] "GET / HTTP/1.1" 200 45
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 10.0.0.202. Set the 'ServerName' directive globally to suppress this message
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 10.0.0.202. Set the 'ServerName' directive globally to suppress this message
[Wed May 18 20:52:15.789629 2022] [mpm_event:notice] [pid 1:tid 140454359244096] AH00489: Apache/2.4.53 (Unix) configured -- resuming normal operations
[Wed May 18 20:52:15.789803 2022] [core:notice] [pid 1:tid 140454359244096] AH00094: Command line: 'httpd -D FOREGROUND'

ubuntu@ip-172-31-24-84:~$
```

-- or --

```
ubuntu@ip-172-31-24-84:~$ kubectl logs -l app=website | grep GET

172.31.24.84 - - [18/May/2022:21:45:00 +0000] "GET / HTTP/1.1" 200 45

ubuntu@ip-172-31-24-84:~$
```

There are other ways to load balance ClusterIPs, including:

- kube-proxy user mode
- kube-proxy iptables (the default)
- kube-proxy IPVS
- CNI plugins replacing kube-proxy

For example, you may have noticed in our Cilium config, the following line:

`kube-proxy-replacement                 disabled`

When kube-proxy-replacement is enabled, Cilium implements ClusterIPs by updating eBPF map entries on each node.


### Service Resilience

You might think a random load balancer might not produce the best results, however stateless pods in a Kubernetes
environment are fairly dynamic, so this works reasonably well in practice under many circumstances. When a pod is
deleted client connections are closed or broken, causing them to reconnect to one of the remaining pods, redistributing
load regularly. Many things cause pods to be deleted:

- Administrators terminating troublesome pods
- Autoscalers reducing the number of replicas
- Nodes (Kubelets) evicting pods when the node experiences resource contention
- Pods evicted by the scheduler when preemption is configured
- Node crash
- Node brought down for maintenance
- and so on.

If you are doing Cloud Native right, resilience should be the order of the day and deleting Pods (Chaos!) should not be
a problem!!

Let's see how our service responds to changing pod replicas. Scale away one of your pods and then curl your ClusterIP:

```
ubuntu@ip-172-31-24-84:~$ kubectl scale deployment website --replicas=2

deployment.apps/website scaled

ubuntu@ip-172-31-24-84:~$ kubectl get pod

NAME                      READY   STATUS    RESTARTS   AGE
website-5746f499f-qzjjq   1/1     Running   0          85m
website-5746f499f-v9shz   1/1     Running   0          85m

ubuntu@ip-172-31-24-84:~$ curl 10.111.148.30

<html><body><h1>It works!</h1></body></html>

ubuntu@ip-172-31-24-84:~$
```

You can try to curl as many times as you like but the request will not fail because the deleted pod has been removed
from the service routing mesh (you can check if you like). Display the endpoints:

```
ubuntu@ip-172-31-24-84:~$ kubectl get endpoints website

NAME      ENDPOINTS                   AGE
website   10.0.0.1:80,10.0.0.202:80   69m

ubuntu@ip-172-31-24-84:~$
```

Try deleting a pod and recheck your service endpoints (be sure to use the name of **one of your pods**):

```
ubuntu@ip-172-31-24-84:~$ kubectl get pod

NAME                      READY   STATUS    RESTARTS   AGE
website-5746f499f-qzjjq   1/1     Running   0          90m
website-5746f499f-v9shz   1/1     Running   0          90m

ubuntu@ip-172-31-24-84:~$ kubectl delete pod website-5746f499f-qzjjq

pod "website-5746f499f-qzjjq" deleted

ubuntu@ip-172-31-24-84:~$ kubectl get endpoints website

NAME      ENDPOINTS                    AGE
website   10.0.0.12:80,10.0.0.202:80   71m

ubuntu@ip-172-31-24-84:~$
```

What happened?!?

In the example above, the pod with IP `10.0.0.1` was deleted but the Deployment's replica set is scaled to 2, so the
ReplicaSet quickly created a replacement pod (`10.0.0.12` in the example). Note that pods managed by Deployments are
ephemeral and when deleted, they stay deleted. Brand new pods are created to take their place.


### Clean up

Delete the resources you created in this step so that you can start the next step with a clean slate:

```
ubuntu@ip-172-31-24-84:~$ kubectl delete service/website deploy/website

service "website" deleted
deployment.apps "website" deleted

ubuntu@ip-172-31-24-84:~$
```

Next up is DNS!!


## 3. DNS

Most Kubernetes distributions use CoreDNS as the "built-in" DNS service for Kubernetes. The Kubernetes DNS can be used
to automatically resolve a service name to it's ClusterIP. Let's try it with our website service!

Create a website Deployment and service:

```
ubuntu@ip-172-31-24-84:~$ kubectl create deployment website --replicas=3 --image=httpd

deployment.apps/website created

ubuntu@ip-172-31-24-84:~$ kubectl expose deployment website --port=80

service/website exposed

ubuntu@ip-172-31-24-84:~$
```

What the heck does expose do? It is (an oddly named) command that creates a service for an existing controller. The
service created has the same name as the controller (`website` in our case) and uses the same selector.


### Service DNS

Run a client Pod interactively:

```
ubuntu@ip-172-31-24-84:~$ kubectl run -it client --image busybox

If you don't see a command prompt, try pressing enter.
/ #
```

Now try hitting the website service by name:

```
/ # wget -qO - website

<html><body><h1>It works!</h1></body></html>

/ #
```

Wow! Free DNS!! How does this work?

It works like normal DNS pretty much. Step one, when faced with a name and not an IP address, is to look up the name in
DNS. On Linux the /etc/resolv.conf file is where we find the address of the name server to use for name resolution:

```
/ # cat /etc/resolv.conf

nameserver 10.96.0.10
search default.svc.cluster.local svc.cluster.local cluster.local eu-central-1.compute.internal
options ndots:5

/ #
```

As it turns out this file is injected into our container at the request of the Kubelet based on the Kubernetes and Pod
configuration settings. The address `10.96.0.10` is, wait for it ..., the ClusterIP of the CoreDNS Service. We'll verify
this in a few minutes.

Note the second line in the resolv.conf. The name `website` is not a fully qualified DNS name. Remember that Kubernetes
supports namespaces and that we are in the `default` namespace. The fully qualified DNS name of a Kubernetes service is
of the form:  <Service Name>.<Namespace>.svc.<Cluster DNS Suffix>

The default cluster suffix is `cluster.local`, but we could have configured it to be `k8s32.rx-m.com`, or whatever. So
when the resolver looks up `website` it applies the search suffix `default.svc.cluster.local` creating
`website.default.svc.cluster.local`, the fully qualified domain name of our service. The other search suffixes are
applied in order until resolution occurs or the lookup fails.

For example, qualify the service with the namespace:

```
/ # wget -qO - website.default

<html><body><h1>It works!</h1></body></html>

/ #
```

This works because our service is in the default namespace and the search suffix `svc.cluster.local` completes the
lookup. Try looking up the website service in the `kube-system` namespace:

```
/ # wget -qO - website.kube-system

wget: bad address 'website.kube-system'

/ #
```

No such service! Name spacing allows independent teams to use service names without worrying about collisions.

Exit the client shell and list the services in the `kube-system` namespace:

```
ubuntu@ip-172-31-24-84:~$ kubectl get service -n kube-system

NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   37h

ubuntu@ip-172-31-24-84:~$
```

Recognize that IP address? It's our cluster DNS service. Services give dynamic sets of pods a stable "head" identity.


### Headless Services

As we have seen, pods under a Deployment can come and go. Services can create a stable identity at the head of a dynamic
set of pods in the form of a service DNS name and a ClusterIP. What if our individual pods have identity?

Pods that have a unique identity within a set are identified by their state and are therefore not technically
microservices (which are stateless and ephemeral). Examples include Cassandra Pods, Kafka Pods and Nats Pods. Each of
these examples may involve a cluster of pods, each running the same container, however they all have unique data and/or
responsibilities. If you connected to a Kafka broker pod that does not have the topic you would like to read, you will
be redirected to the correct pod. So how does this work with Kubernetes services?

It doesn't. Well, not with the services we have seen so far. However, a headless service, that is a service with no
ClusterIP, can be used for just such a purpose. To demonstrate, create a headless service for your website:

```
ubuntu@ip-172-31-24-84:~$ vim headless.yaml

ubuntu@ip-172-31-24-84:~$ cat headless.yaml

apiVersion: v1
kind: Service
metadata:
  name: headlesswebsite
spec:
  ports:
  - port: 80
    name: http
  selector:
    app: website
  clusterIP: None

ubuntu@ip-172-31-24-84:~$ kubectl apply -f headless.yaml

service/headlesswebsite created

ubuntu@ip-172-31-24-84:~$
```

List your service:

```
ubuntu@ip-172-31-24-84:~$ kubectl get services

NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
headlesswebsite   ClusterIP   None            <none>        80/TCP         41s
kubernetes        ClusterIP   10.96.0.1       <none>        443/TCP        37h
website           NodePort    10.111.148.30   <none>        80:31100/TCP   133m

ubuntu@ip-172-31-24-84:~$
```

Notice that this service has no ClusterIP. Without a `head`, clients can not use this service to randomly load balance
over the backend pods (which would not work if we were trying to reach a specific pod!).

So how does the headless service help us? To demonstrate, let's reattach to our client pod:

```
/ # nslookup headlesswebsite

Server:         10.96.0.10
Address:        10.96.0.10:53

Name:   headlesswebsite.default.svc.cluster.local
Address: 10.0.0.202
Name:   headlesswebsite.default.svc.cluster.local
Address: 10.0.0.12

*** Can't find headlesswebsite.svc.cluster.local: No answer
*** Can't find headlesswebsite.cluster.local: No answer
*** Can't find headlesswebsite.eu-central-1.compute.internal: No answer
*** Can't find headlesswebsite.default.svc.cluster.local: No answer
*** Can't find headlesswebsite.svc.cluster.local: No answer
*** Can't find headlesswebsite.cluster.local: No answer
*** Can't find headlesswebsite.eu-central-1.compute.internal: No answer

/ #
```

Ignoring the failed lookups, you can see that looking up a headless service by name actually returns the IP addresses of
the endpoints.

You can also retrieve the SRV record for the service:

```
/ # nslookup -q=SRV headlesswebsite

Server:         10.96.0.10
Address:        10.96.0.10:53

headlesswebsite.default.svc.cluster.local       service = 0 50 80 10-0-0-12.headlesswebsite.default.svc.cluster.local
headlesswebsite.default.svc.cluster.local       service = 0 50 80 10-0-0-202.headlesswebsite.default.svc.cluster.local

*** Can't find headlesswebsite.svc.cluster.local: No answer
*** Can't find headlesswebsite.cluster.local: No answer
*** Can't find headlesswebsite.eu-central-1.compute.internal: No answer

/ #
```

Headless services are useful in scenarios where you would like to retrieve the list of pod IPs for a given service.
However, if you want to lookup a pod by name, a Deployment is not the right controller. Deployments create pods with
random names and disposable identities. What you need is a headless service and a StatefulSet. A StatefulSet is much
like a Deployment in that it manages a set of pods, however a StatefulSet creates pods with stable identities, that
means stable DNS names. As we saw earlier, deleting a Deployment pod causes a brand new pod with a brand new name to be
created. Deleting a StatefulSet pod causes the exact same pod name to be recreated, and, if specified, attached to the
exact same set of storage volumes.

Exit the Client pod and create a StatefulSet with a headless Service to see how this works:

```
/ # exit
Session ended, resume using 'kubectl attach client -c client -i -t' command when the pod is running

ubuntu@ip-172-31-24-84:~$ vim stateful.yaml

ubuntu@ip-172-31-24-84:~$ cat stateful.yaml

apiVersion: v1
kind: Service
metadata:
  name: webstate
spec:
  ports:
  - port: 80
    name: webstate
  clusterIP: None
  selector:
    app: webstate
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: webstate
spec:
  selector:
    matchLabels:
      app: webstate
  serviceName: webstate
  template:
    metadata:
      labels:
        app: webstate
    spec:
      containers:
      - name: nginx
        image: k8s.gcr.io/nginx-slim:0.8

ubuntu@ip-172-31-24-84:~$ kubectl apply -f stateful.yaml

service/webstate created
statefulset.apps/webstate created

ubuntu@ip-172-31-24-84:~$
```

Take a look at the StatefulSet:

```
ubuntu@ip-172-31-24-84:~$ kubectl get sts,po

NAME                        READY   AGE
statefulset.apps/webstate   1/1     79s

NAME                          READY   STATUS    RESTARTS        AGE
pod/client                    1/1     Running   2 (5m22s ago)   46m
pod/website-5746f499f-nnpxc   1/1     Running   0               79m
pod/website-5746f499f-v9shz   1/1     Running   0               170m
pod/webstate-0                1/1     Running   0               79s

ubuntu@ip-172-31-24-84:~$
```

The stateful pod has a predictable name, the name of the sts followed by a dash and an ordinal representing the order in
which the pod was created. Scale the StatefulSet:

```
ubuntu@ip-172-31-24-84:~$ kubectl scale sts webstate --replicas 3

statefulset.apps/webstate scaled

ubuntu@ip-172-31-24-84:~$ kubectl get pod -l app=webstate

NAME         READY   STATUS    RESTARTS   AGE
webstate-0   1/1     Running   0          3m43s
webstate-1   1/1     Running   0          14s
webstate-2   1/1     Running   0          11s

ubuntu@ip-172-31-24-84:~$
```

Now lets try DNS on our sts. Attach to the client pod and do some lookups:

```
ubuntu@ip-172-31-24-84:~$ kubectl attach -it client

If you don't see a command prompt, try pressing enter.

/ # nslookup webstate.default.svc.cluster.local

Server:         10.96.0.10
Address:        10.96.0.10:53

Name:   webstate.default.svc.cluster.local
Address: 10.0.0.58
Name:   webstate.default.svc.cluster.local
Address: 10.0.0.38
Name:   webstate.default.svc.cluster.local
Address: 10.0.0.52

*** Can't find webstate.default.svc.cluster.local: No answer

/ # nslookup -q=SRV webstate.default.svc.cluster.local

Server:         10.96.0.10
Address:        10.96.0.10:53

webstate.default.svc.cluster.local      service = 0 33 80 webstate-0.webstate.default.svc.cluster.local
webstate.default.svc.cluster.local      service = 0 33 80 webstate-1.webstate.default.svc.cluster.local
webstate.default.svc.cluster.local      service = 0 33 80 webstate-2.webstate.default.svc.cluster.local

/ # wget -qO - webstate-1.webstate.default.svc.cluster.local

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

/ #
```

These pods have DNS identity!


### Cleanup

Delete all of the resources from this step to prepare for the next step:

```
ubuntu@ip-172-31-24-84:~$ kubectl delete pod/client service/headlesswebsite service/web service/webstate

pod "client" deleted
service "headlesswebsite" deleted
service "web" deleted
service "webstate" deleted

ubuntu@ip-172-31-24-84:~$ kubectl delete statefulset.apps/webstate

statefulset.apps "webstate" deleted

ubuntu@ip-172-31-24-84:~$ kubectl delete service/website deployment.apps/website

service "website" deleted
deployment.apps "website" deleted

ubuntu@ip-172-31-24-84:~$
```


## 4. External Access

In this step we'll take a look at ways to reach our cluster based services from outside the cluster.


### NodePort Services

As demonstrated earlier, ClusterIPs are virtual, they only exist as rules in IPTables or within some other forwarding
component of the kernel on nodes in the cluster. So how do we reach a service from outside of the cluster?

Well, there are various ways to get into a cluster but one important way is through a NodePort Service. A NodePort
service uses a specific port on every host computer in the Kubernetes cluster to forward traffic to pods on the pod
network. In this way, if you can reach one of the host machines (nodes) you can reach all of the NodePort services in
the cluster.

Create a service using the NodePort type and a node port of 31100:

```
ubuntu@ip-172-31-24-84:~$ vim service.yaml

ubuntu@ip-172-31-24-84:~$ cat service.yaml

apiVersion: v1
kind: Service
metadata:
  name: website
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 31100
    name: http
  selector:
    app: website

ubuntu@ip-172-31-24-84:~$ kubectl apply -f service.yaml

service/website configured

ubuntu@ip-172-31-24-84:~$
```

Next create some pods for the service to forward to:

```
ubuntu@ip-172-31-24-84:~$ kubectl create deployment website --replicas=3 --image=httpd

deployment.apps/website created

ubuntu@ip-172-31-24-84:~$
```

Now from your laptop (not the cloud instance lab system), try to curl the public IP of your lab machine on port 31100:

```
$ curl -s 18.185.35.194:31100

<html><body><h1>It works!</h1></body></html>

$
```

How does this work?

While this can be implemented in many ways, the default behavior is again iptables based:

```
ubuntu@ip-172-31-24-84:~$ sudo iptables -nvL -t nat | grep 31100

    3   156 KUBE-EXT-RYQJBQ5TR32XWAUN  tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            /* default/website:http */ tcp dpt:31100

ubuntu@ip-172-31-24-84:~$
```

Traffic targeting any IP on port 31100 jumps to chain `KUBE-EXT-RYQJBQ5TR32XWAUN`, which sends us back to the normal
service chain:

```
ubuntu@ip-172-31-24-84:~$ sudo iptables -nvL -t nat | grep -A3 'Chain KUBE-EXT-RYQJBQ5TR32XWAUN'

Chain KUBE-EXT-RYQJBQ5TR32XWAUN (1 references)
 pkts bytes target     prot opt in     out     source               destination
    3   156 KUBE-MARK-MASQ  all  --  *      *       0.0.0.0/0            0.0.0.0/0            /* masquerade traffic for default/website:http external destinations */
    3   156 KUBE-SVC-RYQJBQ5TR32XWAUN  all  --  *      *       0.0.0.0/0            0.0.0.0/0

ubuntu@ip-172-31-24-84:~$
```

NodePort enabled!


### Ingress Controllers and Gateways

The downside of externally exposed services, like NodePorts, is that each set of pods needs its own service. Your
clients (in house developers, third party developers, etc.) probably do not want to keep track of a bunch of service
names, ports and IPs.

Kubernetes introduced an ingress framework to allow a single externally facing gateway (called an Ingress Controller) to
route HTTP/HTTPS traffic to multiple backend services.

Like many other networking functions, upstream Kubernetes does not come with an Ingress Controller, however there are
several good, free, open source options. In this lab we will use Emissary, a CNCF project built on top of the Envoy
proxy, another CNCF project. Emissary implements not only the features required by Kubernetes Ingress but also defines
many custom Resources we can use to access functionality well beyond the generic (but portable) basic Kubernetes
Ingress. Tools like Emissary are often called Gateways because they provide many advanced features used to control
inbound application traffic, beyond the basics defined by Kubernetes Ingress.

> N.B. Progress is underway to create a more powerful "Kubernetes Gateway API" based on Envoy. This effort is being
> supported by the teams behind Envoy, Emissary and Contour (a CNCF Envoy based project which is very similar to
> Emissary).

Installing Emissary is easy. Like many Kubernetes addons, Emissary prefers to run in its own namespace.

Create the Emissary namespace:

```
ubuntu@ip-172-31-24-84:~$ kubectl create namespace emissary

namespace/emissary created

ubuntu@ip-172-31-24-84:~$
```

Great, now we can create the Custom Resource Definitions (CRDs) Emissary depends on:

```
ubuntu@ip-172-31-24-84:~$ kubectl apply -f https://app.getambassador.io/yaml/emissary/2.2.2/emissary-crds.yaml

customresourcedefinition.apiextensions.k8s.io/authservices.getambassador.io created
customresourcedefinition.apiextensions.k8s.io/consulresolvers.getambassador.io created
customresourcedefinition.apiextensions.k8s.io/devportals.getambassador.io created
customresourcedefinition.apiextensions.k8s.io/hosts.getambassador.io created
customresourcedefinition.apiextensions.k8s.io/kubernetesendpointresolvers.getambassador.io created
customresourcedefinition.apiextensions.k8s.io/kubernetesserviceresolvers.getambassador.io created
customresourcedefinition.apiextensions.k8s.io/listeners.getambassador.io created
customresourcedefinition.apiextensions.k8s.io/logservices.getambassador.io created
customresourcedefinition.apiextensions.k8s.io/mappings.getambassador.io created
customresourcedefinition.apiextensions.k8s.io/modules.getambassador.io created
customresourcedefinition.apiextensions.k8s.io/ratelimitservices.getambassador.io created
customresourcedefinition.apiextensions.k8s.io/tcpmappings.getambassador.io created
customresourcedefinition.apiextensions.k8s.io/tlscontexts.getambassador.io created
customresourcedefinition.apiextensions.k8s.io/tracingservices.getambassador.io created
namespace/emissary-system created
serviceaccount/emissary-apiext created
clusterrole.rbac.authorization.k8s.io/emissary-apiext created
clusterrolebinding.rbac.authorization.k8s.io/emissary-apiext created
role.rbac.authorization.k8s.io/emissary-apiext created
rolebinding.rbac.authorization.k8s.io/emissary-apiext created
service/emissary-apiext created
deployment.apps/emissary-apiext created

ubuntu@ip-172-31-24-84:~$
```

The manifest applied above also creates the emissary-system namespace, an extension service and some security
primitives. Note that "Ambassador" was the original name of the "Emissary" project so there are sill many bits of the
tool that still use the old name.

Now we can setup the Emissary controller:

```
ubuntu@ip-172-31-24-84:~$ kubectl apply -f https://app.getambassador.io/yaml/emissary/2.2.2/emissary-emissaryns.yaml

service/emissary-ingress-admin created
service/emissary-ingress created
service/emissary-ingress-agent created
clusterrole.rbac.authorization.k8s.io/emissary-ingress created
serviceaccount/emissary-ingress created
clusterrolebinding.rbac.authorization.k8s.io/emissary-ingress created
clusterrole.rbac.authorization.k8s.io/emissary-ingress-crd created
clusterrole.rbac.authorization.k8s.io/emissary-ingress-watch created
deployment.apps/emissary-ingress created
serviceaccount/emissary-ingress-agent created
clusterrolebinding.rbac.authorization.k8s.io/emissary-ingress-agent created
clusterrole.rbac.authorization.k8s.io/emissary-ingress-agent created
clusterrole.rbac.authorization.k8s.io/emissary-ingress-agent-pods created
clusterrole.rbac.authorization.k8s.io/emissary-ingress-agent-rollouts created
clusterrole.rbac.authorization.k8s.io/emissary-ingress-agent-applications created
clusterrole.rbac.authorization.k8s.io/emissary-ingress-agent-deployments created
clusterrole.rbac.authorization.k8s.io/emissary-ingress-agent-endpoints created
clusterrole.rbac.authorization.k8s.io/emissary-ingress-agent-configmaps created
role.rbac.authorization.k8s.io/emissary-ingress-agent-config created
rolebinding.rbac.authorization.k8s.io/emissary-ingress-agent-config created
deployment.apps/emissary-ingress-agent created

ubuntu@ip-172-31-24-84:~$
```

It can take a bit for all of the container images to download and start so let's wait until the Emissary Deployment is
available:

```
ubuntu@ip-172-31-24-84:~$ kubectl -n emissary wait --for condition=available --timeout=90s deploy emissary-ingress

deployment.apps/emissary-ingress condition met

ubuntu@ip-172-31-24-84:~$
```

Take a look at our new resources:

```
ubuntu@ip-172-31-24-84:~$ kubectl get all -n emissary

NAME                                          READY   STATUS    RESTARTS   AGE
pod/emissary-ingress-845489689d-dz245         1/1     Running   0          23m
pod/emissary-ingress-845489689d-mdppn         1/1     Running   0          23m
pod/emissary-ingress-845489689d-s27gm         1/1     Running   0          23m
pod/emissary-ingress-agent-75ccf64bc8-6l6h6   1/1     Running   0          23m

NAME                             TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                         AGE
service/emissary-ingress         LoadBalancer   10.107.25.56     <pending>     80:31211/TCP,443:31361/TCP      23m
service/emissary-ingress-admin   NodePort       10.105.156.190   <none>        8877:30768/TCP,8005:31779/TCP   23m
service/emissary-ingress-agent   ClusterIP      10.96.6.49       <none>        80/TCP                          23m

NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/emissary-ingress         3/3     3            3           23m
deployment.apps/emissary-ingress-agent   1/1     1            1           23m

NAME                                                DESIRED   CURRENT   READY   AGE
replicaset.apps/emissary-ingress-845489689d         3         3         3       23m
replicaset.apps/emissary-ingress-agent-75ccf64bc8   1         1         1       23m

ubuntu@ip-172-31-24-84:~$
```

The emissary-ingress service is of type LoadBalancer, which includes NodePorts of 31211 mapped to port 80 and 31361
mapped to port 443.

The emissary-ingress Deployment is scaled to 3. Given we are on a single node cluster, lets drop that down to 1:

```
ubuntu@ip-172-31-24-84:~$ kubectl scale deployment.apps/emissary-ingress --replicas=1 -n emissary

deployment.apps/emissary-ingress scaled

ubuntu@ip-172-31-24-84:~$
```

Alright, Emissary is all set. Now let's expose a couple of internal services through our new Gateway.


### Gateway Ingress

When using Emissary's more advanced Gateway functionality, we will need to create two custom resources to send traffic
to our website service.

- Listener - tells Emissary what ports and protocols to listen on
- Mapping - tells Emissary which traffic to forward to which service

List the CRDs created by Emissary:

```
ubuntu@ip-172-31-24-84:~$ kubectl api-resources | grep getambassador

authservices                            getambassador.io/v2                    true         AuthService
consulresolvers                         getambassador.io/v2                    true         ConsulResolver
devportals                              getambassador.io/v2                    true         DevPortal
hosts                                   getambassador.io/v2                    true         Host
kubernetesendpointresolvers             getambassador.io/v2                    true         KubernetesEndpointResolver
kubernetesserviceresolvers              getambassador.io/v2                    true         KubernetesServiceResolver
listeners                               getambassador.io/v3alpha1              true         Listener
logservices                             getambassador.io/v2                    true         LogService
mappings                                getambassador.io/v2                    true         Mapping
modules                                 getambassador.io/v2                    true         Module
ratelimitservices                       getambassador.io/v2                    true         RateLimitService
tcpmappings                             getambassador.io/v2                    true         TCPMapping
tlscontexts                             getambassador.io/v2                    true         TLSContext
tracingservices                         getambassador.io/v2                    true         TracingService

ubuntu@ip-172-31-24-84:~$
```

Let's create an HTTP Listener for use with our website service:

```
ubuntu@ip-172-31-24-84:~$ vim listen.yaml

ubuntu@ip-172-31-24-84:~$ cat listen.yaml

apiVersion: getambassador.io/v3alpha1
kind: Listener
metadata:
  name: emissary-ingress-listener
  namespace: emissary
spec:
  port: 80
  protocol: HTTP
  securityModel: XFP
  hostBinding:
    namespace:
      from: ALL

ubuntu@ip-172-31-24-84:~$ kubectl apply -f listen.yaml

listener.getambassador.io/emissary-ingress-listener created

ubuntu@ip-172-31-24-84:~$
```

Great now let's add a Mapping that forwards traffic using the `/web` route to our `website` service:

```
ubuntu@ip-172-31-24-84:~$ vim map.yaml

ubuntu@ip-172-31-24-84:~$ cat map.yaml

apiVersion: getambassador.io/v3alpha1
kind: Mapping
metadata:
  name: website
spec:
  hostname: "*"
  prefix: /web/
  service: website

ubuntu@ip-172-31-24-84:~$ kubectl apply -f map.yaml

mapping.getambassador.io/website created

ubuntu@ip-172-31-24-84:~$
```

Ok, let's give it a try! From your laptop (outside of the cluster), curl the public IP of your lab system using the
NodePort for the Emissary Gateway and the `web` route:

```
$ curl -s http://18.185.35.194:31211/web/

<html><body><h1>It works!</h1></body></html>

$
```

It works! Try something that won't work:

```
$ curl -i http://18.185.35.194:31211/engine/

HTTP/1.1 404 Not Found
date: Thu, 19 May 2022 21:38:04 GMT
server: envoy
content-length: 0

$
```

As you can see, the Emissary control plane deploys an Envoy proxy to actually manage the data path. You can also see
that the route `engine` is not supported. Let fix that!


### Create Ingress Resources

The Kubernetes Ingress framework allows us to create ingress rules using the ingress resource type. Ingress resources
are not as powerful or feature filled as the Emissary CRDs. They are, however, portable and they do provide basic
functionality. If you can live with the smaller feature set of Ingress resources, perhaps you should, they are more
widely understood and will work with any decent Kubernetes gateway.

Emissary can of course support normal Ingress resources as well as its advanced CRDs. Let's wrap up this step by creating an ingress rule that routes traffic destined for `/engine` to an nginx Deployment.

First create an nginx Deployment and a service for it:

```
ubuntu@ip-172-31-24-84:~$ kubectl create deploy engine --image=nginx

deployment.apps/engine created

ubuntu@ip-172-31-24-84:~$ kubectl expose deploy engine --port=80

service/engine exposed

ubuntu@ip-172-31-24-84:~$
```

Now we can tell Emissary to route to the new service with an Ingress resource. An Ingress resource is a set of one or
more rules for processing inbound traffic received by the Ingress controller.

Create a standard Kubernetes Ingress for the nginx service:

```
ubuntu@ip-172-31-24-84:~$ vim ing.yaml

ubuntu@ip-172-31-24-84:~$ cat ing.yaml

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
spec:
  ingressClassName: ambassador
  rules:
  - http:
      paths:
      - path: /engine
        pathType: Prefix
        backend:
          service:
            name: engine
            port:
              number: 80

ubuntu@ip-172-31-24-84:~$ kubectl apply -f ing.yaml

ingress.networking.k8s.io/web-ingress configured

ubuntu@ip-172-31-24-84:~$
```

Alright now try hitting the `/engine` route again from your laptop:

```
$ curl -i http://18.185.35.194:31211/engine/
HTTP/1.1 200 OK
server: envoy
date: Thu, 19 May 2022 21:44:06 GMT
content-type: text/html
content-length: 615
last-modified: Tue, 25 Jan 2022 15:03:52 GMT
etag: "61f01158-267"
accept-ranges: bytes
x-envoy-upstream-service-time: 0

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

$
```

Boom! We now have two services running in our cluster that are exposed through the Emissary Ingress Gateway!!


## 5. Service Mesh

Now for the finale, service mesh. Let's install Linkerd, a graduated CNCF project. Given the power Linkerd brings to
Kubernetes networking, it is amazingly easy to install and use.


### Install Linkerd

First we'll install the linkerd client:

```
ubuntu@ip-172-31-24-84:~$ curl -sSfL https://run.linkerd.io/install | sh

Downloading linkerd2-cli-stable-2.11.2-linux-amd64...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 44.7M  100 44.7M    0     0  17.0M      0  0:00:02  0:00:02 --:--:-- 19.4M
Download complete!

Validating checksum...
Checksum valid.

Linkerd stable-2.11.2 was successfully installed 🎉


Add the linkerd CLI to your path with:

  export PATH=$PATH:/home/ubuntu/.linkerd2/bin

Now run:

  linkerd check --pre                     # validate that Linkerd can be installed
  linkerd install | kubectl apply -f -    # install the control plane into the 'linkerd' namespace
  linkerd check                           # validate everything worked!
  linkerd dashboard                       # launch the dashboard

Looking for more? Visit https://linkerd.io/2/tasks

ubuntu@ip-172-31-24-84:~$
```

Pretty easy. Now let's add linkerd to the path in the current shell:

```
ubuntu@ip-172-31-24-84:~$ export PATH=$PATH:/home/ubuntu/.linkerd2/bin

ubuntu@ip-172-31-24-84:~$
```

Finally let's install the Linkerd control plane using the linkerd cli:

```
ubuntu@ip-172-31-24-84:~$ linkerd install --set proxyInit.runAsRoot=true | kubectl apply -f -

namespace/linkerd created
clusterrole.rbac.authorization.k8s.io/linkerd-linkerd-identity created
clusterrolebinding.rbac.authorization.k8s.io/linkerd-linkerd-identity created
serviceaccount/linkerd-identity created
clusterrole.rbac.authorization.k8s.io/linkerd-linkerd-destination created
clusterrolebinding.rbac.authorization.k8s.io/linkerd-linkerd-destination created
serviceaccount/linkerd-destination created
secret/linkerd-sp-validator-k8s-tls created
validatingwebhookconfiguration.admissionregistration.k8s.io/linkerd-sp-validator-webhook-config created
secret/linkerd-policy-validator-k8s-tls created
validatingwebhookconfiguration.admissionregistration.k8s.io/linkerd-policy-validator-webhook-config created
clusterrole.rbac.authorization.k8s.io/linkerd-policy created
clusterrolebinding.rbac.authorization.k8s.io/linkerd-destination-policy created
role.rbac.authorization.k8s.io/linkerd-heartbeat created
rolebinding.rbac.authorization.k8s.io/linkerd-heartbeat created
clusterrole.rbac.authorization.k8s.io/linkerd-heartbeat created
clusterrolebinding.rbac.authorization.k8s.io/linkerd-heartbeat created
serviceaccount/linkerd-heartbeat created
customresourcedefinition.apiextensions.k8s.io/servers.policy.linkerd.io created
customresourcedefinition.apiextensions.k8s.io/serverauthorizations.policy.linkerd.io created
customresourcedefinition.apiextensions.k8s.io/serviceprofiles.linkerd.io created
customresourcedefinition.apiextensions.k8s.io/trafficsplits.split.smi-spec.io created
clusterrole.rbac.authorization.k8s.io/linkerd-linkerd-proxy-injector created
clusterrolebinding.rbac.authorization.k8s.io/linkerd-linkerd-proxy-injector created
serviceaccount/linkerd-proxy-injector created
secret/linkerd-proxy-injector-k8s-tls created
mutatingwebhookconfiguration.admissionregistration.k8s.io/linkerd-proxy-injector-webhook-config created
configmap/linkerd-config created
secret/linkerd-identity-issuer created
configmap/linkerd-identity-trust-roots created
service/linkerd-identity created
service/linkerd-identity-headless created
deployment.apps/linkerd-identity created
service/linkerd-dst created
service/linkerd-dst-headless created
service/linkerd-sp-validator created
service/linkerd-policy created
service/linkerd-policy-validator created
deployment.apps/linkerd-destination created
Warning: batch/v1beta1 CronJob is deprecated in v1.21+, unavailable in v1.25+; use batch/v1 CronJob
cronjob.batch/linkerd-heartbeat created
deployment.apps/linkerd-proxy-injector created
service/linkerd-proxy-injector created
secret/linkerd-config-overrides created

ubuntu@ip-172-31-24-84:~$
```

Done! Let's check things to ensure the install went as expected:

```
ubuntu@ip-172-31-24-84:~$ linkerd check

Linkerd core checks
===================

kubernetes-api
--------------
√ can initialize the client
√ can query the Kubernetes API

kubernetes-version
------------------
√ is running the minimum Kubernetes API version
√ is running the minimum kubectl version

linkerd-existence
-----------------
√ 'linkerd-config' config map exists
√ heartbeat ServiceAccount exist
√ control plane replica sets are ready
√ no unschedulable pods
√ control plane pods are ready
‼ cluster networks can be verified
    the following nodes do not expose a podCIDR:
        ip-172-31-24-84
    see https://linkerd.io/2.11/checks/#l5d-cluster-networks-verified for hints

linkerd-config
--------------
√ control plane Namespace exists
√ control plane ClusterRoles exist
√ control plane ClusterRoleBindings exist
√ control plane ServiceAccounts exist
√ control plane CustomResourceDefinitions exist
√ control plane MutatingWebhookConfigurations exist
√ control plane ValidatingWebhookConfigurations exist
√ proxy-init container runs as root user if docker container runtime is used

linkerd-identity
----------------
√ certificate config is valid
√ trust anchors are using supported crypto algorithm
√ trust anchors are within their validity period
√ trust anchors are valid for at least 60 days
√ issuer cert is using supported crypto algorithm
√ issuer cert is within its validity period
√ issuer cert is valid for at least 60 days
√ issuer cert is issued by the trust anchor

linkerd-webhooks-and-apisvc-tls
-------------------------------
√ proxy-injector webhook has valid cert
√ proxy-injector cert is valid for at least 60 days
√ sp-validator webhook has valid cert
√ sp-validator cert is valid for at least 60 days
√ policy-validator webhook has valid cert
√ policy-validator cert is valid for at least 60 days

linkerd-version
---------------
√ can determine the latest version
√ cli is up-to-date

control-plane-version
---------------------
√ can retrieve the control plane version
√ control plane is up-to-date
√ control plane and cli versions match

linkerd-control-plane-proxy
---------------------------
√ control plane proxies are healthy
√ control plane proxies are up-to-date
√ control plane proxies and cli versions match

Status check results are √

ubuntu@ip-172-31-24-84:~$
```

We get a warning because Cilium does not set the node podCIDR, which is optional, but everything else is green! We're
ready to service mesh.

Create a Deployment with a service to add to the mesh:

```
ubuntu@ip-172-31-24-84:~$ kubectl create deploy meshweb --image=httpd --port 80

deployment.apps/meshweb created

ubuntu@ip-172-31-24-84:~$ kubectl expose deploy meshweb

service/meshweb exposed

ubuntu@ip-172-31-24-84:~$ kubectl get all -l app=meshweb

NAME                           READY   STATUS    RESTARTS   AGE
pod/meshweb-76488776bb-krjpn   1/1     Running   0          57s

NAME              TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/meshweb   ClusterIP   10.103.228.8   <none>        80/TCP    28s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/meshweb   1/1     1            1           57s

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/meshweb-76488776bb   1         1         1       57s

ubuntu@ip-172-31-24-84:~$
```

Now inject the linkerd sidecar into the Deployment pods to place it under linkerd control:

```
ubuntu@ip-172-31-24-84:~$ kubectl get deploy meshweb -o yaml | linkerd inject - | kubectl apply -f -

deployment "meshweb" injected

Warning: resource deployments/meshweb is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
deployment.apps/meshweb configured

ubuntu@ip-172-31-24-84:~$ kubectl get all -l app=meshweb

NAME                           READY   STATUS    RESTARTS   AGE
pod/meshweb-7cb97cfdd9-5qfzp   2/2     Running   0          18s

NAME              TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/meshweb   ClusterIP   10.103.228.8   <none>        80/TCP    3m47s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/meshweb   1/1     1            1           4m16s

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/meshweb-76488776bb   0         0         0       4m16s
replicaset.apps/meshweb-7cb97cfdd9   1         1         1       18s

ubuntu@ip-172-31-24-84:~$
```

We can ignore the annotation warning (it is because we are updating a spec created imperatively with `kubectl create`).
Notice that the meshweb pod now has 2 containers! Our linkerd proxy is in place!!

The linkerd inject command simply places the `linkerd.io/inject: enabled` annotation on the pod template. Anytime a pod
has this annotation (which you can add as part of your devops processing), the pod will be injected with Linkerd during
admission control. You can also inject all pods in a given namespace by placing the annotation on the namespace.

Let's create a client to add to the mesh:

```
ubuntu@ip-172-31-24-84:~$ kubectl create deploy meshclient --image=busybox -- sleep 3600

deployment.apps/meshclient created

ubuntu@ip-172-31-24-84:~$ kubectl get pod -l app=meshclient

NAME                          READY   STATUS    RESTARTS   AGE
meshclient-569cc499d9-m82nr   1/1     Running   0          25s

ubuntu@ip-172-31-24-84:~$ kubectl get deploy meshclient -o yaml | linkerd inject - | kubectl apply -f -

deployment "meshclient" injected

Warning: resource deployments/meshclient is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
deployment.apps/meshclient configured

ubuntu@ip-172-31-24-84:~$ kubectl get pods

NAME                              READY   STATUS        RESTARTS   AGE
pod/engine-68696dd698-2bwss       1/1     Running       0          135m
pod/meshclient-569cc499d9-m82nr   1/1     Terminating   0          2m44s
pod/meshclient-6f786d6d78-vpvpc   2/2     Running       0          30s
pod/meshweb-7cb97cfdd9-5qfzp      2/2     Running       0          7m10s
pod/website-5746f499f-sb874       1/1     Running       0          4h11m

ubuntu@ip-172-31-24-84:~$
```

Ok, now we have a service and a client under linkerd control. Let's test the connection:

```
ubuntu@ip-172-31-24-84:~$ kubectl exec -it meshclient-6f786d6d78-vpvpc -c busybox -- sh

/ # wget -qO - 10.103.228.8

<html><body><h1>It works!</h1></body></html>

/ # exit

ubuntu@ip-172-31-24-84:~$
```

Looks like always. However many things have changed! For example, all of the traffic between the two pods is now mTLS.
We can verify this by installing some of the linkerd observability tools. Install the linkerd `viz` components:

```
ubuntu@ip-172-31-24-84:~$ linkerd viz install | kubectl apply -f -

namespace/linkerd-viz created
clusterrole.rbac.authorization.k8s.io/linkerd-linkerd-viz-metrics-api created
clusterrolebinding.rbac.authorization.k8s.io/linkerd-linkerd-viz-metrics-api created
serviceaccount/metrics-api created
serviceaccount/grafana created
clusterrole.rbac.authorization.k8s.io/linkerd-linkerd-viz-prometheus created
clusterrolebinding.rbac.authorization.k8s.io/linkerd-linkerd-viz-prometheus created
serviceaccount/prometheus created
clusterrole.rbac.authorization.k8s.io/linkerd-linkerd-viz-tap created
clusterrole.rbac.authorization.k8s.io/linkerd-linkerd-viz-tap-admin created
clusterrolebinding.rbac.authorization.k8s.io/linkerd-linkerd-viz-tap created
clusterrolebinding.rbac.authorization.k8s.io/linkerd-linkerd-viz-tap-auth-delegator created
serviceaccount/tap created
rolebinding.rbac.authorization.k8s.io/linkerd-linkerd-viz-tap-auth-reader created
secret/tap-k8s-tls created
apiservice.apiregistration.k8s.io/v1alpha1.tap.linkerd.io created
role.rbac.authorization.k8s.io/web created
rolebinding.rbac.authorization.k8s.io/web created
clusterrole.rbac.authorization.k8s.io/linkerd-linkerd-viz-web-check created
clusterrolebinding.rbac.authorization.k8s.io/linkerd-linkerd-viz-web-check created
clusterrolebinding.rbac.authorization.k8s.io/linkerd-linkerd-viz-web-admin created
clusterrole.rbac.authorization.k8s.io/linkerd-linkerd-viz-web-api created
clusterrolebinding.rbac.authorization.k8s.io/linkerd-linkerd-viz-web-api created
serviceaccount/web created
server.policy.linkerd.io/admin created
serverauthorization.policy.linkerd.io/admin created
server.policy.linkerd.io/proxy-admin created
serverauthorization.policy.linkerd.io/proxy-admin created
service/metrics-api created
deployment.apps/metrics-api created
server.policy.linkerd.io/metrics-api created
serverauthorization.policy.linkerd.io/metrics-api created
configmap/grafana-config created
service/grafana created
deployment.apps/grafana created
server.policy.linkerd.io/grafana created
serverauthorization.policy.linkerd.io/grafana created
configmap/prometheus-config created
service/prometheus created
deployment.apps/prometheus created
service/tap created
deployment.apps/tap created
server.policy.linkerd.io/tap-api created
serverauthorization.policy.linkerd.io/tap created
clusterrole.rbac.authorization.k8s.io/linkerd-tap-injector created
clusterrolebinding.rbac.authorization.k8s.io/linkerd-tap-injector created
serviceaccount/tap-injector created
secret/tap-injector-k8s-tls created
mutatingwebhookconfiguration.admissionregistration.k8s.io/linkerd-tap-injector-webhook-config created
service/tap-injector created
deployment.apps/tap-injector created
server.policy.linkerd.io/tap-injector-webhook created
serverauthorization.policy.linkerd.io/tap-injector created
service/web created
deployment.apps/web created
serviceprofile.linkerd.io/metrics-api.linkerd-viz.svc.cluster.local created
serviceprofile.linkerd.io/prometheus.linkerd-viz.svc.cluster.local created
serviceprofile.linkerd.io/grafana.linkerd-viz.svc.cluster.local created

ubuntu@ip-172-31-24-84:~$
```

Linkerd can now tell us which pods are connected to each other and which connections are secured with mTLS. In a new ssh
session, create a persistent connection between the client and the web server with netcat:

```
ubuntu@ip-172-31-24-84:~$ kubectl exec pod/meshclient-6f786d6d78-vpvpc -it -c busybox -- sh

/ # nc 10.103.228.8 80

```

Now return to your interactive session and ask linkerd visualization to display the edges between pods:

```
ubuntu@ip-172-31-24-84:~$ linkerd viz edges pod

SRC                           DST                           SRC_NS        DST_NS    SECURED
meshclient-6f786d6d78-vpvpc   meshweb-7cb97cfdd9-5qfzp      default       default   √
prometheus-5db449486f-xt54k   meshclient-6f786d6d78-vpvpc   linkerd-viz   default   √
prometheus-5db449486f-xt54k   meshweb-7cb97cfdd9-5qfzp      linkerd-viz   default   √

ubuntu@ip-172-31-24-84:~$
```

As you can see, the meshclient pod is connected to the meshweb pod and the connection is secured. You can also see the
linkerd Prometheus instance scraping metrics from the proxies in both of our pods.

This will allows us to display the networking stats for the default namespace:

```
ubuntu@ip-172-31-24-84:~$ linkerd viz stat ns/default

NAME      MESHED   SUCCESS      RPS   LATENCY_P50   LATENCY_P95   LATENCY_P99   TCP_CONN
default      2/4   100.00%   0.6rps           1ms           1ms           1ms          2

ubuntu@ip-172-31-24-84:~$
```

Well, that's enough hacking for one day. We hope you learned something new, fun and/or interesting about Kubernetes
networking!!!

<br>

Congratulations you have completed the lab! Amazing work!!

<br>

_Copyright (c) 2022 RX-M LLC, Cloud Native Consulting, all rights reserved_



##  Set up Kubernetes with external Etcd cluster

<img src="image/etcd.png"/>
<img src="image/etcd2.png"/>
<img src="image/etcd3.png"/>
<img src="image/etcd4.png"/>



