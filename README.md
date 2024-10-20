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
