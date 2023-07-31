# install ceph with podman
for this config setup openstack with ceph and podman container

## pre install requirement packages
* passless all node from mon node
```
ssh-keygen
```

```
timedatectl set-timezone Asia/Tehran
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/Release.key" | sudo apt-key add -
apt update
sudo apt install podman
podman -v
```

if you want change repository set this config
```
sudo nano /etc/containers/registries.conf
[registries.search]
registries=["registry.access.redhat.com", "registry.fedoraproject.org", "docker.io"]
podman info
```

this site for more description:
https://linux.how2shout.com/how-to-install-podman-on-ubuntu-20-04-lts-focal-fossa/




## install ceph on every node
```
curl --silent --remote-name --location https://github.com/ceph/ceph/raw/quincy/src/cephadm/cephadm
chmod +x cephadm
sudo ./cephadm add-repo --release quincy
sudo ./cephadm install
cephadm install ceph-common
```




## 



