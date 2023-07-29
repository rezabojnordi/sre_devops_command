

### LXC List
```
lxc list
```

### Info LXC
```
lxc info myvm
```
## process tree
```
pstree pidnumber
```

### showing LXC config
```
lxc config show myvim
```
### Profile list

```
lxc profile show default
lxc profile copy default custom
lxc profile list
lxc launch ubuntu:16:04 myvm --profile custome
lxc exec myvm bash
lxc list
lxc config set myvm limit.memory 512MB
lxc config show myvm
lxc config set myvm limit.memory 1G

lxc profile edit custome

 config:
   limits.memory: 512MB

lxc laucnh ubuntu:16.04 myvm2 --profile custome
lxc exec myvm2 bash
nproc

lxc config set myvm2 limit.cpu 1

lxc file push myfile myvm2/root/

lxc file pull myvm2/root/myfile .

for i in $(seq 5); do mkdir $i; done



```
## How to snapshot from lxc
```
lxc snapshot myvm2 snap1

lxc exec myvm2 bash
  rm file

lxc restore myvm2 snap1 


```

### security pn lxc
```
lxc stop myvm
lxc config set myvm security.privilaged true
lxc config set myvm security.nesting true
lxc profile edit custome 
  config:
    limit.memory: 512MB
    security.privilaged: true
    security.nesting: true

Note: if we change security in LXC that we can run lxc iti on the lxc
 lxc iti

lxc list 3 out of lxc on your server

lxc remote list
```

### starting lxd
```
systemctl status lxd
systemctl start lxd

lxd init
```


### listing package on Snap
```
sudo snap list
```
```
lxc list
lxc profile list
lxc luanch ubuntu:18.04 ubunt
lxc info ubuntu |grep Profile
lxc profile show default
lxc profile delete default
lxc profile rename default sometimes
lxc profile get default limit.cpu\
lxc profile create custome
lxc profile list
lxc profile delete custom
lxc profile copy default custome
lxc profile edit custome
lxcexec ubunut bash
 nproc
 free -g

lxc profile list
lxc profile edit custome
 config:
   limit.cpu: 1
   limit.memory: 2G

lxc profile get custome limit.cpu
lxc profile set custome limit.cpu 2
lxc info |grep Profiles
lxc list
lxc profile add ubuntu custome
lxc exec ubuntu nproc
lxc profile set custome limit.memory "2GB"
lxc profile show custome
lxc profile remove ubuntu custome

lxc launch ubuntu:18.04 myubuntu --profile custome
lxc profile add myubuntu custome1

lxc info myubuntu |grep Profiles
  Profiles: custome, custome1
lxc profile remove myubuntu custome1

lxc profile show custome

lxc profile list

lxc profile set custome boot.autostart "true"

lxc profile show custome

```


## LXD Containers backup, import, export, migrate between lxd instances

```
lxc image list images:debian

lxc init ubuntu:18.04 myubuntu
lxc list
lxc start myubuntu
lxc list
lxc exec myubuntu bash
 touch hello

lxc stop myubuntu
lxc snapshot myubuntu snap1
lxc list
lxc info myubuntu
lxc remote list
lxc remote add ubuntuvm02 172.42.42.102

lxc remote list

lxc copy myubuntu/snap1 ubuntuvm02:myubuntu

lxc remote remove ubuntuvm02
lxc remote list

Note: publish containers as images
lxc publish myubuntu/snap1 --alias myubuntu-image
lxc image list
lxc image export myubuntu-image

scp imagefile.tar.gz 172.42.42.102:/root

ssh 172.42.42.102
lxc image import imagefile.tar.gz --aliase myubuntu-image
lxc image list
lxc init myubuntu-image myubuntu
lxc list
lxc start myubuntu

lxc exec myubuntu bash


```