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




## create cinder and cinder backup pool 
```
#create
ceph osd pool create backups 128
ceph osd pool create cinder-volumes 128

# init
rbd pool init backups
rbd pool init cinder-volumes

# enable rbd
sudo ceph osd pool application enable cinder-volumes rbd
sudo ceph osd pool application enable backups rbd

# ceph auth create user
ceph auth get-or-create client.cinder mon 'profile rbd' osd 'profile rbd pool=cinder-volumes,profile rbd pool=backups'
ceph auth get-or-create client.cinder-backup mon 'profile rbd' osd 'profile rbd pool=backups' mgr 'profile rbd pool=backups'

# move to infra client cinder
ceph auth get-or-create client.cinder | ssh infra1 sudo tee /etc/ceph/ceph.client.cinder.keyring
ceph auth get-or-create client.cinder | ssh infra2 sudo tee /etc/ceph/ceph.client.cinder.keyring
ceph auth get-or-create client.cinder | ssh infra3 sudo tee /etc/ceph/ceph.client.cinder.keyring

#set owner
ssh infra1 sudo chown cinder:cinder /etc/ceph/ceph.client.cinder.keyring
ssh infra2 sudo chown cinder:cinder /etc/ceph/ceph.client.cinder.keyring
ssh infra3 sudo chown cinder:cinder /etc/ceph/ceph.client.cinder.keyring

# move to infra client cinder backup
ceph auth get-or-create client.cinder-backup | ssh infra1 sudo tee /etc/ceph/ceph.client.cinder-backup.keyring
ceph auth get-or-create client.cinder-backup | ssh infra2 sudo tee /etc/ceph/ceph.client.cinder-backup.keyring
ceph auth get-or-create client.cinder-backup | ssh infra3 sudo tee /etc/ceph/ceph.client.cinder-backup.keyring

#set owner
ssh infra1 sudo chown cinder:cinder /etc/ceph/ceph.client.cinder-backup.keyring
ssh infra2 sudo chown cinder:cinder /etc/ceph/ceph.client.cinder-backup.keyring
ssh infra3 sudo chown cinder:cinder /etc/ceph/ceph.client.cinder-backup.keyring



# add to  all file client keyring 
                caps mds = "allow *"
                caps mgr = "allow *"
                caps mon = "allow *"
                caps osd = "allow *"
```



