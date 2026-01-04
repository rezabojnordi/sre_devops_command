```bash
kubectl create secret generic secretstuff --from-literal=password=password --from-literal=username=reza

kubectl get secrets secretstuff -o yaml

kubectl create -f pod-secret.yaml

kubectl describe pod secretbx2

kubectl exec -it secretbox2 /bin/sh
 cat /secretstuff/password
```

## base64

```bash
kubectl create secret generic mysql --from-literal=password=root
kubectl get secrets mysql -o yaml
kubectl create -f pod-secret-as-var.yaml
```
