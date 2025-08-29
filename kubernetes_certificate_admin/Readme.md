
# Kubernetes Command Cheatsheet and Vim Configuration

This README contains useful `kubectl` commands and a basic Vim configuration for Kubernetes users. It includes commands for interacting with Kubernetes clusters and basic tasks such as creating deployments, exposing services, and scaling deployments.

## Vim Configuration
To configure Vim for Kubernetes, open your `.vimrc` file and add the following lines:

```bash
vim ~/.vimrc
```

```vim
set expandtab
set tabstop=2
set shiftwidth=2
```

These settings adjust tab behavior for better readability in YAML files.

---

## Kubernetes Commands Cheatsheet

### General `kubectl` Commands

```bash
kubectl [command] [type] [name] [flags]

kubectl get pods pod1 --output=yaml
kubectl create deployment nginx --image=nginx
```

### Cluster and Node Information

```bash
kubectl cluster-info
kubectl get nodes
kubectl get nodes -o wide
kubectl get pods
kubectl get pods --namespace kube-system
kubectl get pods --namespace kube-system -o wide
kubectl get all --all-namespaces | more
kubectl api-resources | more
kubectl get no
kubectl api-resources | grep pod
kubectl explain pod | more
kubectl explain pod.spec | more
kubectl explain pod.spec.containers | more
kubectl explain pod --recursive | more
kubectl describe nodes c1 | more
kubectl -h | more
kubectl get -h | more
kubectl create -h | more
```

### Install Bash Completion

Install bash completion for `kubectl`:

```bash
apt install -y bash-completion
```

### Imperative Commands

```bash
kubectl create deployment nginx --image=nginx
kubectl run nginx --image=nginx
```

### Manifest Deployment (YAML Example)

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
        - name: hello-world-container
          image: gcr.io/google-samples/hello-app:1.0
          ports:
            - containerPort: 8080
```

---

### Creating and Managing Deployments

```bash
kubectl create deployment hello-world --image=gcr.io/google-samples/hello-app:1.0 --dry-run=client -o yaml > deployment3.yaml
kubectl run hello-world-pod --image=gcr.io/google-samples/hello-app:1.0
sudo crictl --runtime-endpoint unix:///run/containerd/containerd.sock ps
kubectl exec -it hello-world-pod -- /bin/sh
kubectl get deployment hello-world
kubectl get replicaset
kubectl get pods
kubectl describe deployment hello-world | more
kubectl describe replicaset hello-world | more
kubectl expose deployment hello-world --port=80 --target-port=8080
kubectl get service hello-world
kubectl describe service hello-world
curl http://$SERVICEIP:$PORT
kubectl get endpoint hello-world
curl http://$ENDPOINT:$TARGETPORT
curl http://10.100.236.189:80
kubectl get deployment hello-world -o yaml | more
kubectl get deployment hello-world -o json | more
kubectl get all
```

### Deleting Resources

```bash
kubectl delete service hello-world
kubectl delete deployment hello-world
kubectl delete pod hello-world-pod
kubectl get all
```

### Dry-Run and Apply YAML Files

```bash
kubectl create deployment hello-world --image=gcr.io/google-samples/hello-app:1.0 --dry-run=client -o yaml | more
kubectl create deployment hello-world --image=gcr.io/google-samples/hello-app:1.0 --dry-run=client -o yaml > deployment.yaml
more deployment.yaml
kubectl apply -f deployment.yaml
kubectl expose deployment hello-world --port=80 --target-port=8080 --dry-run=client -o yaml | more
kubectl expose deployment hello-world --port=80 --target-port=8080 --dry-run=client -o yaml > service.yaml
more service.yaml
kubectl apply -f service.yaml
```

### Editing and Scaling Deployments

```bash
kubectl edit deployment hello-world
curl http://10.103.73.17
kubectl scale deployment hello-world --replicas=40
kubectl delete deployment hello-world
kubectl delete service hello-world
kubectl get all
```

---

### Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Kubernetes CLI (kubectl)](https://kubernetes.io/docs/reference/kubectl/)

---

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
