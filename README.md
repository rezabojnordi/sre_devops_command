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

#### create service file and deployment in the one command
```
kubectl expose deployment hello-world --port=80 --target=8080 --dry-run=client | more


#### Write the Service yaml manifest to file

kubectl expose deployment hello-world --port=80 --target-port=8080 --dry0run=client -o yaml > service.yaml

more service.yaml
```
```yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: hello-world
  name: hello-world
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 8080
  selector:
    app: hello-world
status:
  loadBalancer: {}
```

```bash
kubectl apply -f service.yaml

```

** Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: hello-world
  name: hello-world
spec:
  replicas: 20
  selector:
    matchLabels:
      app: hello-world   #Match
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: hello-world #Match
    spec:
      containers:
      - image: gcr.io/google-samples/hello-app:1.0
        name: hello-app
        resources: {}
status: {}


```

```bash
kubectl apply -f deployment.yaml
```

```bash
kubectl get service
NAME          TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
hello-world   ClusterIP   10.97.90.181   <none>        80/TCP    20m
kubernetes    ClusterIP   10.96.0.1      <none>        443/TCP   4d22h
root@master1:~# curl 10.97.90.181
Hello, world!
Version: 1.0.0
Hostname: hello-world-7768b7869f-622dp

```



#### The deployment is scaled to  30 and we have 30 pods

```bash
kubectl get deployment hello-world
```
#### You can also scale a deployment using scale

```bash
kubectl scale deployment hello-world --replicas=40
or
kubectl scale deployment hello-world --replicas 40

```

#### Clean up our deployment
```bash
kubectl delete deployment hello-world
kubectl delete service hello-world
kubectl get all


```

## Managing Kubernetes Controllers and Deployments

* Maintainig Application with Deployments
* Deploying and Maintaining Applications with DaemonSets and jobs

```bash
kubectl get --namespace kube-system deployment coredns

kubectl get --namespace kube-system daemonset

kubectl get nodes
```

* Decelrative
```bash

kubectl create deployment hello-wold --iamge=gcr.io/google-samples/hello-app:1.0
kubectl scale deployment hello-world --replicas=5
```


* impractive

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: hello-world
  name: hello-world
spec:
  replicas: 20
  selector:
    matchLabels:
      app: hello-world   #Match
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: hello-world #Match
    spec:
      containers:
      - name: hello-app
        image: gcr.io/google-samples/hello-app:1.0
        ports:
        - containerPort: 8080
```

```bash
kubectl apply -f deployment2.yaml
kubectl get replicasets.apps
kubectl get deployment
kubectl get pods
kubectl delete -f deployment2.yaml
```

```yaml

apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: hello-world
  name: hello-world
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 8080
  selector:
    app: hello-world
status:
  loadBalancer: {}

```

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  labels:
    app: hello-world
  name: hello-world
spec:
  replicas: 20
  selector:
    matchLabels:
      app: hello-world   #Match
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: hello-world #Match
    spec:
      containers:
      - name: hello-app
        image: gcr.io/google-samples/hello-app:1.0
        ports:
        - containerPort: 8080

```


```yaml
apiVersion: apps/v1
kind: ReplicaSet
...
spec:
  replicas: 20
  selector:
    matchExpressions:
      - key: app
        operator: In
        values:
          - hello-world-pod-me
  template:
    metadata:
      labels:
        app: hello-world #Match
    spec:
      containers:
      ...
```


#### Isolating a Pod from a ReplicaSet
##### For more coverage on this see, Managing the kubernetes API
```bash
kubectl get pods --show-labels


kubectl label pod hello-world-f597  app=hello-world-pod-me --overwrite

kubectl get nodes --watch

kubectl get nodes -o wide --watch

kubectl get pods --watch

```


### Updating a Deployment Object

```bash
kubectl set image deployment hello-world hello-world=hello-app:2.0

kubectl set image deployment hello-world hello-world=hello-app:2.0 --record

kubectl edit deployment hello-world

kubectl apply -f hello-world-deployment.yaml --record

if you change the deployment.v2.yaml I mean change the version then aplly again




```


### Checking Deployment status

```bash
kubectl rollout status deployment [name]
kubectl descrive deployement [name]

echo $?


* show history
kubectl rollout history deployment hello-world

* bash to last version I mean v2 to v1
kubectl rollout undo deployment hello-world

* check it roull out work immediatly or not

kubectl rollout status deployment hello-world

* back to specific version
kubectl rollout undo deployment hello-world --to-revision=2

```yaml
kubectl rollout history deployment hello-world --revision=1
deployment.apps/hello-world with revision #1
Pod Template:
  Labels:	app=hello-world
	pod-template-hash=84c65f5f46
  Containers:
   hello-app:
    Image:	gcr.io/google-samples/hello-app:1.0
    Port:	8080/TCP
    Host Port:	0/TCP
    Environment:	<none>
    Mounts:	<none>
  Volumes:	<none>
  Node-Selectors:	<none>
  Tolerations:	<none>
```




### Using Deployment to Change state

* Update strategy
* Pause to make corrctions
* Rollback to an earlier version
* Restart Deployment

Controls Pods rollout
RollingUpdate (default)

A new ReplicaSet starts scalingh up and the old ReplicaSet starts scaling download

Recreate
Terminates all Pods in the current ReplicaSet
set prior to scaling up the new ReplicaSet

Used when applicationm don't suppot running diffrent versions cincurrently

```yaml

apiVersion: apps/v1
kind: Deployment
...
spec:
  replicas: 20
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 20%
      maxSurge: 5
...
template:
...
   spec:
     containers:
...  
      readinessProb:
        httpGet:
          path: /index.html
          port: 8080
        initialDelaySeconds: 10
        periodSeconds: 10

````

* Pausing and Resuming a Deployment.
 * changes to the Deployment while paused are not rolled out
 * Batch changes togetherm then resumes the rollout

starts Up a new ReplicaSet with the new changes


```bash


kubectl rollout paused deployement my-deployment
kubectl rollout resume my-deployment

```


#### rolling Back Deployment

```bash
kubectl rollout history deployment hello-world

kubectl rollout history deployment hello-world --revision=1

kubectl rollout undo deployment hello-world

kubectl rollout undo deployment hello-world --to -revision=1


```

### REstarting a Deployment

* Effectively restarts all the Pods
But no Pod is ever "recreated"
New ReplicaSet with the same Pod spec
Uses Deployment's Update strategy

* RollingUpdate  
* Recreate

```bash
kubectl rollout restart deployement hello-world
```



#### Observe behavior since new image wasn't available, the ReplicaSet doesn't go below maxUnavailable

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: hello-world
  name: hello-world
spec:
  progressDeadlineSeconds: 10
  replicas: 10
  selector:
    matchLabels:
      app: hello-world   #Match
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: hello-world #Match
    spec:
      containers:
      - name: hello-app
        image: gcr.io/google-samples/hello-ap:2.0
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: hello-world
  name: hello-world
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 8080
  selector:
    app: hello-world
status:
  loadBalancer: {}
```

```bash


kubectl apply -f deployment2.yaml

kubectl apply -f deployment.broken.yaml

### why isn't this finisheing...? after progressDeadlineSeconds which we set to 10 seconds (default to 10 minutes)
kubectl rollout status deployment hello-world



```

```json
kubectl get pods
NAME                           READY   STATUS             RESTARTS   AGE
hello-world-66f5964f8c-6v7gb   0/1     ImagePullBackOff   0          99s
hello-world-66f5964f8c-9bxhm   0/1     ImagePullBackOff   0          99s
hello-world-66f5964f8c-blspc   0/1     ErrImagePull       0          99s
hello-world-66f5964f8c-gvx6j   0/1     ImagePullBackOff   0          99s
hello-world-66f5964f8c-mtvbw   0/1     ImagePullBackOff   0          99s
hello-world-84c65f5f46-2bzlw   1/1     Running            0          108s
hello-world-84c65f5f46-5n6j5   1/1     Running            0          109s
hello-world-84c65f5f46-k74x9   1/1     Running            0          108s
hello-world-84c65f5f46-qwbdc   1/1     Running            0          108s
hello-world-84c65f5f46-sd4tz   1/1     Running            0          109s
hello-world-84c65f5f46-trkg9   1/1     Running            0          109s
hello-world-84c65f5f46-v2cfj   1/1     Running            0          109s
hello-world-84c65f5f46-xm896   1/1     Running            0          108s

```


```bash
kubectl describe deployments hello-world

kubectl rollout history deployment hello-world

kubectl describe deployments hello-world  | head
## you can see Annotations:            deployment.kubernetes.io/revision: 2

kubectl rollout history deployment hello-world --revision=2

kubectl rollout history deployment hello-world --revision=1

### Let's under out rollout to revision2, which is our v2 container.

kubectl rollout undo deployment hello-world --to-revision=2

kubectl rollout status deployment hello-world

echo $?

```

