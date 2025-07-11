## Installing k9s
```bash
wget https://github.com/derailed/k9s/releases/download/v0.50.7/k9s_Linux_amd64.tar.gz
tar xvf k9s_Linux_amd64.tar.gz
sudo cp k9s /usr/local/bin/
k9s version
echo "export KUBECONFIG=~/.kube/config" >> ~/.bashrc
source ~/.bashrc
k9s
```


## deployment kubenetes fro

## K8

## install kubectl on Linux
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO https://dl.k8s.io/release/v1.24.0/bin/linux/amd64/kubectl
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
# and then append (or prepend) ~/.local/bin to $PATH

kubectl version --client

```
## minikube start

```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start
or
minikube start --force
kubectl proxy --address='0.0.0.0' --disable-filter=true
```



### Hellowworld
```
kubectl get nodes

kubectl run hw --image=karthequian/helloworlk --port=80

kubectl get deployments

kubectl get rs

kubectl get pods

kubectl expose deployment hw --type=NodePort

kubectl get services

```

## import command on k8s server
```
kubectl get pod

kubectl get services
kubectl get deployment
kubectl get replicaset
kubectl logs nginx-depl1.... (pod name)
kubectl logs
```
## deployment nginx with out yam files
```
kubectl create deployment Name --image=image [--dry-run] [options]
kubrctl create deployment name image option1 opntion2 ...
kubectl create deployment nginx-depl --image=nginx

```
## connect to container

```
kubectl exec -it podname -- bin/bash
```
## deleteting deployment and pods
```
kubectl get deployment
kubectl get pod

kubectl delete deployment mongo...
kubectl delete deployment nginx
```
## create pod nad container with yam files
```

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:  #deployment
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:   #pod
      containers:
        - name: nginx
          image: nginx:1.16
          ports:
            - containerPort: 80
```
```
kubectl apply -f nginx-deployment.yaml

you can change file and apply again

kubectl get deployment

kubectl get pod
```

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    app: my-app
spec:  #deployment
  replicas: 2
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:   #pod
      containers:
        - name: my-app    #pod
          image: my-image
          env:
            - name: SOME_ENV
              value: $SOME_ENV
          ports:
            - containerPort: 8080
```
```
kubectl apply -f nginx-service.yaml
```

## get information deployment and pods and services

```
kubectl describe service nginx-service

kubectl get pod -o wide

kubectl get deployment nginx-deployment -o yaml

kubectl get deployment nginx-deployment -o yaml > nginx-deployment-result.yaml
```
## deleting file with yaml file
```
kubectl delete -f nginx-service.yaml

kubectl delete -f nginx-deployment.yaml
```


## create mongo container and mongoexpree for connectiong mongodb
```
Importand type
* deployment
* service
* configMap
* secret


kubectl get all

```
## make secret for username and password on MongoDB
* create secret keypair
echo -n 'username' | base64
echo -n 'password' | base64
```
vim mongo-secret.yaml


apiVersion: v1
kind: Secret
metadata:
  name: mongodb-secret
type: Opaque  #secret type

data:
  mongo-root-username: dXNlcm5hbWU=
  mongo-root-password: cGFzc3dvcmQ=

```
```
kubectl apply -f mongo-secret.yml
kubectl get secret

```
```
vim mongo.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongodb-deployment
  labels:
    app: mongodb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
       - name: mongodb
         image: mongo
         ports:
         - containerPort: 27017
         env:
         - name: MONGO_INITDB_ROOT_USERNAME
           valueFrom:
             secretKeyRef:
               name: mongodb-secret
               key: mongo-root-username
         - name: MONGO_INITDB_ROOT_PASSWORD
           valueFrom:
             secretKeyRef:
               name: mongodb-secret
               key: mongo-root-password
---

apiVersion: v1
kind: Service
metadata:
  name: mongodb-service  #service name
spec:
  selector:
    app: mongodb ## conected to the pod
  ports:
  - protocol: TCP   # expose service port
    port: 27017
    targetPort: 27017   # ccontainer or pod port

```
```
kubectl apply -f mongo.yml
kubectl describe service mongodb-service
kubectl get all |grep mongodb
```

