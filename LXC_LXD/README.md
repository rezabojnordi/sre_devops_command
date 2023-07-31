

## installing LXC and LXD

# Installing LXC and LXD

This document provides a step-by-step guide on how to install and configure LXC (Linux Containers) and LXD (LXC Daemon) on a Linux server. LXC is an operating-system-level virtualization method for running multiple isolated Linux systems (containers) on a single host. LXD is a system container manager that provides a high-level API to manage LXC containers.

## Prerequisites

Before proceeding with the installation, ensure you have the following:

- A Linux server (e.g., Ubuntu, Debian) with root or sudo privileges.
- An internet connection to download and install the required packages.

## Installation

1. Update the package list and upgrade existing packages:

```bash

sudo apt update
sudo apt upgrade
apt update
apt upgrade
apt install lxc lxd

```

### LXD Initialization
After installing LXC and LXD, you need to initialize LXD using the lxd init command. This will guide you through a series of questions to configure the LXD environment.

``` bash
lxd init
```
``` bash

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

### Verify Installation
To check if LXC and LXD are installed and running, you can use the following command:
```
root@lxd:~# lxc version
To start your first container, try: lxc launch ubuntu:20.04
Or for a virtual machine: lxc launch ubuntu:20.04 --vm

Client version: 4.0.9
Server version: 4.0.

```
This will display the client and server versions of LXC.

### LXC Management
Once LXC and LXD are set up, you can use various commands to manage containers. Below are some common LXC management commands:

``` bash
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

## LXC Clustering

```
ssh server1
root@lxc-lxd:~# lxd init
Would you like to use LXD clustering? (yes/no) [default=no]: yes
What IP address or DNS name should be used to reach this node? [default=185.213.165.80]:
Are you joining an existing cluster? (yes/no) [default=no]:
What name should be used to identify this node in the cluster? [default=lxc-lxd]:
Setup password authentication on the cluster? (yes/no) [default=no]: yes
Trust password for new clients:
Again:
Do you want to configure a new local storage pool? (yes/no) [default=yes]:
Name of the storage backend to use (dir, lvm, zfs, btrfs) [default=zfs]: dir
Do you want to configure a new remote storage pool? (yes/no) [default=no]:
Would you like to connect to a MAAS server? (yes/no) [default=no]:
Would you like to configure LXD to use an existing bridge or host interface? (yes/no) [default=no]:
Would you like to create a new Fan overlay network? (yes/no) [default=yes]:
What subnet should be used as the Fan underlay? [default=auto]:
Would you like stale cached images to be updated automatically? (yes/no) [default=yes]
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]: yes
config:
  core.https_address: 185.213.165.80:8443
  core.trust_password: reza@123
networks:
- config:
    bridge.mode: fan
    fan.underlay_subnet: auto
  description: ""
  name: lxdfan0
  type: ""
storage_pools:
- config: {}
  description: ""
  name: local
  driver: dir
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      network: lxdfan0
      type: nic
    root:
      path: /
      pool: local
      type: disk
  name: default
cluster:
  server_name: lxc-lxd
  enabled: true
  member_config: []
  cluster_address: ""
  cluster_certificate: ""
  server_address: ""
  cluster_password: ""
  cluster_certificate_path: ""
  cluster_token: ""
```

### connect to another server

```
ssh server2
apt install lxc lxd
ssh server1
 lxc cluster list
root@lxc-lxd:~# lxc cluster list
+---------+-----------------------------+----------+--------+-------------------+--------------+
|  NAME   |             URL             | DATABASE | STATE  |      MESSAGE      | ARCHITECTURE |
+---------+-----------------------------+----------+--------+-------------------+--------------+
| lxc-lxd | https://185.213.165.80:8443 | YES      | ONLINE | Fully operational | x86_64       |
+---------+-----------------------------+----------+--------+-------------------+--------------+

ssh server2
lxd init
 yes
 enter
 enter or add your privateip
Are you joining an existing cluster? (yes/no) [default=no]: yes
IP address or FQDN of an existing cluster node: 185.213.165.80
typing your password on server1
All existig data is lost when joining a cluster, continue yes


lxc cluster list

```

