# Traefik cheatsheet 

### Install Traefik
```
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik --set service.type=NodePort
```


