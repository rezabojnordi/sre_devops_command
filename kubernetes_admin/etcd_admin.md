
# Download the etcd tarball
```bash
etcd_version=3.4.14  # check the last version

# Download the etcd tarball
curl -L https://github.com/etcd-io/etcd/releases/download/v$etcd_version/etcd-v$etcd_version-linux-amd64.tar.gz -o etcd-v$etcd_version-linux-amd64.tar.gz

# Extract the tarball
tar xzvf etcd-v$etcd_version-linux-amd64.tar.gz

# Move the extracted binaries to /usr/local/bin
sudo mv etcd-v$etcd_version-linux-amd64/etcd* /usr/local/bin/

# Verify the installation
etcd --version

```

```bash

etcd &

etcdctl --endpoints=localhost:2379 put name reza
etcdctl --endpoints=localhost:2379 get name

etcdctl endpoint health

netstat  -nltp |grep 2379
or 
ss  -nltp |grep 2379

```

### connect etcdctl to kubernets

```bash

export ETCDCTL_API=3
export ETCDCTL_CACERT="/etc/kubernetes/pki/etcd/ca.crt"
export ETCDCTL_CERT="/etc/kubernetes/pki/etcd/server.crt"
export ETCDCTL_KEY="/etc/kubernetes/pki/etcd/server.key"
export ETCDCTL_ENDPOINTS="https://127.0.0.1:2379"


# For etcd v3.5.x, use the corresponding etcdctl version
etcd_version=3.5.0

curl -L https://github.com/etcd-io/etcd/releases/download/v$etcd_version/etcd-v$etcd_version-linux-amd64.tar.gz -o etcd-v$etcd_version-linux-amd64.tar.gz

tar xzvf etcd-v$etcd_version-linux-amd64.tar.gz

sudo mv etcd-v$etcd_version-linux-amd64/etcd* /usr/local/bin/

# Verify the installation
etcdctl --version

etcdctl put name rezaa

etcdctl get name
```


## error on the etcd
```bash
ETCDCTL_API=3 
etcdctl --endpoints 127.0.0.1:2379 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key member list

5a4945140f0b39d9, started, sbg2-k8s001, https://192.168.208.12:2380, https://192.168.208.12:2379
740381e3c57ef823, started, gra3-k8s001, https://192.168.208.13:2380, https://192.168.208.13:2379
77a8fbb530b10f4a, started, rbx4-k8s001, https://192.168.208.14:2380, https://192.168.208.14:2379

------------------------------------
ETCDCTL_API=3 etcdctl --endpoints 127.0.0.1:2379 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key member remove 740381e3c57ef823
```

## snapshot and backup

``` bash


export ETCDCTL_API=3
export ETCDCTL_CACERT="/etc/kubernetes/pki/etcd/ca.crt"
export ETCDCTL_CERT="/etc/kubernetes/pki/etcd/server.crt"
export ETCDCTL_KEY="/etc/kubernetes/pki/etcd/server.key"
export ETCDCTL_ENDPOINTS="https://127.0.0.1:2379"

etcdctl snapshot save /root/backup.db


etcdctl member list



```


```bash
unset ETCDCTL_ENDPOINTS
unset ETCDCTL_KEY
unset ETCDCTL_CERT
unset ETCDCTL_CACERT

ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  endpoint status --write-out=table

```


## adding new Master and new worker use blow command

```bash


kubeadm token create --print-join-command --certificate-key $(kubeadm init phase upload-certs --upload-certs | tail -1)
```

```bash
kubeadm token create --print-join-command

```


```bash
kubectl run web12 --image nginx:alpine


```

## ectd command

```bash
unset ETCDCTL_KEY ETCDCTL_CERT ETCDCTL_CACERT ETCDCTL_ENDPOINTS

endpoint="https://127.0.0.1:2379"
flags="--cacert=/etc/kubernetes/pki/etcd/ca.crt \
       --cert=/etc/kubernetes/pki/etcd/server.crt \
       --key=/etc/kubernetes/pki/etcd/server.key"

endpoints=$(ETCDCTL_API=3 etcdctl member list $flags --endpoints=${endpoint} \
            --write-out=json | jq -r '.members | map(.clientURLs) | add | join(",")')
```

```
ETCDCTL_API=3 etcdctl $flags --endpoints=${endpoints} member list
ETCDCTL_API=3 etcdctl $flags --endpoints=${endpoints} endpoint status
ETCDCTL_API=3 etcdctl $flags --endpoints=${endpoints} endpoint health
```
```
ETCDCTL_API=3 etcdctl $flags --endpoints=${endpoints}  --prefix --keys-only get /
ETCDCTL_API=3 etcdctl $flags --endpoints=${endpoints}  --prefix --keys-only get /registry/pods
ETCDCTL_API=3 etcdctl $flags --endpoints=${endpoints}  --prefix --keys-only get /registry/daemonsets
ETCDCTL_API=3 etcdctl $flags --endpoints=${endpoints}  --prefix --keys-only get /registry/deployments
```


