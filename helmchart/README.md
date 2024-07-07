

## Learning helmchart

```
webapp1
--chart.yaml
-- templates
   -- Notes.txt
   -- configmap.yaml
   -- deployment.yaml
   -- service.yaml
-- values-dev.yaml
-- valuse-prod.yaml
-- values-qa.yaml
-- values.yaml

```

### Helm command
```
helm repo [command]
helm install/unistall [...]
helm status <release>
helm list [flags]

```

#### Helm repo

```
add
index
list
removge
update

```

#### installing

```
helm install my-promethus promethus-community/promethus --version 15.9.2

```

#### List
```
helm list all-namespaces
```

#### status
```
helm status my-promethus
```

#### unistall 

```
helm unistall

helm unistall --keep-history


```