####  Demo 3 Controlling the rate and update strategy of a Deployment update.
##### Let's deploy a Deployment with Readliness Probes

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: hello-world
  name: hello-world
spec:
  progressDeadlineSeconds: 10
  replicas: 10
  selector:
    matchLabels:
      app: hello-world   #Match
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: hello-world #Match
    spec:
      containers:
      - name: hello-app
        image: gcr.io/google-samples/hello-app:1.0
        ports:
        - containerPort: 8080
        readinessProbe:
          httpGet:
            path: /index.html
            port: 8080
          initialDelaySeconds: 10
          periodSeconds: 10
---
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: hello-world
  name: hello-world
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 8080
  selector:
    app: hello-world
status:
  loadBalancer: {}
```

```bash
kubectl apply -f deployment.probes-1.yaml --record
kubectl describe deployment hello-world

kubectl rollout status deployment hello-world

kubectl get replicaset

kubectl rollout history  deployment hello-world
  deployment.apps/hello-world 
  REVISION  CHANGE-CAUSE
    1         kubectl apply --filename=deployment.probes-1.yaml --record=true
    2         kubectl apply --filename=deployment.probes-2.yaml --record=true

kubectl rollout history  deployment hello-world --revision=1
kubectl rollout history  deployment hello-world --revision=2

kubectl rollout undo deployment hello-world --to-revision=2
```

#### Let's restart deployment
```bash
kubectl rollout restart deployment hello-world
kubectl describe deployment hello-world
### clean test
kubectl delete deployment hello-world 
kubectl delete service hello-world 
```
#### Scaling Deployment

```bash
kubectl scale deployment hello-world --replicas=10

kubectl apply -f deployment.yaml


```

#### Introducing Daemonset
* Ensures that all or some Nodes run Pod
* Effectively an init daemon inside your cluster
* Example workloads
* Kube-proxy for network services
* Log cpllection
* Metrics services
* Resource monitoring agents
* storage daemons


```yaml

apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: hello-world-app
  name: hello-world-ds
spec:
  selector:
    matchLabels:
      app: hello-world-app   #Match
  template:
    metadata:
      labels:
        app: hello-world-app
    spec:
      nodeSelector:
        node: hello-world-ns
      containers:
      - name: hello-wold
        image: gcr.io/google-samples/hello-app:1.0
```

#### DaemonSet Update strategy

* RollingUpdate
* onDelete

##### Creating a DaemonSet

```bash

kubectl get daemonsets --namespace kube-system kube-proxy

kubectl apply -f DaemonSet.yaml

kubectl get daemonsets

kubectl get daemonsets -o wide

kubectl describe daemonset hello-world  | more
```

```yaml
#### no Selector

apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: hello-world-app
  name: hello-world-ds
spec:
  selector:
    matchLabels:
      app: hello-world-app   #Match
  template:
    metadata:
      labels:
        app: hello-world-app
    spec:
      # nodeSelector:
      #   node: hello-world-ns
      containers:
      - name: hello-wold
        image: gcr.io/google-samples/hello-app:1.0
```

#### Each Pods create with our label
```bash

kubectl get pods --show-labels

```

##### If we change the lable to one of our Pods
```bash
MYPOD=$(kubectl get pods -l app=hello-world-app | grep hello-world | head -n 1 | awk {'print $1'})
echo $MYPOD

kubectl label pods $MYPOD app=not-hello-world --overwrite

kubectl get pods --show-labels
```

#### We need a node that satisfies the Node Selector

```bash
kubectl label node worker1 node=hello-world-ns
```



#### What's going to happen if we remove the lable

```bash
kubectl label node worker1 node-

kubectl describe daemonsets hello-world-ds

kubectl delete daemonsets hello-world-ds

## Examine what our update stategy is ...default to rollingUpdate
kuecbtl get daemonSet hello-world -o yaml | more
```

#### Introducing jobs

* Jobs create one or more Pods
* Runs a program in a container to completion
* Ensure that specified number of Pods complete successfully

Ensuring Jobs Run to completion
* Interrupted Execution
* None-zero Exit code
* Rescheduled
* restartPolicy

* NoteJobs: Lifecycle

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: hello-world
spec:
  template:
    spec:
      containers:
      - name: ubuntu
        image: ubuntu
        command:
         - /bin/bash
         - "-c"
         - "/bin/echo Hello from Pod $(hostname) at $(date)"
      restartPolicy: Never

```

##### Controlling Job Execution
* backoffLimit - number of Job retries
* before it's marked failed
* activeDeadlineSeconds - max execution time for the job
* parallelism - max number of running pods in a Job at a point in time
* completions - number of Pods that need to finish successfully


##### Introducing Cronjobs
* CronJob will run a Job on a given time based schedule
* Conceptually similar to UNIX/LINUX cron Job
* CronJob resource is created when the object is submitted to the Api server

##### Controlling CronJobs Execution
* schedule - a cron formatted schedule
* suspend -suspends the CronJob
* startingDeadlineSeconds the Job hasn't started in this amount of time mark it as failed
* concurrencyPolicy - handles concurrent executions of a job. Allow, Forbid or Replice

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello-world-cron
spec:
  schedule: "*1 * * * *"
  jobTemplate:
     spec:
       template:
          spec:
            containers:
            - name: ubuntu
```

### Jobs
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: hello-world-job
spec:
  template:
    spec:
      containers:
      - name: ubuntu
        image: ubuntu
        command:
         - /bin/bash
         - "-c"
         - "/bin/echo Hello from Pod $(hostname) at $(date)"
      restartPolicy: Never
```

```bash
kubecl apply -f job.yaml
kubectl get job --watch
kubectl get pods
kubectl describe job hello-world-job

### Get the logs from stdout from the job Pod

kubectl get pods -l job-name=hello-world-job
kubectl logs hello-world-job-258rj

kubectl  delete job hello-world-job
kubectl get jobs

```


       


### Job-failure-onfailure.yaml

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: hello-world-job
spec:
  backoffLimit: 2
  template:
    spec:
      containers:
      - name: ubuntu
        image: ubuntu
        command:
         - /bin/bash
         - "-c"
         - "/bin/echo Hello from Pod $(hostname) at $(date)"
      restartPolicy: Never
```

```bash
kubectl get pods --watch
kubectl get jobs

```

#### Demo 3 Defining a Parallel Job
```bash
kubectl apply -f paralleljob.yaml
```

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: hello-world-job
spec:
  completions: 50
  parallelism: 10
  template:
    spec:
      containers:
      - name: ubuntu
        image: ubuntu
        command:
         - /bin/bash
         - "-c"
         - "/bin/echo Hello from Pod $(hostname) at $(date)"
      restartPolicy: Never
```

```bash
kubectl get pods
watch 'kubectl describe job | head -n 11'
kubectl delete -f paralleljob.yaml

```

#### Demo 5 scheduling tasks with CronJobs

```bash
kubectl apply -f cronjob.yaml
```
#### Cronjob samole

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello-world-cron
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: ubuntu
            image: ubuntu
            command:
            - "/bin/bash"
            - "-c"
            - "/bin/echo Hello from Pod $(hostname) at $(date)"
          restartPolicy: Never
```

```bash
kubectl describe cronjobs | more
kubectl get pods --watch
kubectl get cronjob -o yaml
```


#### Statefulsets

* Database workloads
* Caching servers
* Application state for web farms
* Naming Storage Headless Service


#### Dry run
```bash
kubectl apply -f  deployment --dry-run=server
kubectl apply -f  deployment --dry-run=client
kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > deployment.new.yaml
```

##### Working with kubectl diff

```bash
kubectl diff -f newdeployment.yaml
kubectl diff -f newdeployment.yaml | more

```

#### Api Discovery
```bash
#Get information anout our current cluster context
kubectl config get-contexts

### Change our context if needed by soecifying the Name
kubectl config use-context kubernetes-admin@kubernetes

kubectl cluster-info
#Get a list of Api
kubectl api-resources | more

# Using kubectl explain to see the structure of a resource..specifically

kubectl explain pods | more
```

### Api Group
* Pod
* Node
* namespace
* PersistentVolume
* PersistantVolumeClaim

#### Named Api Group
* Apps - Deployment
* Storage.k8s.io - StorageClass
* rbac.authorization.k8s.io - Role

#### Api Version

* Api is versioned
* Provide stability for existing implementions
* Enable forward change

Alpha -  Beta -> Stable

No direct relation to release version

```bash
kubectl api-resources |more

kubectl api-resources --api-group=apps

kubectl explain deployment --api-version=apps/v1 | more

kubectl api-versions | sort | more

