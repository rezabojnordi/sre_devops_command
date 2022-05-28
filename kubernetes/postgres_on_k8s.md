# Helm cheatsheet 

Bitnami postgress helm chart: https://charts.bitnami.com/bitnami

### Install helm:
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/postgresql -f values.yaml
```

## Options

####To enable replication for Postgres edit `values.yaml` like this:
```yaml
replication:
  enables: true
  readReplicas: 3
```

####If you want let pods To tolerate specific taint, edit `values.yaml` like this:
```yaml
primary:
  tolerations:
    - key: db
    operator: Exists
```






