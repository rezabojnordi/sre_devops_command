# Helm cheatsheet

### Install helm:
```
sudo snap install helm --classic
```

### Install helm from apt:
```
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```
### To search for helm repositories click on:
https://artifacthub.io/


### Package and push helm to repository (Go inside helm directory):
```
export HELM_EXPERIMENTAL_OCI=1
helm package .
helm registry login harbor.domain.com -u admin
helm push package_name.tgz oci://mycontainerregistry.domain.com/helm
```


| Command          | Description                         |
| ---------------- |:-----------------------------------|
| `helm repo list` | List of repos |
| `helm repo add name url` | Add a new repo |
| `helm repo update` | Update repos |
| `helm search repo partial_name` | Search for repos |
| `helm install name directory` | Install helm chart |
| `helm uninstall name` | Uninstall helm chart |
| `helm uninstall name --keep-history` | Uninstall helm chart but keeps history |
| `helm install name directory --set param1=value1, param2=value2` | Install helm chart with params |
| `helm upgrade name directory --set param1=value1` | Update params (Other params will reset) |
| `helm upgrade name directory --set param1=value1 --reuse-values` | Update params (Other params will not reset) |
| `helm get notes name` | View notes inside chart |
| `helm lint directory` | Check the syntax |
|  |  |



| Command          | Description                         |
| ---------------- |:-----------------------------------|
| `{{ .Values.image.name }}` | Replace from values.yml image.name  |
| `{{ .Values.some_value -}}` | Replace and remove all spaces from right |
| `{{- .Values.some_value }}` | Replace and remove all spaces from left |
| `{{ .Values.some_value \| indent 12 }}` | Create 12 indents before value  |
| `{{ .Values.some_value \| nindent 12 }}` | Create a new line and 12 indents before value  |
|  |  |


### Keep a resource after helm uninstall:
```yaml
kind: Secret
metadata:
  annotations:
    "helm.sh/resource-policy": keep
```