```

##### Core API (Legacy)
```h
http://apiserver:port/api/$VERSION/$RESOURCE_TYPE
http://apiserver:port/api/$VERSION/$NAMESPACE/$RESOURCE_TYPE/$RESOURCE_NAME
```

##### API Group
```H
http://apiserver:port/api/$GROUPNAME/$VERSION/namespaces/$NAMESPACE/$RESOURCE_TYPE/$RESOURCE_NAME

```
```bash
Conaction-->Authentication-->Authorization-->Admission Control
```


```bash
# we can use the -v option to increse the verbosity of out request
kubectl get pod hello-world-64cfbbd96c-44ls6 -v 6
#####################
kubectl get pod hello-world-64cfbbd96c-44ls6 -v 7
I1014 13:19:52.627860  797543 loader.go:395] Config loaded from file:  /etc/kubernetes/admin.conf
I1014 13:19:52.632851  797543 round_trippers.go:463] GET https://172.20.45.20:6443/api/v1/namespaces/default/pods/hello-world-64cfbbd96c-44ls6
I1014 13:19:52.632968  797543 round_trippers.go:469] Request Headers:
I1014 13:19:52.633099  797543 round_trippers.go:473]     Accept: application/json;as=Table;v=v1;g=meta.k8s.io,application/json;as=Table;v=v1beta1;g=meta.k8s.io,application/json
I1014 13:19:52.633236  797543 round_trippers.go:473]     User-Agent: kubectl/v1.30.5 (linux/amd64) kubernetes/74e84a9
I1014 13:19:52.641417  797543 round_trippers.go:574] Response Status: 200 OK in 8 milliseconds
NAME                           READY   STATUS    RESTARTS   AGE
hello-world-64cfbbd96c-44ls6   1/1     Running   0          97s
```

##### Start up a kubectl proxy session, This will authenticate use to the API server

```bash

kubectl proxy &

curl http://localhost:8001/api/v1/namespaces/default/pods/hello-world | head -n 20

kubectl get pods --watch -v 6
```


##### Organizing Object in Kubernetes

* namespace
* Labels 
* Annotations

``` yaml
apiVersion: v1
kind: Namespace
metadata:
  name: playgroundinyaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world
  labels:
    app: hello-world
  namespace: playgroundinyaml
spec:
  replicas: 4
  selector:
    matchLables:
      app: hello-world
  template:
    metadata:
      labels:
        app: hello-world-app
    spec:
      # nodeSelector:
      #   node: hello-world-ns
      containers:
      - name: hello-wold
        image: gcr.io/google-samples/hello-app:1.0
  
```

```bash
kubectl get namespces

kubectl api-resources --namespaces=true |head
kubectl api-resource --namespaces=false | head

kubectl describe namespaces

kubectl get pods --all-namespaces

kubectl get all --all-namespaces

kubectl create namespace playgroupd1

kubectl get pods -n playgroupd1

kubectl delete pods -all --namespace playgroupd1

kubetcl exec -it POD1 --container Container1 -- /bin/bash

kubectl logs POD1 --container Container1

kubectl port-forward pod POD1 LOCALPORT:CONTAINERPORT


```

##### Labels

* Used to organize resource - Pods,Nodes and more
* Lables Selector are used to select/query Objects
* Creating resource with Labels

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: v1
    tier: PROD
spec:
  ...

```

```bash
kubectl label pod nginx tier=PROD app=v1
kubectl label pod nginx tier=DEBUG app=v1 --overwrite
kuebctl label pod nignx app-

kubectl get pods --show-labels
kubectl get pods --selector tier=Prod
kubectl get pods -l 'tier in (prod,qa)'
kubectl get pods -l 'tier notin (prod,qa)'
```

* Controller and Services match pods using selector
* Scheduling to specific Nodes
* Special hardware (SSD or GPU)


```yaml
kind: Deployment
...
spec:
 selector:
   matchLabels:
     run: hello-world ## mache
...
  template:
    metadata:
      labels:
        run: hello-world ## mache
    spec:
      contaners:
---

kind: Service
...
spec:
  selector:
    run: hello-world ## mache
  ports:
  - port: 80
    protocol: TCP
    targetPort: 8080
```


### labels

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod-1
  labels:
    tier: prod
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
---
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod-2
  labels:
    app: MyWebApp
    deployment: v1.1
    tier: prod
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
---
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod-3
  labels:
    app: MyWebApp
    deployment: v1.1
    tier: qa
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
---
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod-4
  labels:
    app: MyAdminApp
    deployment: v1
    tier: prod
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80

```

```bash
kubectl apply -f createpodwithlabels.yaml
kubectl get pods --show-labels

### Query labels and selectors

kubectl get pods --selector tier=prod
kubectl get pods --selector tier=qa
kubectl get pods -l tier=prod
kubectl get pods -l tier=prod --show-labels

#Output a particluar label in colume format
kubectl get pods -L tier
kubectl get pods -L tier,app


### Edit an existing label
kubectl label pod nginx-pod-1 tier=non-prod --overwrite
kubectl get pod nginx-pod-1 --show-labels


### ADding label pod nginx-pod-1 another=label
kubectl get pod nginx-pod-1 --show-labels

## Removing an operation on a collection of pods based on a label query
kubectl label pod nginx-pod-1 another-

kubectl get pod nginx-pod-1 --show-labels


### Delete all pods matching our non-prod label

kubectl delete pod -l tier=non-prod

kubectl delete pod -l tier=prod
  pod "nginx-pod-1" deleted
  pod "nginx-pod-2" deleted
  pod "nginx-pod-4" deleted
```



```yaml
### deployment-label.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world
  labels:
    app: hello-world
spec:
  replica:
  selector:
    matchLabels:
      app: hello-world
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-world
        image: gcr.io/google-samples/hello-app:1.0
        ports:
        - containerPort: 8080
```

```bash
kubectl describe service hello-world

kubectl get pods --show-labels

```

##### labels our nodes with something descrive


```bash
kubectl label node worker1 disk=local_ssd

kubectl label node worker2 hardware=local_gpu
```

##### Query our labels to confirm

```bash
kubectl get node -L disk,hardware

kubectl get pods -o wide
```

```yaml
###podstonodes.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod-ssd
spec:
  nodeSelector:
    disk: local_ssd  # Correct label key
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80

---
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod-ssd
spec:
  nodeSelector:
    hardware: local_gpu
  containers:
  - name: nginx
    image: nginx
    ports:
    - containerPort: 80
```

#### Clean up when we're finished, delete our labels and pods

```bash
kubectl label node worker1 disck-
kubectl label node worker2 hardware-
kubectl delete pod nginx-pod
kubectl delete pod nginx-pod-gpu
kubectl delete pod nginx-pod-ssd
```

#### Annotations
* Used to add additional information about your cluster resources
* Mostly used by people or tooling to make decisions
* None-hierarchical, key/value pair

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  annotation: owner: Anthony
spec:
  contaners:
  - name: nginx
    image: nginx
```

```bash

kubectl annotate pod nginx-pod owner=Anthony

kubectl annotate pod nginx-pod owner=NotAnthony --overwrite
```


#### multi-pods 
```bash
###multicontainer-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: multicontainer-pod
spec:
  containers:
  - name: producer
    image: ubuntu
    command: ["/bin/bash"]
    args: ["-c", "while true; do echo $(hostname) $(date) >> /var/log/index.html; sleep 10; done"]
    volumeMounts:
    - name: webcontent
      mountPath: /var/log
  - name: consumer
    image: nginx
    ports:
      - containerPort: 80
    volumeMounts:
    - name: webcontent
      mountPath: /usr/share/nginx/html
  volumes:
  - name: webcontent
    emptyDir: {}
```

```bash
kubectl exec -it multicontainer-pod -- /bin/bash
ls -la /var/log
tail /var/log/index.html

#Let's specify a container name and access the consumer container in our Pod
kubectl port-forward multicontainer-pod 8080:80
curl http://localhost:8080
```

#### Pod with init containers

```bash
apiVersion: v1
kind: Pod
metadata:
  name: init-containers
spec:
  initContainers:
  - name: init-service
    image: ubuntu
    command: ['sh', '-c', "echo waiting for service; sleep 2"]
  - name: init-database
    image: ubuntu
    command: ['sh', '-c', "echo waiting for database; sleep 2"]
  containers:
  - name: app-container
    image: nginx

````

```bash
## Froce Deletion - Immediately deletes records in api and etcd

kubectl delete pod <name> --grace-period-0 --force
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx
  restartPolicy: OnFailure

```


```bash
### we still have our kubectl get events running in the background
kubectl exec -it hello-world-pod -- /usr/bin/killall hello-app
 
