kubectl create namespace ehsan
kubectl create -f pod.yml --namespace ehsan
kubectl create -f namespace.yml
kubectl get pods #It's for default namespace
kubectl get pods --namespace ehsan
kubectl get pods --all-namespaces



