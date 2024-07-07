kubectl create -f pod_defenition.yml
kubectl delete pod pod_name
kubectl get pods
kubectl get nodes
kubectl describe pod_name

# this will update a configmap
kubectl apply -f configmap.yml
kubectl get pods

kubectl taint nodes node-name key=value:taint-effect