```


#### Defining Pod Health

* livenessProbes
* readinessProbes
*  startupProbrs

* Note: Types of Diagnostic checks for probes
   Exec      -->> Process exit code

   tcpSocket  -->> successfully open a port

   httpGet -->> Return Code 200 => and < 400


  ```yaml
  spec:
    containers:
      ...
      livenessProbe:
        tcpSocket:
          port: 8080
        initialDelaySeconds: 15
        periodSeconds: 20

  ```

    ```yaml
  spec:
    containers:
      ...
      readinessProbe:
        tcpSocket:
          port: 8080
        initialDelaySeconds: 5
        periodSeconds: 10

  ```

    ```yaml
  spec:
    containers:
      ...
      startupProbe:
        tcpSocket:
          port: 8080
        initialDelaySeconds: 5
        periodSeconds: 10

  ```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-world
        image: gcr.io/google-samples/hello-app:1.0
        ports:
        - containerPort: 8080
        livenessProbe:
          tcpSocket:
            port: 8081
          initialDelaySeconds: 10
          periodSeconds: 5
        readinessProbe:
          httpGet:
            path: /
            port: 8081
          initialDelaySeconds: 10
          periodSeconds: 5    

```


### Storage on the Kubernetes

#### Storage API objects in Kubernetes
* Volumes
* PersistantVolume
* PersistantVolumeClaim
* StorageClass

##### Volumes (NFS)
* Persistent storage deployed as part of the Pod spec
* implemention details for your storage
* This can be challenging..
  
  * Sharing code
  * same lifecycle as Pod

* We can do betther......



##### Persistent Volumes
* Administrator defined storage in the cluster
* implemention details for your storage
* Lifecycle independent of the Pod


Managed by the kubelete
 * Maps the storage in the Node
 * Exposes PV as a mount insid the container



##### Types of Persistent Volumes
* Networked (NFS,AzureFile)
* Block(Fibre Channel,Iscsi)
* Cloud (awsElasticBlockStore,AzureDisck,GcePersistentDisk)


##### Persistent Volumes Claims
* A request for storage by a User
  * Size
  * Access Mode
  * Storage Class
  * Enable protabillity of your application configurations
The cluster will map a PVC to a PV

Note: Node level access, not Pod access

# ------------------------------------------------------------------------

#### Static Provisiong Workflow

1. Create a PersistentVolume
2. Create a persistentVolumeClaim
3. Define Volume in Pod Spec


### Storage Lifecycle
1. Binding

* PVC created
* Control loop
* Maches PVC->PV
2. Using
* Pod's Lifetime

3. Reclaim
* PVC Delete
* Delete(default)
* Retain


```yaml

apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-nfs-data
spec:
  capacity:
   storgae: 100Gi
  accessModes:
    - ReadWriteMany
  nfs:
    server: 172.16.94.5
    path: "/exporter/volumes/pod"

```

Note:
* accessModes
* resources 
* storageClassName
* Selector

#### Defining a Persistent Volume Claim

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata: 
 name: pvc-nfs-data
spec:
  accessMode:
    - ReadWriteMany
  resources:
    requests:
      storage: 10Gi
      
```


###### Using Persistent Volume in Pods

```yaml
---
spec:
  Volumes:   #Volumes
    - name: webcontent
      persistentVolumeClaim:
        claimName: pvc-nfs-data
  containers:
  - name: nginx
    ....
    volumeMounts: #persistentvolumeClaim
    - name: webcontent
      mountPath: "/sur/share/nginx/html/web-app" ### PersistentVolume
```


#### NFS for Kubernetes

```bash
sudo apt update
sudo  apt full-upgrade
sudo apt install nfs-kernel-server

mkdir /exporter/volumes
mkdir /exporter/volumes/pod

sudo bash -c 'echo "/exporter/volumes *(rw,no_root_squash,no_subtree_check)" > /etc/exporters'

cat /etc/exporters

sudo systemctl restart nfs-kernel-server.service
exit

```

##### On ech Nodes you cluster ..... install the NFS client

```bash

sudo apt install nfs-common -y

ssh worker1

sudo mount -t nfs4 c1-storage:/export/volumes /mnt/
umount /mnt

exit
```




#### nfs.pv.yaml
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-nfs-data
spec:
  accessModes:
    - ReadWriteMany
  capacity:
    storage: 10Gi
  persistentVolumeReclaimPolicy: Retain
  nfs:
    server: 172.20.45.20
    path: "/exporter/volumes/pod"


```

#### Create a PV
```bash
kubectl apply -f nfs.pv.yaml

kubectl get persistentvolume pv-nfs-data

kubectl describe persistentvolume pv-nfs-data 
```

#### Create a PVC on that PV

nfs.pvc.yaml
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-nfs-data
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 10Gi

```


```bash
kubectl apply -f nfs.pvc.yaml

kubectl get persistentvolume

kubectl get PersistentvolumeClaim pvc-nfs-data
kubectl describe PersistentvolumeClaim pvc-nfs-data
```


``` bash
ssh nfs_server
sudo bash -c 'echo "Hello from our NFS mount!!!!" >/exporter/volumes/pod/demo.html'

```
* Note: use this one
```bash
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner     --set nfs.server=172.20.45.50 --set nfs.path=/exporter/volumes
```

```bash
vim nfs.pvc.yaml
```

```bash
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-nfs
spec:
  storageClassName: "nfs-client" # storageclass
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 10Gi


```

```
kubectl apply -f nfs.pvc.yaml

```
* vim nfs.nginx.yaml
```yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-nfs-deployment
spec:
  replicas: 1
  selector:
    matchLabels:  # اصلاح نام اشتباه 'macheLabels'
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
        volumeMounts:
        - name: webcontent
          mountPath: "/usr/share/nginx/html/web-app"
      volumes:
      - name: webcontent
        persistentVolumeClaim:
          claimName: pvc-nfs
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-nfs-service
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    protocol: TCP
    targetPort:
```

```bash
### Lets create pods ( in Deployment and add a service) with a PVC on pvc-nfs-data

kubectl apply -f nfs.nginx.yaml

kubectl get service nginx-nfs-servic

SERVICEIP=$(kubectl get service | grep nginx-nfs-service | awk '{ print $3 }')

curl http://$SERVICEIP/web-app/demo.html

kubectl scale deployment nginx-nfs-deployment --replicas 4

kubectl describe persistentvolumeclaims

kubectl get persistentvolume

kubectl get persistentvolumeclaims

kubectl delete deployments.apps nginx-nfs-deployment

kubectl get persistentvolumeclaims
```

#### My status is now Released...which means no one can claim this pv
```
kubectl get persistentvolume

NAME          CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM                  STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pv-nfs-data   10Gi       RWX            Retain           Released   default/pvc-nfs-data                  <unset>                          5d21h
```


##### Dynamic Provisiong Workflow

* Create a StorageClass
* Create a PersistentVolumeClaim
* Define Volume in Pod Spec
* Create a PersistentVolume



#### Defining a StorageClass(optional)(Azure)

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: managed-premium
parameters:
  kind: Managed
  storageaccounttype: Premium_LRS
provisioner: Kubernetes.io/azure-disk
```

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-azure-managed
spec:
  accessModes:
  - ReadWriteOne
  storageClassName: managed-premium
  resources:
    requests:
      storage: 10Gi


```

### Configure Data

* Note: Using Environment

Why Do we need configurations Data
* Abstraction
* Container Image are Immutable
* Service Discovery
* Sensitive information


### DEfining Enviroment Variables

```
spec:
  containers:
  - name: hello-world
    image: gcr.io/google-samples/hello-app:1.0
    env:
    - name: DATABASE_SERVERNAME
      value:"sql.example.local"
    - name: BACKEND_SERVERNAME
      value: "be.example.local"
‍‍‍
```
* vim deploy-alpha.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world-alpha
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world-alpha
  template:
    metadata:
      labels:
        app: hello-world-alpha
    spec:
      containers:
      - name: hello-world
        image: gcr.io/google-samples/hello-app:1.0
        env:
        - name: DATABASE_SERVERNAME
          value: "sql.example.local"
        - name: BACKEND_SERVERNAME
          value: "be.example.local"
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: hello-world-alpha
spec:
  selector:
    app: hello-world-alpha
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  
‍‍
```


* vim deployment-beta.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world-beta
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world-beta
  template:
    metadata:
      labels:
        app: hello-world-beta
    spec:
      containers:
      - name: hello-world
        image: gcr.io/google-samples/hello-app:1.0
        env:
        - name: DATABASE_SERVERNAME
          value: "sql.example.local"
        - name: BACKEND_SERVERNAME
          value: "be.example.local"
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: hello-world-alpha
spec:
  selector:
    app: hello-world-beta
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: ClusterIP

      

```

```bash
kubectl apply -f deployment-alpha.yaml