```
vim mongo-express.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongo-express
  labels:
    app: mongo-express
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mongo-express
  template:
    metadata:
      labels:
        app: mongo-express
    spec:
      containers:
      - name: mongo-express
        image: mongo-express
        # resources:
        #   limits:
        #     memory: "128Mi"
        #     cpu: "500m"
        ports:
        - containerPort: 8081
        env:
        - name: ME_CONFIG_MONGODB_ADMINUSERNAME
          valueFrom:
             secretKeyRef:
               name: mongodb-secret
               key: mongo-root-username
        - name: ME_CONFIG_MONGODB_ADMINPASSWORD
          valueFrom:
             secretKeyRef:
               name: mongodb-secret
               key: mongo-root-password
        - name: ME_CONFIG_MONGODB_SERVER
          valueFrom:
             configMapKeyRef:
               name: mongodb-configmap
               key: database_url

---
## when you run this service you can access mongodb on browser
apiVersion: v1
kind: Service
metadata:
  name: mongo-express-service
spec:
  selector:
    app: mongo-express
  type: LoadBalancer
  ports:
  - protocol: TCP
    port: 8081
    targetPort: 8081
    nodePort:  50000  #50000-32767
=======
# Kubernetes Training: How to Deploy a Cluster from Scratch

### Install K8s Binaries
The next steps will prepare the VM for kube setup.

* Install Docker:

```
```
apt install docker.io -y
or
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```

#### Download and extract the K8s binaries:
```
wget https://storage.googleapis.com/kubernetes-release/release/v1.9.11/kubernetes-server-linux-amd64.tar.gz
tar -xzf kubernetes-server-linux-amd64.tar.gz
```

### Install the K8s binaries:
```

cd kubernetes/server/bin/
mv kubectl kubelet kube-apiserver kube-controller-manager kube-scheduler kube-proxy /usr/bin/
cd
```

### Test that kubectl can now be called:
```
kubectl
```

### Remove unused resources:
```
rm -rf kubernetes kubernetes-server-linux-amd64.tar.gz
```

### Creating the Kube
#### Set up kubelet
```
* The next steps will get kubelet working and show it in action.

Create a directory for kubelet manifests:

```
```
mkdir -p /etc/kubernetes/manifests
```

### Start kubelet in the background:

```
kubelet --pod-manifest-path /etc/kubernetes/manifests &> /etc/kubernetes/kubelet.log &
```
```
### Check its status and initial logs:

```
ps -au | grep kubelet
head /etc/kubernetes/kubelet.log


### Create a Pod using the kubelet's manifest directory:
```
cat <<EOF > /etc/kubernetes/manifests/kubelet-test.yaml
```
```
apiVersion: v1
kind: Pod
metadata:
  name: kubelet-test
spec:
  containers:
  - name: alpine
    image: alpine
    command: ["/bin/sh", "-c"]
    args: ["while true; do echo SuPeRgIaNt; sleep 15; done"]
```
```
EOF
```
### Verify that kubelet has started the Pod (this may take up to a minute):

```
docker ps
```
### Check the container's logs:
```
docker logs {CONTAINER ID}
```

## Set up etcd

* The next steps will get the kube's database/state store working and show it in action.

### Download and extract etcd and etcdctl:


```
wget https://github.com/etcd-io/etcd/releases/download/v3.2.26/etcd-v3.2.26-linux-amd64.tar.gz
tar -xzf etcd-v3.2.26-linux-amd64.tar.gz
```

### Install the etcd and etcdctl binaries:
```
mv etcd-v3.2.26-linux-amd64/etcd /usr/bin/etcd
mv etcd-v3.2.26-linux-amd64/etcdctl /usr/bin/etcdctl
```
```

### Remove leftover resources:


```
rm -rf etcd-v3.2.26-linux-amd64 etcd-v3.2.26-linux-amd64.tar.gz
```
```
### Start etcd:
```
etcd --listen-client-urls http://0.0.0.0:2379 --advertise-client-urls http://localhost:2379 &> /etc/kubernetes/etcd.log &

```
### See if the database is healthy with etcdctl:
```
etcdctl cluster-health
```
### Try to get any resources from the kube:
```
kubectl get all --all-namespaces
```


## Set up kube-apiserver

* The next steps will get the kube's API working and show it in action.

### Start kube-apiserver:


```
kube-apiserver --etcd-servers=http://localhost:2379 --service-cluster-ip-range=10.0.0.0/16 --bind-address=0.0.0.0 --insecure-bind-address=0.0.0.0 &> /etc/kubernetes/apiserver.log &
```
### Check its status and initial logs:

