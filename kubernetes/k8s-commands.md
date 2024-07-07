# Kubernetes commands cheatsheet

### Label nodes:
```
kubectl label node node_name node-role.kubernetes.io/label=
```

### Remove Label from nodes:
```
kubectl label node node_name node-role.kubernetes.io/label-
```
### Exec into a multi container pod:
```
kubectl exec -it pod_name -c container_name --  bash
```
### Create a tls secret:
```
kubectl create secret tls my-secret-name --cert=path/to/cert/file --key=path/to/key/file 
```
### Read last 10 logs:
```
kubectl logs --tail=20 nginx
```
### Port forwarding:
```
kubectl port-forward pod_name local_port:pod_port
```
### Create secret for TLS:
```commandline
kubectl create secret tls my-tls-secret --cert=fullchain.pem --key=priv.pem
```
### Force delete all pods:
```commandline
kubectl delete -n argocd po --grace-period=0 --force --all
```
### Embed certificates inside kube.config
```commandline
kubectl config view --flatten > kube.config
```
### Taint a node:
```
kubectl taint nodes node1 storage-node=true:NoSchedule
```

