# Lens cheatsheet 
# Connect Lens IDE to K8S cluster
##### Step1: Download and install Lens IDE: https://k8slens.dev/
##### Step2: Go to k8s master and copy the content of:
```
cat /etc/kubernetes/admin.conf
```
##### Step3: Go to File/Add Cluster and paste the content here and hit `Add Cluster` button
Done!

### Access through a proxy:
Create an ssh tunnel to your server:
`ssh -D 9151 -fCqN user@SERVER_IP -p SSH_PORT` 
Set `your cluster settings\ProxyHttp proxy` to `socks5://localhost:9151`
 