```
ps -au | grep apiserver
head /etc/kubernetes/apiserver.log
```

### Hit an API endpoint to see kube-apiserver respond:
```
curl http://localhost:8080/api/v1/nodes
```


## Set up a kubeconfig File for kubectl

* The next steps will allow kubectl to be properly configured.

### Check to see that kubectl sees the API server:
```
kubectl cluster-info
```

### Add the API server address to a kubeconfig file:
```
kubectl config set-cluster kube-from-scratch --server=http://localhost:8080
kubectl config view
```

### Create a context for kubectl which will point to that apiserver:
```
kubectl config set-context kube-from-scratch --cluster=kube-from-scratch
kubectl config view
```

### Use the context created earlier for kubectl:
```
kubectl config use-context kube-from-scratch
kubectl config view
```
### check that resources can now be seen on the cluster:
```
kubectl get all --all-namespaces
kubectl get no
```

## Set up the New Config for kubelet

* The next steps will take the configuration created and use it to configure kubelet.

### Restart kubelet with a new flag pointing it to the apiserver (this step may fail once or twice, try again):

```
pkill -f kubelet
kubelet --register-node --kubeconfig=".kube/config" &> /etc/kubernetes/kubelet.log &
```
### Check its status and initial logs:

```
ps -au | grep kubelet
head /etc/kubernetes/kubelet.log
```

### Check to see that kubelet has registered as a node:
```
kubectl get no
```
### Check to see the old Pod is not coming up:

```
docker ps
```

### Check that the Pod manifest is still present:
```
ls /etc/kubernetes/manifests
```

### Create a new Pod using kubectl, to test control plane components as they are set up:
```
cat <<EOF > ./kube-test.yaml
```
```
apiVersion: v1
kind: Pod
metadata:
  name: kube-test
  labels:
    app: kube-test
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - name:  http
      containerPort: 80
      protocol: TCP
```
```
EOF
```

```
kubectl create -f kube-test.yaml
```
### Check the Pod's status:

```
kubectl get po
```

## Set up kube-scheduler

* The next steps will allow Pods to schedule on the kube.

Start the scheduler:
```
kube-scheduler --master=http://localhost:8080/ &> /etc/kubernetes/scheduler.log &
```
### Check its status and initial logs:
```
ps -au | grep scheduler
head /etc/kubernetes/scheduler.log
```

### Check to see if the Pod was scheduled:

```
kubectl get po
```
### Delete the Pod:


```
kubectl delete po --all
```

### Set up kube-controller-manager

* The next steps will set up a controller-manager for state-enforcment of various things in the kube.

### Create a Deployment:

```
cat <<EOF > ./replica-test.yaml
```

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: replica-test
spec:
  replicas: 3
  selector:
    matchLabels:
      app: replica-test
  template:
    metadata:
      name: replica-test
      labels:
        app: replica-test
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - name:  http
          containerPort: 80
          protocol: TCP


```

```

kubectl apply -f mongo-configmap.yaml

kubectl apply -f mongo-express.yaml
```


<img src="images/k1.png" width="500" height="200" />
<img src="images/kk2.png" width="500" height="200" />
<img src="images/mongo-express.png" width="500" height="200" />
<img src="images/mongoexpresstomongo.png" width="500" height="200" />
<img src="images/mongosexpresstomongodb.png" width="500" height="200" />



## namespace

```
kubectl get namespaces
```
### create namespace
```
kubectl create namespace my-namespace
```

### ## create a namespace with a configuration file

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: mongodb-configmap
  namespace: my-namespace
data:
  database_url: mongodb-service
```

## install kubectx
```
https://github.com/ahmetb/kubectx#installation

sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
```

## show namespace default on your server
```
kubens
```

## How to change active namespace on your server


```
kubens my-namespace
```


<img src="images/namespace.png" width="500" height="200" />
<img src="images/namespace2.png" width="500" height="200" />
<img src="images/namespace3.png" width="500" height="200" />
<img src="images/namespace4.png" width="500" height="200" />
<img src="images/namespace7.png" width="500" height="200" />
<img src="images/namespace9.png" width="500" height="200" />
<img src="images/namespace10.png" width="500" height="200" />
<img src="images/namespace13.png" width="500" height="200" />
<img src="images/namespace14.png" width="500" height="200" />
<img src="images/namespace15.png" width="500" height="200" />
<img src="images/namespace16.png" width="500" height="200" />
<img src="images/namespace17.png" width="500" height="200" />
<img src="images/namespace18.png" width="500" height="200" />