### server2
```
root@lxc-lxd2:~# lxd init
Would you like to use LXD clustering? (yes/no) [default=no]: yes
What IP address or DNS name should be used to reach this node? [default=185.213.165.49]:
Are you joining an existing cluster? (yes/no) [default=no]: yes
Do you have a join token? (yes/no) [default=no]:
What name should be used to identify this node in the cluster? [default=lxc-lxd2]:
IP address or FQDN of an existing cluster member: 185.213.165.80
Cluster fingerprint: 8497e9e398f0c20c2f8e60cb23f1c0554e659b7373dc53b49b5075480116d02d
You can validate this fingerprint by running "lxc info" locally on an existing node.
Is this the correct fingerprint? (yes/no) [default=no]: yes
Cluster trust password:
Invalid input, try again.

Cluster trust password:
All existing data is lost when joining a cluster, continue? (yes/no) [default=no] yes
Choose "size" property for storage pool "default":
Choose "source" property for storage pool "default":
Choose "zfs.pool_name" property for storage pool "default": ^C
root@lxc-lxd2:~# lxd init
Would you like to use LXD clustering? (yes/no) [default=no]: yes
What IP address or DNS name should be used to reach this node? [default=185.213.165.49]:
Are you joining an existing cluster? (yes/no) [default=no]: yes
Do you have a join token? (yes/no) [default=no]:
What name should be used to identify this node in the cluster? [default=lxc-lxd2]:
IP address or FQDN of an existing cluster member: 185.213.165.80
Cluster fingerprint: 8497e9e398f0c20c2f8e60cb23f1c0554e659b7373dc53b49b5075480116d02d
You can validate this fingerprint by running "lxc info" locally on an existing node.
Is this the correct fingerprint? (yes/no) [default=no]:
Error: User aborted configuration
root@lxc-lxd2:~# lxd init
Would you like to use LXD clustering? (yes/no) [default=no]: yes
What IP address or DNS name should be used to reach this node? [default=185.213.165.49]:
Are you joining an existing cluster? (yes/no) [default=no]: yes
Do you have a join token? (yes/no) [default=no]:
What name should be used to identify this node in the cluster? [default=lxc-lxd2]:
IP address or FQDN of an existing cluster member: 185.213.165.80
Cluster fingerprint: 8497e9e398f0c20c2f8e60cb23f1c0554e659b7373dc53b49b5075480116d02d
You can validate this fingerprint by running "lxc info" locally on an existing node.
Is this the correct fingerprint? (yes/no) [default=no]: yes
Cluster trust password:
All existing data is lost when joining a cluster, continue? (yes/no) [default=no] yes
Choose "size" property for storage pool "default":
Choose "source" property for storage pool "default":
Choose "zfs.pool_name" property for storage pool "default":
Choose "source" property for storage pool "local":
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]: yes
config: {}
networks: []
storage_pools: []
profiles: []
cluster:
  server_name: lxc-lxd2
  enabled: true
  member_config:
  - entity: storage-pool
    name: default
    key: size
    value: ""
    description: '"size" property for storage pool "default"'
  - entity: storage-pool
    name: default
    key: source
    value: ""
    description: '"source" property for storage pool "default"'
  - entity: storage-pool
    name: default
    key: zfs.pool_name
    value: ""
    description: '"zfs.pool_name" property for storage pool "default"'
  - entity: storage-pool
    name: local
    key: source
    value: ""
    description: '"source" property for storage pool "local"'
  cluster_address: 185.213.165.80:8443
  cluster_certificate: |
    -----BEGIN CERTIFICATE-----
    MIICBzCCAY2gAwIBAgIRAOsEtVCxSB+SaRGqU95j6I8wCgYIKoZIzj0EAwMwNTEc
    MBoGA1UEChMTbGludXhjb250YWluZXJzLm9yZzEVMBMGA1UEAwwMcm9vdEBseGMt
    bHhkMB4XDTIzMDcyOTA4NDYyMFoXDTMzMDcyNjA4NDYyMFowNTEcMBoGA1UEChMT
    bGludXhjb250YWluZXJzLm9yZzEVMBMGA1UEAwwMcm9vdEBseGMtbHhkMHYwEAYH
    KoZIzj0CAQYFK4EEACIDYgAEoOFm0HJjMM9NA26siD1PSxBzRmEkKUcvyMcXvDdX
    GUkgdspYLd5mHwH3WYao2W8pQQJmLytPIYCEwr8cn3ovp+EvZ93nNZVFOVR0tRzT
    2ACGYY4Wv6ApBw4LFj0hhAEBo2EwXzAOBgNVHQ8BAf8EBAMCBaAwEwYDVR0lBAww
    CgYIKwYBBQUHAwEwDAYDVR0TAQH/BAIwADAqBgNVHREEIzAhggdseGMtbHhkhwR/
    AAABhxAAAAAAAAAAAAAAAAAAAAABMAoGCCqGSM49BAMDA2gAMGUCMQDjY1/USiER
    xKw+/bkk4v0/DduFFEJnPbgwGvIl+sVl7CgDkXUt405pu0y1AwpjV3ICMGqRk9fK
    LXluQdHsroSyo/wo9rFpV/Ry+CF9Z/v/6GZ67zHhxZvPdJShr4SVDrplRg==
    -----END CERTIFICATE-----
  server_address: 185.213.165.49:8443
  cluster_password: ""
  cluster_certificate_path: ""
  cluster_token: ""
```

```
lxc cluster list
lxc image list
lxc init ubuntu:20.04 myvm
lxc list
lxc start myvm
ssh server2
lxc list
lxc image list

lxc init ubuntu:20.04 myvm3

lxc ubuntu:20.04 myvm --target lxc-lxd # host or server

lxc init ubuntu:18.04 myvm4

lxc exec myvm bash



```

## getting information from interface

```
lxc network list
lxc network show lxdfan0

lxc network edit lxdfan0
```

```
### This is a YAML representation of the network.
### Any line starting with a '# will be ignored.
###
### A network consists of a set of configuration items.
###
### An example would look like:
### name: lxdbr0
### config:
###   ipv4.address: 10.62.42.1/24
###   ipv4.nat: true
###   ipv6.address: fd00:56ad:9f7a:9800::1/64
###   ipv6.nat: true
### managed: true
### type: bridge
###
### Note that only the configuration can be changed.

config:
  bridge.mode: fan
  fan.underlay_subnet: 185.213.165.0/24
  ipv4.nat: "true"
description: ""
name: lxdfan0
type: bridge
used_by:
- /1.0/profiles/default
- /1.0/instances/my-container
- /1.0/instances/myvm
managed: true
status: Created
locations:
- lxc-lxd
- lxc-lxd2

```

* NOte: if you want to change IP you can use up command line arguments

```
lxc delete -f myvm3

```




