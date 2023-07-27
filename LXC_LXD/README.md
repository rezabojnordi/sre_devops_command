

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