## kubernetes ingress explained

```
minikube addons enable ingress

kubectl get ns

minikube addons enable dashboard


kubectl get all -n kubernetes-dashboard

kubectl get ingress -n kubernetes-dashboard

kubectl describe ingress dashboard-ingress -n kubernetes-dashboard

```
<img src="images/ingrees.png" width="500" height="200" />
<img src="images/ingress`.png" width="500" height="200" />
<img src="images/ingrees1.png" width="500" height="200" />
<img src="images/ingrees2.png" width="500" height="200" />
<img src="images/ingrees3.png" width="500" height="200" />
<img src="images/ingrees4.png" width="500" height="200" />
<img src="images/igress4.png" width="500" height="200" />
<img src="images/ingress4.png" width="500" height="200" />
<img src="images/ingress5.png" width="500" height="200" />
<img src="images/ingress6.png" width="500" height="200" />
<img src="images/ingress7.png" width="500" height="200" />
<img src="images/ingress8.png" width="500" height="200" />
<img src="images/ingress9.png" width="500" height="200" />
<img src="images/ingress10.png" width="500" height="200" />
<img src="images/ingress11.png" width="500" height="200" />
<img src="images/ingress12.png" width="500" height="200" />

## ssl

<img src="images/ssl.png" width="500" height="200" />
<img src="images/ssl1.png" width="500" height="200" />
<img src="images/ssl4.png" width="500" height="200" />
<img src="images/ssl5.png" width="500" height="200" />
<img src="images/ssl6.png" width="500" height="200" />


```
kubectl create -f replica-test.yaml
```

### Check the Deployment's status:
```
kubectl get deploy
```
### Check that no Pods are Pending for this Deployment:

```
kubectl get po
```
## Start the controller-manager:

```

kube-controller-manager --master=http://localhost:8080 &> /etc/kubernetes/controller-manager.log &
```

### Check its status and initial logs:

```
ps -au | grep controller
head /etc/kubernetes/controller-manager.log
```

### Check the status of the Deployment:

```
kubectl get deploy

```

### Resume and check the rollout of the Deployment, if the number of AVAILABLE Pods still does not change:
```
kubectl rollout resume deploy/replica-test
kubectl rollout status deploy/replica-test
```

### Check the new Pods:
```
kubectl get po
```

## Set up kube-proxy
* The next steps will allow the Deployment to communicate outside of the Docker network in a K8s-compliant manner.

### Create a Service for the replica-test Deployment:
```
cat <<EOF > ./service-test.yaml
```
```
apiVersion: v1
kind: Service
metadata:
  name: replica-test
spec:
  type: ClusterIP
  ports:
  - name: http
    port: 80
  selector:
    app: replica-test
```
```
EOF
```
```
kubectl create -f service-test.yaml
```
### Curl the service to see if any Pod is contacted:
```
kubectl get svc
curl {CLUSTER IP}:80
```
### Start kube-proxy:
```
kube-proxy --master=http://localhost:8080/ &> /etc/kubernetes/proxy.log &
```
### Check its status and initial logs:
```
ps -au | grep proxy
head /etc/kubernetes/proxy.log
```
### Curl the Service again to see if any Pod is contacted:
```
kubectl get svc
curl {CLUSTER IP}:80
```

<img src="images/k1.png" width="500" height="200" />
<img src="images/k2.png" width="500" height="200" />
<img src="images/k3.png" width="500" height="200" />
<img src="images/k4.png" width="500" height="200" />
<img src="images/k5.png" width="500" height="200" />
<img src="images/k6.png" width="500" height="200" />
<img src="images/k8.png" width="500" height="200" />
<img src="images/k9.png" width="500" height="200" />
<img src="images/k10.png" width="500" height="200" />
<img src="images/k11.png" width="500" height="200" />
<img src="images/k12.png" width="500" height="200" />
<img src="images/k13.png" width="500" height="200" />
<img src="images/k14.png" width="500" height="200" />
<img src="images/k15.png" width="500" height="200" />
<img src="images/k16.png" width="500" height="200" />
<img src="images/k17.png" width="500" height="200" />
<img src="images/k18.png" width="500" height="200" />
<img src="images/k19.png" width="500" height="200" />
<img src="images/k20.png" width="500" height="200" />




