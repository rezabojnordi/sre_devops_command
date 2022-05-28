# ArgoCD cheatsheet 

### Install ArgoCD:
```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### To go to webUI you can edit `argocd-server` service and change `type: NodePort`:
```
kubectl edit svc argocd-server -n argocd
```

### Now you can see the port using:
```
kubectl get svc -n argocd
```

### To see the default password for `admin` user:
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```



