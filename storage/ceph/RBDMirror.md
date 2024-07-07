## Deploying RBD Mirror

Ceph mirroring is asynchronously mirrored between two Ceph storage cluster. It provide data replication between two sites for disaster recovery. By locating a Ceph storage cluster in different geographic locations, RBD Mirroring can help you recover from a site disaster.

### Scope

Setting up a one-way mirror between distinct Ceph clusters: one cluster acts as the source, and the other is the backup.
* Create Ceph cluster (site-a and site-b)
* Deploy rbd-mirror on site-b
* Enable Journaling feature
* Enable mirroring mode on both sites
* Create access token for peers
* Test replication/mirroring

### Create ceph cluster

I’ve two servers and I’m creating two ceph clusters ceph1 and ceph2 using loop device as a OSDs. If you have physical disk you can use them.
Following process apply on both servers ceph1 and ceph2 (change –mon-ip according servers ip)


```bash
curl --silent --remote-name --location https://github.com/ceph/ceph/raw/quincy/src/cephadm/cephadm
chmod 700 cephadm
./cephadm add-repo --release quincy
./cephadm install
cephadm bootstrap --mon-ip 10.30.50.21 --allow-fqdn-hostname 
```

### Create fake OSD using loop device


#### Create fake OSD using loop device

```bash
$ fallocate -l 100G 100G-DISK-0.img
$ fallocate -l 100G 100G-DISK-1.img
$ fallocate -l 100G 100G-DISK-3.img

$ losetup -fP 100G-DISK-0.img
$ losetup -fP 100G-DISK-1.img
$ losetup -fP 100G-DISK-3.img

# find out loopX number in lsblk or fdisk command output. 
$ pvcreate /dev/loop0
$ pvcreate /dev/loop1
$ pvcreate /dev/loop2

$ vgcreate CEPH-VG /dev/loop0 /dev/loop1 /dev/loop2

$ lvcreate --size 99G --name CEPH-LV-0 CEPH-VG
$ lvcreate --size 99G --name CEPH-LV-1 CEPH-VG
$ lvcreate --size 99G --name CEPH-LV-2 CEPH-VG 
```

#### Add lvm disk to ceph

```
$ ceph orch daemon add osd ceph1:/dev/CEPH-VG/CEPH-LV-0
$ ceph orch daemon add osd ceph1:/dev/CEPH-VG/CEPH-LV-1
$ ceph orch daemon add osd ceph1:/dev/CEPH-VG/CEPH-LV-2 
```

#### Verify OSDs
```
$ ceph osd tree
ID  CLASS  WEIGHT   TYPE NAME       STATUS  REWEIGHT  PRI-AFF
-1         0.29005  root default
-3         0.29005      host ceph1
 0    ssd  0.09668          osd.0       up   1.00000  1.00000
 1    ssd  0.09668          osd.1       up   1.00000  1.00000
 2    ssd  0.09669          osd.2       up   1.00000  1.00000 
```

By default, the crush map tells Ceph to replicate the PGs into different hosts. Let’s change crushmap to use replication to osd instead hosts.

```bash
 $ ceph osd getcrushmap -o crushmap.cm
 $ crushtool --decompile crushmap.cm -o crushmap.txt 
```

#### Edit crushmap.txt file to change replicated_rule to osd.
```bash
 # rules
rule replicated_rule {
       id 0
       type replicated
       min_size 1
       max_size 10
       step take default
       step chooseleaf firstn 0 type osd # <---- REPLACE HERE FROM host TO osd
       step emit
} 

```

#### Recompile the crush map:

```
$ crushtool --compile crushmap.txt -o new_crushmap.cm
$ ceph osd setcrushmap -i new_crushmap.cm 
```


#### Check ceph status. It should be HEALTH_OK