sleep 5

kubectl apply -f deployment-beta.yaml

PODNAME=$(kubectl get pods | grep hello-world-alpha | awk '{print $1}' | head -n 1)

echo $PODNAME
```

### Secret

* Storage sensitive information as Objects
* Retrieve for later use
* Password, Api token, keys and certificates
* Safe and more flexible configuration (Pods specs and Images)


Note: Secret
* base64 encoded
* Encryption can be configured
* Stored in etcd

Namespcafce can only be refrenced by pods in the same Namespace



#### Creating Secrets

```bash
kubectl create secret generic app1 --form-literal=USERNAME=app1login --from-literal=PASSWORD='reza@123'

```

#### Using Secrets in Pods
```bash
Enviroment Variables
Volumes or Files
Updatable
can be marked Immutable
Secret Must be accessible to the Pod at startup
```

#### uing Secrets in Enviroment Variables

```yaml
## Tehy keys and values qare case sensitive

kubectl create secret generic app1 --from-literal=USERNAME=app1login  --from-literal=PASSWORD='reza@123'

## get secret
kubectl get secrets

## app1 said it 
kubectl describe secret app1

#If we need to access those at the command line
#These are wrapped in bash expansion to add a newline to output for readability

echo $(kubectl get secret app1 --template={{..data.USERNAME}} )
echo $(kubectl get secret app1 --template={{.data.USERNAME}} | base64 --decode)

###

echo $(kubectl get secret app1 --template={{..data.PASSWORD}} )
echo $(kubectl get secret app1 --template={{.data.PASSWORD}} | base64 --decode)

```


### deployment-secret-env.yaml

```yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world-secret-env
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world-secret-env
  template:
    metadata:
      labels:
        app: hello-world-secret-env
    spec:
      containers:  # Fixed typo here
      - name: hello-world
        image: gcr.io/google-samples/hello-app:1.0
        env:
        - name: app1username
          valueFrom:
            secretKeyRef:
              name: app1
              key: USERNAME
        - name: app1password
          valueFrom:
            secretKeyRef:
              name: app1
              key: PASSWORD
        ports:
        - containerPort: 8080  # Fixed indentation here
```


```bash

PODNAME=$(kubectl get pods | grep hello-world-secret-env | awk '{print $1}' | head -n 1)

echo $PODNAME

```

### deployment-secret-files.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world-secret-files
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world-secrets-files
  template:
    metadata:
      labels:
        app: hello-world-secrets-files
    spec:
      volumes:
        - name: appconfig
          secret:
            secretName: app1
      containers:
      - name: hello-world
        image: gcr.io/google-samples/hello-app:1.0
        ports:
        - containerPort: 8080
        volumeMounts:
           - name: appconfig
             mountPath: "/etc/appconfig"
```
            
``` yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world-secret-files
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world-secret-files
  template:
    metadata:
      labels:
        app: hello-world-secret-files
    spec:
      volumes:
        - name: appconfig
          secret:
            secretName: app1
      containers:
      - name: hello-world
        image: gcr.io/google-samples/hello-app:1.0
        ports:
        - containerPort: 8080
        volumeMounts:
          - name: appconfig
            mountPath: "/etc/appconfig"
      - name: debug-container
        image: busybox
        command: ["sleep", "3600"]





```

```bash

kubectl apply -f deployment-secret-files.yaml

PODNAME=$(kubectl get pods | grep hello-world-secret-env | awk '{print $1}' | head -n 1)

echo $PODNAME
```

```bash

## clean os

kubectl delete deployment

```


### Pulling a container Image Using a secret

# Demo 1 - pulling a container from a private container Registery

# To create a Private repository in a container registery, follo the directions here


```bash

sudo ctr image pull gcr.io/google-samples/hello-app:1.0


sudo ctr image list

## Tagging our image in the format your registery, image and tag

ctr images tag gcr.io/google-samples/hello-app:1.0 docker.io/rezabojnordi/hello-app:ps

## check the result
sudo ctr image list

### Now push that locally tagged image into our private registery at docker hub
#You'll be using your own repository, so update that information here and specify your $USERNAME
#You will be prompted for the password to your repository

sudo ctr images push docker.io/$USERNAME/hello-app:ps --user $USERNAME

sudo ctr images push docker.io/rezabojnordi/hello-app:ps --user rezabojnordi


## Create our secretg that we'll use for our image pull ....
## Update the parameters to match the information for your repository including the servername, username, password and 

kubectl create secret docker-registry private-reg-cared  --docker-server=http://index.docker.io/v2  --docker-username=rezabojnordi --docker-password=09368700813  --docker-email=rezabojnordi2012@gmail.com


## Ensure the image doesn't exist on any of our nodes... or else we can get a false positivc since our image would

sudo ctr --namespace k8s.io image ls  "name~=hello-app" -q | sudo xargs ctr --namespace k8s.io image ls "name~=hello-app" -q | sudo xargs ctr --namespace k8s.io image rm

vim ~/.bashrc
  alias ctr="ctr --namespace k8s.io"
  
## Create a deployment using ImagePullSecretg in the Pod spec
kubectl apply -f deployment-private-registery.yaml


```


#### deployment-private-registery.yaml
```yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world-private-registery
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world-private-registery
  template:
    metadata:
      labels:
        app: hello-world-private-registery
    spec:
      containers:
      - name: hello-world
        image: rezabojnordi/hello-app:ps
        ports:
          - contanerPort: 8080
      imagePullSecrets:
      - name: private-reg-cred
```

```bash

## Check out Containers and events section to ensure the container was actully pulled
kubectl descrive pods hello-world

kubectl delete -f deployment-private-registery.yaml

kubectl delete secrets private-reg-cared


```


### ConfigMap


```bash
# Create A PROD  ConfigMap

kubectl create configmap appconfigprod --from-literal=DATABASE=sql.example.local  --from-literal=BACKEND_SERVERNAME=be.example.local

kubectl get configmaps


## Create  QA ConfigMap

more appconfigpa

DATABASE_SERVERNAME="sqlqa.example.localhost"
BACKEND_SERVERNAME="beqa.example.localhost"

kubectl create configmap appconfigqa --from-file=appconfigpa

### Each create method yeilded a different structure in the ConfigMap

kubectl get configmap appconfprod -o yaml

kubectl get configmap appconfigqa -o yaml

```


### deployment-configmap-env-prod.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world-configmaps-env-prod
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world-configmaps-env-prod
  template:
    metadata:
      labels:
        app: hello-world-configmaps-env-prod
    spec:
      containers:
      - name: hello-world
        image: gcr.io/google-samples/hello-app:1.0
        envFrom:
          - configMapRef:
              name: appconfigprod
        ports:
        - containerPort: 8080



```

### deployment-configmap-file-qa.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world-configmaps-file-qa
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world-configmaps-file-qa
  template:
    metadata:
      labels:
        app: hello-world-configmaps-file-qa
    spec:
      volumes:
        - name: appconfig
          configMap:
            name: appconfigqa
      containers:
      - name: hello-world
        image: gcr.io/google-samples/hello-app:1.0
        ports:
        - containerPort: 8080
        volumeMounts:
          - name: appconfig
            mountPath: "/etc/appconfig"
```

```bash

kubectl apply -f  deployment-configmap-file-qa.yaml

PODNAME=$(kubectl get pods | grep hello-world-configmap | awk '{print $1}' | head -n 1)

echo $PODNAME

##Updating a Configmap
kubectl edit configmap appconfigqa
```

### request.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world-requests
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello-world-requests
  template:
    metadata:
      labels:
        app: hello-world-requests
    spec:
      containers:
      - name: hello-world
        image: gcr.io/google-samples/hello-app:1.0
        resources:
          requests:
            cpu: "1"
        ports:
        - containerPort: 8080

```

```bash

kubetcl apply -f request.yaml

kubectl get pods -o wide

kubectl scale deployment hello-world-requests --replicas 6  ## some pods is not ready becasue for limitiation on the resource

kubectl delete -f requests.yaml
```


### Controlling Scheduling

* Node Selector
* Affinity
* Taint and Tolerations
* Node Cordoning 
* Manual Scheduling

* NodeSelector: assign to nodes using Labels and selectors

simple key/ value check base on matchlabesl

```bash
kubectl label node worker1 hardware=local_gpu


```

```yaml
spec:
  containers:
  - name: hello-world
    image: gcr.io/google-samples/hello-app:1.0
    ports:
    - containerPort: 8080
  nodeSelector:
    hardware: local_gpu
