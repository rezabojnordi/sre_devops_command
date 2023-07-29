

## installing LXC and LXD

```
apt update
apt upgrade
apt install lxc lxd
```

```
lxd init
```
```
root@lxd:~# lxd init
Would you like to use LXD clustering? (yes/no) [default=no]:
Do you want to configure a new storage pool? (yes/no) [default=yes]:
Name of the new storage pool [default=default]:
Name of the storage backend to use (zfs, ceph, btrfs, dir, lvm) [default=zfs]: dir
Would you like to connect to a MAAS server? (yes/no) [default=no]:
Would you like to create a new local network bridge? (yes/no) [default=yes]:
What should the new bridge be called? [default=lxdbr0]:
What IPv4 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]:
What IPv6 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]:
Would you like the LXD server to be available over the network? (yes/no) [default=no]:
Would you like stale cached images to be updated automatically? (yes/no) [default=yes]
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]:

```

```
root@lxd:~# lxc version
To start your first container, try: lxc launch ubuntu:20.04
Or for a virtual machine: lxc launch ubuntu:20.04 --vm

Client version: 4.0.9
Server version: 4.0.

```
### lxc method
```
root@lxd:~# lxc help
Description:
  Command line client for LXD

  All of LXD's features can be driven through the various commands below.
  For help with any of those, simply call them with --help.

Usage:
  lxc [command]

Available Commands:
  alias       Manage command aliases
  cluster     Manage cluster members
  config      Manage instance and server configuration options
  console     Attach to instance consoles
  copy        Copy instances within or in between LXD servers
  delete      Delete instances and snapshots
  exec        Execute commands in instances
  export      Export instance backups
  file        Manage files in instances
  help        Help about any command
  image       Manage images
  import      Import instance backups
  info        Show instance or server information
  launch      Create and start instances from images
  list        List instances
  move        Move instances within or in between LXD servers
  network     Manage and attach instances to networks
  operation   List, show and delete background operations
  profile     Manage profiles
  project     Manage projects
  publish     Publish instances as images
  remote      Manage the list of remote servers
  rename      Rename instances and snapshots
  restart     Restart instances
  restore     Restore instances from snapshots
  snapshot    Create instance snapshots
  start       Start instances
  stop        Stop instances
  storage     Manage storage pools and volumes
  version     Show local and remote versions

Flags:
      --all            Show less common commands
      --debug          Show all debug messages
      --force-local    Force using the local unix socket
  -h, --help           Print help
      --project        Override the source project
  -q, --quiet          Don't show progress information
      --sub-commands   Use with help or --help to view sub-commands
  -v, --verbose        Show all information messages
      --version        Print version number

Use "lxc [command] --help" for more information about a command.
```

### LXC Storage
```
root@lxd:~# lxc storage list
+---------+-------------+--------+------------------------------------------------+---------+
|  NAME   | DESCRIPTION | DRIVER |                     SOURCE                     | USED BY |
+---------+-------------+--------+------------------------------------------------+---------+
| default |             | dir    | /var/snap/lxd/common/lxd/storage-pools/default | 1       |
+---------+-------------+--------+------------------------------------------------+---------
```

### lxc remote list
```
root@lxd:~# lxc remote list
+-----------------+------------------------------------------+---------------+-------------+--------+--------+
|      NAME       |                   URL                    |   PROTOCOL    |  AUTH TYPE  | PUBLIC | STATIC |
+-----------------+------------------------------------------+---------------+-------------+--------+--------+
| images          | https://images.linuxcontainers.org       | simplestreams | none        | YES    | NO     |
+-----------------+------------------------------------------+---------------+-------------+--------+--------+
| local (current) | unix://                                  | lxd           | file access | NO     | YES    |
+-----------------+------------------------------------------+---------------+-------------+--------+--------+
| ubuntu          | https://cloud-images.ubuntu.com/releases | simplestreams | none        | YES    | YES    |
+-----------------+------------------------------------------+---------------+-------------+--------+--------+
| ubuntu-daily    | https://cloud-images.ubuntu.com/daily    | simplestreams | none        | YES    | YES    |
+-----------------+------------------------------------------+---------------+-------------+--------+--------+
```


### Image in my local Machine
```
root@lxd:~# lxc image list
+-------+-------------+--------+-------------+--------------+------+------+-------------+
| ALIAS | FINGERPRINT | PUBLIC | DESCRIPTION | ARCHITECTURE | TYPE | SIZE | UPLOAD DATE |
+-------+-------------+--------+-------------+--------------+------+------+-------------+
```
### getting Image from the internet
```
lxc image list images:
```

### getting debian Image
```
lxc image list images:debian |less
```
### Lunching image
```
lxc launch images:debian/12/amd64 debian12

lxc list

lxc image list
```

### how to remove lxc
```
lxc stop debian12

lxc delete debian12

or

lxc delete --force debian12
```

## Copy Lxc
```
lxc copy debian12 another_debian

lxc list

lxc start another_debian
```
## Changing the name

```
lxc stop debian12

lxc move debian12 myvm

lxc start myvm
```


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