```bash

$ ceph -s
  cluster:
    id:     8f982712-b4e0-11ee-9dc5-c1ca68d609fa
    health: HEALTH_OK

  services:
    mon:        1 daemons, quorum ceph1 (age 19h)
    mgr:        ceph1.bwbexu(active, since 19h)
    osd:        3 osds: 3 up (since 18h), 3 in (since 18h)
    rbd-mirror: 1 daemon active (1 hosts)

  data:
    pools:   5 pools, 129 pgs
    objects: 39 objects, 451 KiB
    usage:   892 MiB used, 296 GiB / 297 GiB avail
    pgs:     129 active+clean

  io:
    client:   2.0 KiB/s rd, 2 op/s rd, 0 op/s wr 
```

#### Create “vms” pool on both sites. (We will use this pool for rbd-mirroring)

```bash
$ ceph osd pool create vms
$ rbd pool init vms 

```

### Deploy rbd-mirror daemon (site-b)
#### Deploy rbd-mirror daemon using cephadm on site-b only


```bash
[site-b]$ ceph orch apply rbd-mirror --placement=ceph2 
```

#### Verify rbd-mirror daemon


```bash 
[site-b]$ ceph orch ps | grep rbd-mirror
rbd-mirror.ceph2.ghmncx  ceph2               running (17h)     9m ago  17h    74.2M        -  17.2.7   4c9b44e95067  d509b0a4d145
```

### Enable journaling on site-a
To enable journaling on all new images by default, set the configuration parameter using ceph config set command.


```bash
[site-a]$ ceph config set global rbd_default_features 125
[site-a]$ ceph config show mon.ceph1 rbd_default_features
125 
```


#### Enable mirroring mode on both sites

```bash
Choose the mirroring mode, either pool or image mode, on both the storage clusters. (In our example we will set pool mode on “vms” pool)
```

```
[site-a]$ rbd mirror pool enable vms pool
[site-b]$ rbd mirror pool enable vms pool 
```

Check mirror status on both sites. (If you notice Peer status is: none, Because we didn’t form authentication yet)

```
[site-a]$ rbd mirror pool info vms
Mode: pool
Site Name: 94b146f9-9ef3-4a89-bff1-9746a75d0629

Peer Sites: none 
```

#### Create Access token for peers
Create Ceph user accounts, and register the storage cluster peer to the pool, This example bootstrap command creates the client.rbd-mirror.site-a and the client.rbd-mirror-peer Ceph users.

```
[site-a]$ rbd mirror pool peer bootstrap create --site-name site-a vms > /root/bootstrap_token_site-a 
```

Copy the bootstrap token file (bootstrap_token_site-a) to the site-b storage cluster.

```
[site-b]$ rbd mirror pool peer bootstrap import --site-name site-b --direction rx-only vms /root/bootstrap_token_site-a 
```

### Verify rbd mirror pool status on both sites.

```bash
[site-a]$ rbd mirror pool info vms
Mode: pool
Site Name: site-a

Peer Sites:

UUID: 25925ad3-bb27-4d08-8a70-abd79b3ffb49
Name: site-b
Mirror UUID: 94b146f9-9ef3-4a89-bff1-9746a75d0629
Direction: tx-only 
```

```bash
[site-b]$ rbd mirror pool info vms
Mode: pool
Site Name: site-b

Peer Sites:

UUID: f51a62f1-c176-4ca6-b38f-56afbc822f0a
Name: site-a
Direction: rx-only
Client: client.rbd-mirror-peer 
```


### Test RBD Mirroring
Create test file on ceph1 (site-a)

```
[site-a]$ rbd create myfile1 --size 1024 --pool vms 
```


Verify on ceph2 (site-b). Voilla!!!

```
[site-b]$ rbd -p vms ls
myfile1 
```

### Check health status of mirror replaying on both sites.

```bash
$ rbd mirror pool status vms
health: OK
daemon health: OK
image health: OK
images: 1 total
    1 replaying 
```

NOTES: Journaling doesn’t apply to old and existing files. You can enable journal manually on old files.

```bash
[site-a]$ rbd feature enable vms/myoldfiles1 journaling 
```