```


### Affinity and Anti-Affinity
* nodeAffinity: uses Labels on nodes to make a scheduling decision with matchExpressions
* requiredDuringschedulingignoredDuringExecution
* preferredDuringschedulingignoredDuringExecution

* PodAffinity: schedulre pods onto same node, zone as some other pod

* PodAntiAffinity: schedule pods onto the diffrent node, zone as some other pod


``` yaml
spec:
  containers:
  - name: hello-world-cache
  ...
  affinity:
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          machExpression:
          - key: app
            operator: In
            values:
            - hello-world-web
        topologyKey: "kubertnetes.io/hostname"
```


### Taints and Tolerations

* Taints: ability to control which Pods are scheduled to Nodes
* Tolerations: allows a Pod to Ignore a Taint and be scheduled as normal on Tainted Nodes
* Useful in scenarios where the cluster Administrator need to influence scheduleing without depending on the user

key=value:Effectively
```bash

### Adding a Taint to a Nodes and a Toleration to a Pod
kubectl taint nodes worker1 key=MyTaint:NoSchedule

spec:
  containers:
  - name: hello-world
    image: gcr.io/google-samples/hello-app:1.0
    ports:
    - containerPort: 8080
  tolerations:
  - key: "key"
    operator: "Equal"
    value: "MyTaint"
    effect: "NoSchedule
```


### deployment-affinity.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world-web
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello-world-web
  template:
    metadata:
      labels:
        app: hello-world-web
    spec:
      containers:
      - name: hello-world-web
        image: gcr.io/google-samples/hello-app:1.0
        ports:
        - containerPort: 8080

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world-cache
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world-cache
  template:
    metadata:
      labels:
        app: hello-world-cache
    spec:
      containers:
      - name: hello-world-cache
        image: gcr.io/google-samples/hello-app:1.0
        ports:
        - containerPort: 8080
      affinity:
        podAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - hello-world-web
            topologyKey: "kubernetes.io/hostname"



```
```bash
kubectl apply -f deployment-affinity.yaml

kubectl describe nodes worker1 |head
kubectl get nodes --show-labels
#If we scale the web deployment
#we will still get spread scross nodes in the replicaSet so we don't need to enforce that with affinity
kubectl scale deployment hello-world-web --replicas 2

kubectl get pods -o wide

## Then when we scale the cache deployment, it will get scheduled to the same node as the other web server

kubectl scale deplyment hello-world-cache --replicas 2


```

### deployment-antiaffinity.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world-web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world-web
  template:
    metadata:
      labels:
        app: hello-world-web
    spec:
      containers:
      - name: hello-world-web
        image: gcr.io/google-samples/hello-app:1.0
        ports:
        - containerPort: 8080
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - hello-world-web
            topologyKey: "kubernetes.io/hostname"


---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world-cache
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world-cache
  template:
    metadata:
      labels:
        app: hello-world-cache
    spec:
      containers:
      - name: hello-world-cache
        image: gcr.io/google-samples/hello-app:1.0
        ports:
        - containerPort: 8080
      affinity:
        podAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - hello-world-web
            topologyKey: "kubernetes.io/hostname"



```


```bash
## One Pod will go pending because we can have oly 1 web Pod per node
## when using requiredDuringSchedulingIgnoredDuringExecution in our antiaffinity rule
kubectl get pods -o wide --selector app=hello-world-web

```


### Controlling Pods placement with Taints and Tolerations

````bash
kubectl taint nodes worker1 key=MyTaint:NoSchedule

kubectl describe node worker1

````

### deployment.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-world-web
        image: gcr.io/google-samples/hello-app:1.0
        ports:
        - containerPort: 8080
```


### deployment-tolerations.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-world-web
        image: gcr.io/google-samples/hello-app:1.0
        ports:
        - containerPort: 8080
      tolerations:
      - key: "key"
        operator: "Equal"
        value: "MyTaint"   # Taint
        effect: "NoSchedule"

```

```bash
kubectl apply -f deployment-tolerations.yaml

kubectl get pods -o wide

## REmove put Taint
kubectl taint nodes worker1 key:NoSchedule-

kubectl delete -f deployment-tolerations.yaml
kubectl delete -f deployment.yaml

Scheduling a pod to node 

kubectl get pods --show-labels

```


### Node Cordoning

* Marks Node as unschedulabe
* Prevents new Pods from being scheduled to that Node
Does not affect any existing Pods on the Node

* Note: This is useful as a preparatory step befor a Node reboot or maintenance

``` bash
kubectl cordon worker1

# if you want to gracefully evict your Pods from a Node

kubectl drain worker --ignore-daemonsets

```

### Manually scheduling a Pod
* Scheduler populates NodeName
if you soecify nodeName in your Pod definitions the pod will be started on that Mode 

Node's name must exist

* implement your own scheduler
* Run multi schedulers concurrently
  Define your scheduler as a system Pod in the cluster

```bash

kubectl apply -f deployment.yaml

kubectl get pods -o wide

#Lets cordon worker3
kubectl cordon worker3

# That won't evict any pods
kubectl get pods -o wide

# But if I scale the deployment
kubectl scale deployment hello-world --replicas 6
## if you run scale pods don't run on the worker3

# let's drain (remove) the pods from worker3
kubectl drain worker3
# if you got error run below command

# Let's try that again since daemonset aren't daemonsets aren't scheduled we need to workd around them

kubectl drain worker3 --ignore-daemonsets

## We can uncordon worker3, but noting will get schedule ahere untill there's an event like scaling operations or 
#Sometimes undordon worker3
kubectl uncordon worker3


# Can't remove the unmanaged Pod either since it's not manage by controller  and won't restated 

kubectl drain worker --ignore--daemonsets

or

kubectl drain worker --ignore--daemonsets --force
```


## connect Kubernetes to Ceph 


```

cat <<EOF > csi-config-map.yaml
---
apiVersion: v1
kind: ConfigMap
data:
  config.json: |-
    [
      {
        "clusterID": "93292be2-7362-11ef-ba02-a1f2872d353a",
        "monitors": [
          "172.20.47.12:6789",
          "172.20.47.13:6789",
          "172.20.47.14:6789"
        ]
      }
    ]
metadata:
  name: ceph-csi-config
EOF


kubectl apply -f csi-config-map.yaml
sleep 1


cat <<EOF > csi-kms-config-map.yaml
---
apiVersion: v1
kind: ConfigMap
data:
  config.json: |-
    {}
metadata:
  name: ceph-csi-encryption-kms-config
EOF


kubectl apply -f csi-kms-config-map.yaml
sleep 1


cat <<EOF > ceph-config-map.yaml
---
apiVersion: v1
kind: ConfigMap
data:
  ceph.conf: |
    [global]
    auth_cluster_required = cephx
    auth_service_required = cephx
    auth_client_required = cephx
  # keyring is a required key and its value should be empty
  keyring: |
metadata:
  name: ceph-config
EOF


kubectl apply -f ceph-config-map.yaml
sleep 1

cat <<EOF > csi-rbd-secret.yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: csi-rbd-secret
  namespace: default
stringData:
  userID: kubernetes
  userKey: AQA0Az9nHe3/LRAAHW2O18YdYCrhTMtwJ/Pjkw==
EOF


kubectl apply -f csi-rbd-secret.yaml
sleep 1

cat <<EOF > provisioner-serviceaccount.yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: rbd-csi-provisioner
  # replace with non-default namespace name
  namespace: default

