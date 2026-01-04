```bash
kubectl create secret generic secretstuff --from-literal=password=password --from-literal=username=reza

kubectl get secrets secretstuff -o yaml
```