---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: rbd-external-provisioner-runner
rules:
  - apiGroups: [""]
    resources: ["nodes"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["secrets"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["events"]
    verbs: ["list", "watch", "create", "update", "patch"]
  - apiGroups: [""]
    resources: ["persistentvolumes"]
    verbs: ["get", "list", "watch", "create", "update", "delete", "patch"]
  - apiGroups: [""]
    resources: ["persistentvolumeclaims"]
    verbs: ["get", "list", "watch", "update"]
  - apiGroups: [""]
    resources: ["persistentvolumeclaims/status"]
    verbs: ["update", "patch"]
  - apiGroups: ["storage.k8s.io"]
    resources: ["storageclasses"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["snapshot.storage.k8s.io"]
    resources: ["volumesnapshots"]
    verbs: ["get", "list", "watch", "update", "patch", "create"]
  - apiGroups: ["snapshot.storage.k8s.io"]
    resources: ["volumesnapshots/status"]
    verbs: ["get", "list", "patch"]
  - apiGroups: ["snapshot.storage.k8s.io"]
    resources: ["volumesnapshotcontents"]
    verbs: ["create", "get", "list", "watch", "update", "delete", "patch"]
  - apiGroups: ["snapshot.storage.k8s.io"]
    resources: ["volumesnapshotclasses"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["storage.k8s.io"]
    resources: ["volumeattachments"]
    verbs: ["get", "list", "watch", "update", "patch"]
  - apiGroups: ["storage.k8s.io"]
    resources: ["volumeattachments/status"]
    verbs: ["patch"]
  - apiGroups: ["storage.k8s.io"]
    resources: ["csinodes"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["snapshot.storage.k8s.io"]
    resources: ["volumesnapshotcontents/status"]
    verbs: ["update", "patch"]
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get"]
  - apiGroups: [""]
    resources: ["serviceaccounts"]
    verbs: ["get"]
  - apiGroups: [""]
    resources: ["serviceaccounts/token"]
    verbs: ["create"]
  - apiGroups: ["groupsnapshot.storage.k8s.io"]
    resources: ["volumegroupsnapshotclasses"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["groupsnapshot.storage.k8s.io"]
    resources: ["volumegroupsnapshotcontents"]
    verbs: ["get", "list", "watch", "update", "patch"]
  - apiGroups: ["groupsnapshot.storage.k8s.io"]
    resources: ["volumegroupsnapshotcontents/status"]
    verbs: ["update", "patch"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: rbd-csi-provisioner-role
subjects:
  - kind: ServiceAccount
    name: rbd-csi-provisioner
    # replace with non-default namespace name
    namespace: default
roleRef:
  kind: ClusterRole
  name: rbd-external-provisioner-runner
  apiGroup: rbac.authorization.k8s.io

---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  # replace with non-default namespace name
  namespace: default
  name: rbd-external-provisioner-cfg
rules:
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get", "list", "watch", "create", "update", "delete"]
  - apiGroups: ["coordination.k8s.io"]
    resources: ["leases"]
    verbs: ["get", "watch", "list", "delete", "update", "create"]

---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: rbd-csi-provisioner-role-cfg
  # replace with non-default namespace name
  namespace: default
subjects:
  - kind: ServiceAccount
    name: rbd-csi-provisioner
    # replace with non-default namespace name
    namespace: default
roleRef:
  kind: Role
  name: rbd-external-provisioner-cfg
  apiGroup: rbac.authorization.k8s.io
EOF

kubectl apply -f provisioner-serviceaccount.yaml
sleep 1


cat <<EOF > node-serviceaccount.yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: rbd-csi-nodeplugin
  # replace with non-default namespace name
  namespace: default
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: rbd-csi-nodeplugin
rules:
  - apiGroups: [""]
    resources: ["nodes"]
    verbs: ["get"]
  # allow to read Vault Token and connection options from the Tenants namespace
  - apiGroups: [""]
    resources: ["secrets"]
    verbs: ["get"]
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get"]
  - apiGroups: [""]
    resources: ["serviceaccounts"]
    verbs: ["get"]
  - apiGroups: [""]
    resources: ["persistentvolumes"]
    verbs: ["get"]
  - apiGroups: ["storage.k8s.io"]
    resources: ["volumeattachments"]
    verbs: ["list", "get"]
  - apiGroups: [""]
    resources: ["serviceaccounts/token"]
    verbs: ["create"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: rbd-csi-nodeplugin
subjects:
  - kind: ServiceAccount
    name: rbd-csi-nodeplugin
    # replace with non-default namespace name
    namespace: default
roleRef:
  kind: ClusterRole
  name: rbd-csi-nodeplugin
  apiGroup: rbac.authorization.k8s.io
EOF
kubectl apply -f node-serviceaccount.yaml


rm -f csi-rbdplugin-provisioner.yaml csi-rbdplugin.yaml

wget https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-rbdplugin-provisioner.yaml

wget https://raw.githubusercontent.com/ceph/ceph-csi/master/deploy/rbd/kubernetes/csi-rbdplugin.yaml

kubectl apply -f csi-rbdplugin-provisioner.yaml
kubectl apply -f csi-rbdplugin.yaml
sleep 20


cat <<EOF > csi-rbd-sc.yaml
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
   name: csi-rbd-sc
provisioner: rbd.csi.ceph.com
parameters:
   clusterID: 93292be2-7362-11ef-ba02-a1f2872d353a
   pool: k8s
   imageFeatures: layering
   csi.storage.k8s.io/provisioner-secret-name: csi-rbd-secret
   csi.storage.k8s.io/provisioner-secret-namespace: default
   csi.storage.k8s.io/controller-expand-secret-name: csi-rbd-secret
   csi.storage.k8s.io/controller-expand-secret-namespace: default
   csi.storage.k8s.io/node-stage-secret-name: csi-rbd-secret
   csi.storage.k8s.io/node-stage-secret-namespace: default
reclaimPolicy: Delete
allowVolumeExpansion: true
mountOptions:
   - discard
EOF


kubectl apply -f csi-rbd-sc.yaml

```



### testing io for DB

```
fio --name=database_test \
    --ioengine=libaio \
    --rw=randrw \
    --bs=4k \
    --direct=1 \
    --size=1G \
    --numjobs=4 \
    --runtime=60 \
    --group_reporting \
    --iodepth=16 \
    --filename=db.txt

```


```bash

fio --name=large_file_test \
    --ioengine=libaio \
    --rw=write \
    --bs=1M \
    --direct=1 \
    --size=10G \
    --numjobs=1 \
    --runtime=60 \
    --group_reporting \
    --filename=largefile.txt



```

## sERVICE AND Networked


```bash
route
kubectl get nodes -o wide

```

#### cluster DNs service
```bash
kubectl get srvice --namespace kube-system
kubectl describe deployment coredns --namespace kube-system |more

kubectl get configmaps --namespace kube-system coredns -o yaml | more
```

#### vim corednsconfigurationcustome.yaml
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {
        "apiVersion": "v1",
        "data": {
          "Corefile": ".:53 {\n  errors\n  health\n  kubernetes cluster.localhost in-addr.arpa ip6.arpa {\n    pods insecure\n    fallthrough in-addr.arpa ip6.arpa\n    ttl 30\n  }\n  prometheus :9153\n  forward . 1.1.1.1\n  cache 30\n  loop\n  reload\n  loadbalance\n}\ncentinosystems.com {\n  forward . 9.9.9.9\n}"
        },
        "kind": "ConfigMap",
        "metadata": {
          "name": "coredns",
          "namespace": "kube-system"
        }
      }
data:
  Corefile: |
    .:53 {
      errors
      health
      kubernetes cluster.localhost in-addr.arpa ip6.arpa {
        pods insecure
        fallthrough in-addr.arpa ip6.arpa
        ttl 30
      }
      prometheus :9153
      forward . 1.1.1.1
      cache 30
      loop
      reload
      loadbalance    
    }
    centinosystems.com {
      forward . 9.9.9.9
    }


```

```bash
kubectl apply -f corednsconfig.ap.yaml --namespace kube-system

kubectl get events -n kube-system

SERVICEIP=$(kubectl get service --namespace kube-system kube-dns -o jsonpath='{ .spec.clusterIp }')
nslookup www.pluralsight.com $SERVICEIP


### solve error on the coredns and doesn't solve it

```bash
kubectl delete deployment coredns -n kube-system
kubectl delete configmap coredns -n kube-system

kubeadm init phase addon coredns
```

```
### How Service work
* Service match Pods using Labels and selectors
* create and registers Endpoints in the service (Pod Io and port pair)
* Implemented in the kube-proxy on the Node in iptables
* kube-proxy watched the Api server and the Endpoints


### Service Types
* Cluster IP
* NodePort
* loadBalancer


### Defining Deploym,ent and services

```bash
kubectl create deployment hello-world --image=gcr.io/google-sample/hello-app:1.0
kubectl expose deployment hello-world --port=80 --target-port=8080 --type NodePort


```
* Exposing and accessing applications with Services
  * ClusterIP
  * NodePort
  * loadBalancer

### clusterIp
```bash
kubectl create deployment hello-world-clusterip --image=gcr.io/google-samples/hello-app:1.0

#when creating a service, you can define a type, if you don't define a type, the default is clusterIp
kubectl expose deploymen hello-world-clusterip --port=80 --target-port=8080 --type ClusterIP

kubectl get service

#Get the service's clusterIP and store that for reuse
SERVICEIP=$(kubectl get service hello-world-clusterip -o jsonpath='{ .spec.clusterIP}')

echo $SERVICEIP
#Access the servicec inside the cluster
curl http://$SERVICEIP

#Get a listing of the endpoints for a service, we see the one pod endpoint registered
kubectl get endpoints hello-world-clusterip
kubectl get pods -o wide
PODIP=$(kubectl get endpoints hello-world-clusterip -o jsonpath='{ .subsets[].addresses[].ip }')
curl http://$PODIP:8080

## scale the deployment, new endpoint are registered automatically
kubectl scale deployment hello-world-clusterip --replicas=6
kubectl get endpoints hello-world-clusterip
#Acess the service inside the cluster, this time our requests will be load balanced ... whoooo
curl http://$SERVICEIP

kubectl describe service hello-world-clusterip 

kubectl get pods --show-labels

kubectl delete deployments.apps hello-world-clusterip
kubectl delete service hello-world-clusterip

```

### NodePort
```bash
kubectl create deployment hello-world-node-port --image=gcr.io/google-samples/hello-app:1.0

#when createing a service, you can define a type, if you don't define a type, the default is clusterip
kubectl expose deployment hello-world-node-port --port=80 --target-port=8080 --type NodePort

kubectl get service

kubectl get service hello-world-node-port -o yaml
CLUSTERIP=$(kubectl get service hello-world-node-port -o jsonpath='{ .spec.clusterIP }')
PORT=$(kubectl get service hello-world-node-port -o jsonpath='{ .spec.ports[].port }')
NODEPORT=$(kubectl get service hello-world-node-port -o jsonpath='{ .spec.ports[].nodePort }')

#we have only one pod online supporting our service
kubectl get pods -o wide

#And we can access the service bt hitting the node port on ANY node in the cluster on the Node's Real Ip or Name
#This will forward to the cluster IP and get load balanced to a Pod. Even if there is only one pods
curl http://172.20.45.20:$NODEPORT
curl http://172.20.45.21:$NODEPORT


# And a Node port Service is also listening on a cluster Ip, in fact the Node Port traffic is routed to the ClusterIP
echo $CLUSTERIP:$PORT
curl http://$CLUSTERIP:$PORT

#clean 
kubectl delete deployments.apps hello-world-node-port
kubectl delete service hello-world-node-port 

```

### Loadbalancer on the cloud
```bash
kubectl config use-context 'k8s-cloud'

kubectl create deployment hello-world-loadbalancer --image=gcr.io/google-samples/hello-world:1.0


#when createing a service, you can define a type, if you don't define a type, the default is clusterip
kubectl expose deployment hello-world-loadbalancer --port=80 --target-port=8080 --type LoadBalancer

kubectl get service
kubectl get service --watch

LOADBALANCER=$(kubectl get service hello-world-loadbalancer -o jsonpath='{ .status.loadBalancer.ingress[].ip }')

## clean

kubectl delete deployments.apps hello-world-loadbalancer 

kubectl delete service hello-world-loadbalancer

```


### Service Descovery
* Infrastructure independence
* static configuration
* DNS
* Enviroment Variables

Note: Other Types of Services
* ExternalName --> Service discovery for external service
--> CNAME to resource
* Headless  --> DNS but not ClusterIp
--> Dns record for etch endpoint
stateful application
* without Selectors --> map to specific endpoint
--> manually create endpoint objects
-->point to any IP inside or outside cluster


```bash
kubectl create deployment hello-world-clusterip --image=gcr.io/google-samples/hello-app:1.0

kubectl expose deployment hello-world-clusterip --port=80 --target-port=8080 --type ClusterIP
y
kubectl get service kube-dns --namespace kube-system

nslookup hello-world-clutserip.default.svc.cluster.local 10.96.0.10
```

```bash
kubectl create namespace ns1
kubectl create deployment hello-world-clusterip --namespace ns1 --image=gcr.io/google-samples/hello-app:1.0

kubectl expose deployment hello-world-clusterip --namespace ns1 --port=80 --target-port=8080 --type ClusterIP

nslookup hello-world-clutserip.ns1.svc.cluster.local 10.96.0.10


```

### Ingress
* Ingress Resource
* Ingress controller
* Ingress Class


#### Ingress overview
* Ingress Resource
* Defines rules for external access to Services
* Load balancing to Endpoints
* Name-base virtual hosts
* Path-based routing
* TLS termination

```bash
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-single
spec:
  ingressClassName: nginx
  defaultBackend:
    service:
      name: hello-world-service-single
      port:
        number: 80
```

#### Expoing Multiple Service with ingress

```
path.example.com/red
path.example.com/blue

```
```yaml
spec:
  ingressClassName: nginx
  rules:
    - host: path.example.com
      http:
        paths:
        - path: /red
          pathtype: Prefix
          backend:
            service:
              name: hello-world-service-red
              port:
                number: 4242
        - path: /blue
          pathType: Exact
          backend:
            service:
              name: hello-world-service-blue
              port:
                number: 4343
        defaultBackend:
          service:
            name: hello-world-service-single
            port:
              number: 80
```


### Name Based Virtual Hosts with Ingress

```yaml


```












### argocd

```bash
kubectl create ns argocd
helm repo add argo https://argoproj.github.io/argo-helm

helm pull argo/argo-cd --version 7.7.5

tar xvf 7.7.5.tar.gz

#change namespace name
helm install argocd .

or
## uninstall
helm uninstall argocd 


```


### ingress

```bash

kubectl create ns ingress-nginx

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
## Note: open the blow link and download values.yaml

https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx

helm install ingress-nginx ingress-nginx/ingress-nginx -f values.yml -n ingress-nginx

```

* Note: connecting to the nginx pods I mean deployment

```yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-nfs-deployment
spec:
  replicas: 1
  selector:
    matchLabels:  # اصلاح نام اشتباه 'macheLabels'
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
        volumeMounts:
        - name: webcontent
          mountPath: "/usr/share/nginx/html/web-app"
      volumes:
      - name: webcontent
        persistentVolumeClaim:
          claimName: pvc-nfs

---
apiVersion: v1
kind: Service
metadata:
  name: nginx-nfs-service
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    protocol: TCP
    targetPort:
```

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
        #annotations:
          #kubernetes.io/ingress.class: nginx
  name: hello-app-ingress
  namespace: default
spec:
  ingressClassName: nginx
  rules:
    - host: ingress.softgrand.ir
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nginx-nfs-service  # nginx service name
                port:
                  number: 80
~                             
```

* Note: if your service is private ip You must add below project to your server that server has public ip

```bash

wget https://github.com/snail007/goproxy/releases/download/v14.6/proxy-linux-amd64.tar.gz  

# master ip (172.20.45.20)
./proxy tcp -p ":80" -T tcp -P "172.20.45.20:31271"  

```



* another example
```yaml
vim sample.yml

---
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    namespace: default
    name: hello-app-deployment
    labels:
      app: hello-app
  spec:
    replicas: 2
    selector:
      matchLabels:
        app: hello-app
    template:
      metadata:
        labels:
          app: hello-app
      spec:
        containers:
        - name: hello-app
          image: gcr.io/google-samples/hello-app:1.0
          ports:
          - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  namespace: default
  name: hello-app-service
spec:
  type: NodePort
  selector:
    app: hello-app
  ports:
    - protocol: TCP
      port: 8080
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-app
  namespace: default
spec:
  ingressClassName: nginx
  rules:
    - host: ingress.softgrand.ir
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: hello-app-service
                port:
                  number: 8080
```
* example2
```yaml


apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
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

---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  rules:
    - host: testlk.com  # Replace with your domain
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nginx-service
                port:
                  number: 80

```


## Shutdown worker node
```bash
kubectl cordon si1-kube7005
kubectl drain si1-kube7005 --delete-local-data --ignore-daemonsets
sudo kubectl uncordon si1-kube7005

```



### How to deploy Kafka

* Strimzi makes it easy to deploy and manage Kafka on Kubernetes.
```
kubectl create namespace kafka

kubectl apply -f https://strimzi.io/install/latest?namespace=kafka -n kafka


kubectl get pods -n kafka

```


#### Step 3: Deploy a Kafka Cluster
Now, we define a Kafka cluster with Zookeeper.

1. **Create** a kafka-cluster.yaml **file**:
```
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: my-cluster
  namespace: kafka
spec:
  kafka:
    version: 3.8.1
    replicas: 3
    listeners:
      - name: plain
        port: 9092
        type: internal
        tls: false
    config:
      offsets.topic.replication.factor: 3
      transaction.state.log.replication.factor: 3
      transaction.state.log.min.isr: 2
      log.message.format.version: "3.5"
    storage:
      type: ephemeral
  zookeeper:
    replicas: 3
    storage:
      type: ephemeral
  entityOperator:
    topicOperator: {}
    userOperator: {}

```

```
kubectl apply -f kafka-cluster.yaml -n kafka

```

```
kubectl get pods -n kafka

```

#### Step 4: Deploy Kafka Client for Developers

To allow developers to easily use Kafka, deploy a client pod.

1. **Create** a client **pod YAML file** (kafka-client.yaml):

```
apiVersion: v1
kind: Pod
metadata:
  name: kafka-client
  namespace: kafka
spec:
  containers:
  - name: kafka-client
    image: bitnami/kafka:latest
    command: ["/bin/sh"]
    args: ["-c", "sleep infinity"]


```

```
kubectl apply -f kafka-client.yaml -n kafka

```

```
kubectl exec -it kafka-client -n kafka -- /bin/sh

```