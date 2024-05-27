
## requrement for cephadm
```
apt update
apt dist-upgrade
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```
## install ceph

#### version reef

``` bash
CEPH_RELEASE=18.2.0 # replace this with the active release
curl --silent --remote-name --location https://download.ceph.com/rpm-${CEPH_RELEASE}/el9/noarch/cephadm

chmod +x cephadm
./cephadm add-repo --release reef
./cephadm install
which cephadm
```

#### version quincy
```bash
curl --silent --remote-name --location https://github.com/ceph/ceph/raw/quincy/src/cephadm/cephadm
chmod +x cephadm
sudo ./cephadm add-repo --release quincy
sudo rm /etc/apt/trusted.gpg.d/ceph.release.gpg
wget https://download.ceph.com/keys/release.asc
sudo apt-key add release.asc
sudo apt update
sudo ./cephadm install
cephadm shell -- -s
cephadm shell -- ceph -s

add ceph common tools
cephadm add-repo --release quincy
cephadm install ceph-common
-------------------------------------
```
#### or version pacific
```bash
curl --silent --remote-name --location https://github.com/ceph/ceph/raw/pacific/src/cephadm/cephadm
chmod +x cephadm
sudo ./cephadm add-repo --release pacific

sudo rm /etc/apt/trusted.gpg.d/ceph.release.gpg
wget https://download.ceph.com/keys/release.asc
sudo apt-key add release.asc
sudo apt update
sudo ./cephadm install
cephadm shell -- -s
cephadm shell -- ceph -s

add ceph common tools
cephadm add-repo --release pacific
cephadm install ceph-common
-------------------------------------
```


## install cephadm in other monitor's servera

```bash
ssh mon2
ssh mon3
```

## after than you must add ip address to host in ther Servers
```bash
vim /etc/hosts
172.16.112.110 mon1
172.16.112.111 mon2
172.16.112.112 mon3
172.16.112.113 osd1
172.16.112.115 osd2
172.16.112.116 osd3

-----------------------------------------
```

## you must create directory ceph in all of server
```bash
mkdir -p /etc/ceph
-----------------------------------------
```
## Create a new cluster
This command will ：

* 1)  Create monitor and manager daemons on the local host for the new cluster

* 2)  by Ceph The cluster generates a new SSH secret key , And add it to root User /root/.ssh/authorized_keys In file

* 3)  Write the minimum configuration file to /etc/ceph/ceph.conf

* 4)  take client.admin Manage privileged key write /etc/ceph/ceph.client.admin.keyring

* 5)  Write the public key to /etc/ceph/ceph.pub

```
cephadm bootstrap --mon-ip 172.16.112.110
```bash

# you can conenct openstack with ceph storage
```
ceph osd pool create cinder-volumes 128
ceph osd pool create images 128
ceph osd pool create backups 128
ceph osd pool create vms 128

rbd pool init cinder-volumes

ssh 172.16.104.101 sudo tee /etc/ceph/ceph.conf </etc/ceph/ceph.conf
cat ~/.ssh/id_rsa.pub
ssh 172.16.104.101 sudo tee /etc/ceph/ceph.conf </etc/ceph/ceph.conf
ssh 172.16.104.102 sudo tee /etc/ceph/ceph.conf </etc/ceph/ceph.conf
ssh 172.16.104.103 sudo tee /etc/ceph/ceph.conf </etc/ceph/ceph.conf
ssh 172.16.104.104 sudo tee /etc/ceph/ceph.conf </etc/ceph/ceph.conf
ceph auth get-or-create client.cinder mon 'profile rbd' osd 'profile rbd pool=cinder-volumes, profile rbd pool=vms, profile rbd pool=images'


ls
#ceph auth get-or-create client.cinder mon 'profile rbd' osd 'profile rbd pool=cinder-volumes, profile rbd pool=vms, profile rbd pool=images'
ls
cat ceph.client.admin.keyring
ceph auth get-or-create client.cinder | ssh 172.16.104.110 sudo tee /etc/ceph/ceph.client.cinder.keyring
ls

ceph auth get-or-create client.glance mon 'profile rbd' osd 'profile rbd pool=images' mgr 'profile rbd pool=images'
ceph auth get-or-create client.glance | ssh {your-glance-api-server} sudo tee /etc/ceph/ceph.client.glance.keyring

cat ceph.client.cinder.keyring
vim ceph.client.cinder.keyring
cat ~/.ssh/id_rsa.pub
vim ceph.client.cinder.keyring
scp * mon2:/etc/ceph/
scp * mon3:/etc/ceph/
scp * osd1:/etc/ceph/
scp * osd2:/etc/ceph/
scp * osd3:/etc/ceph/
sudo rbd pool init cinder-volumes
sudo ceph osd pool application enable cinder-volumes rbd
ceph -s

#---------------

[client.cinder]
        key = AQCeaINhnOSuKBAAaWLlNUbqrJ3lQjgKHajUhg==
                caps mds = "allow *"
                caps mgr = "allow *"
                caps mon = "allow *"
                caps osd = "allow *"
#----------------------------------
```
```bash

## network cluster

```bash
cat <<EOF > /root/ceph.conf
 [global]
 public network = 172.16.112.0/22
 cluster network = 172.20.104.0/24
  EOF
 ```
```bash

cephadm bootstrap -c /root/ceph.conf --mon-ip 172.16.112.110
```

## Add host

```bash

ssh-copy-id -f -i /etc/ceph/ceph.pub root@mon2
ssh-copy-id -f -i /etc/ceph/ceph.pub root@mon3
ssh-copy-id -f -i /etc/ceph/ceph.pub root@osd1
ssh-copy-id -f -i /etc/ceph/ceph.pub root@osd2
ssh-copy-id -f -i /etc/ceph/ceph.pub root@osd3
```
## The new node is Ceph Part of the cluster

```bash

cephadm shell -- ceph config set mon public_network 172.16.112.0/22
cephadm shell -- ceph config set mon cluster_network 172.20.104.0/24
```
## Or through YAML file , have access to ceph orch apply -i host.yml Add many hosts at a time
```bash
cephadm shell -- ceph orch host add mon2
cephadm shell -- ceph orch host add mon3
cephadm shell -- ceph orch apply mon --unmanaged

or

host.yml
---
service_type: host
addr: 192.168.100.133
hostname: ceph02
labels:
  - ceph02_mon
---
service_type: host
addr: 192.168.100.134
hostname: ceph03
labels:
  - ceph03_mon

```

## you can add lable for Servers
```bash

cephadm shell -- ceph orch host label add mon1 mon
cephadm shell -- ceph orch host label add mon2 mon
cephadm shell -- ceph orch host label add mon3 mon
```

## add new mgr
```bash
ceph orch apply mgr mon3
```
## check hosts in ceph structure
```bash
ceph orch host ls
```

## update schedule in cephadm

```bash
ceph orch apply mon 5

ceph orch apply mon"mon1,mon2,mon3"
```

## cehck status in cephadm

```bash
cephadm shell -- ceph status
```

## add osd in ceph cluster
```bash
cephadm shell -- ceph orch host add osd1
cephadm shell -- ceph orch host add osd2
cephadm shell -- ceph orch host add osd3
```

## add monitor in ceph cluster

```bash

cephadm shell -- ceph orch host label add  osd1 osd
cephadm shell -- ceph orch host label add  osd2 osd
cephadm shell -- ceph orch host label add  osd3 osd
```

## search cluster for find new osd

```bash
cephadm shell -- ceph orch apply osd --all-available-devices
```

## List disk devices
```bash
ceph orch device ls [--wide]
```


##### 6.2.2 Create... On a specific device on a specific host OSD

```
ceph orch daemon add osd *<host>*:*<device-path>*

ceph orch daemon add osd ceph01:/dev/sdb

```


##### If all of the following conditions are met , The storage device is considered available

* 1)  The device must have no partitions
* 2)  The equipment must not have any LVM state
* 3)  The device must not be mounted
* 4)  The device must not contain a file system
* 5)  The equipment must not contain Ceph BlueStore OSD
* 6)  The device must be larger than 5 GB


## dashboard address
```
https://<your-pulic-ip>:8443/
```

### Use ceph-volume Query disk information
```
ceph-volume inventory /dev/sdb

```
---------------------------------------------------

### Deploy RGW
Cephadm take radosgw Deploy as a collection of daemons , These daemons manage specific domains and areas in a single cluster or multi site deployment .

Please note that , Use cephadm when ,radosgw The daemons configure the database through the monitor, not through ceph.conf Or the command line . The configuration is ready if （ Usually in client.rgw.<something> In the part ）, that radosgw The daemons will use the default settings （ for example , Bind to port 80） start-up .

```
 ceph orch daemon add rgw default default --port=7480 --placement="3 ceph01 ceph02 ceph03"
```

## Show all pools
```
ceph osd pool ls
```

## Delete

```

ceph orch daemon rm rgw.default.default.ceph01.wyxsgr
ceph orch daemon rm rgw.default.default.ceph02.ppjddy
ceph orch daemon rm rgw.default.default.ceph03.wbacub

systemctl stop ceph-87cdd3b2-987b-11eb-989e-000c29b12ae1@rgw.default.default.ceph01.wyxsgr
systemctl stop ceph-87cdd3b2-987b-11eb-989e-000c29b12ae1@rgw.default.default.ceph02.ppjddy
systemctl stop ceph-87cdd3b2-987b-11eb-989e-000c29b12ae1@rgw.default.default.ceph03.wbacub

rm -f /etc/systemd/system/ceph-87cdd3b2-987b-11eb-989e-000c29b12ae1.target.wants/ceph-87cdd3b2-987b-11eb-989e-000c29b12ae1\@rgw.default.default.ceph01.wyxsgr.service
rm -f /etc/systemd/system/ceph-87cdd3b2-987b-11eb-989e-000c29b12ae1.target.wants/ceph-87cdd3b2-987b-11eb-989e-000c29b12ae1\@rgw.default.default.ceph02.ppjddy.service
rm -f /etc/systemd/system/ceph-87cdd3b2-987b-11eb-989e-000c29b12ae1.target.wants/ceph-87cdd3b2-987b-11eb-989e-000c29b12ae1\@rgw.default.default.ceph03.wbacub.service


ceph osd pool rm .rgw.root .rgw.root --yes-i-really-really-mean-it
ceph osd pool rm default.rgw.log default.rgw.log --yes-i-really-really-mean-it
ceph osd pool rm default.rgw.control default.rgw.control --yes-i-really-really-mean-it
ceph osd pool rm default.rgw.meta default.rgw.meta --yes-i-really-really-mean-it

```

## Deploy mds

To use CephFS file system , Need one or more MDS A daemon . If you use the newer ceph fs Volume interface creates a new file system , These file systems are created automatically

```
ceph fs volume create cephfs --placement="3 ceph01 ceph02 ceph03"
```

## Show fs Associated pools
```
ceph fs ls
```

## Delete

```
ceph fs volume rm cephfs --yes-i-really-mean-it
```

## Deploy NFS

Cephadm Use predefined RADOS Pools and optional namespace deployment NFS Ganesha, Support only NFSv4 agreement .

establish nfs pool


```
ceph osd pool create nfs-data 32 32
```

## Associate pool to application

```
ceph osd pool application enable nfs-data cephfs
```

## establish nfs daemon
```
ceph orch daemon add nfs nfs-share nfs-data nfs-ns --placement="1 ceph01"
ceph orch apply nfs nfs-share nfs-data nfs-ns

```

## Dashboard

* To configure Dashboard

* Enable dashboard modular
```
ceph mgr module enable dashboard

```
####  Generate and install self signed certificates
```
ceph dashboard create-self-signed-cert
```

### Create a dashboard Login username password
```
ceph dashboard ac-user-create admin 123456 administrator
```
#### Modify cluster dashboard The interview of IP

```
ceph config-key set mgr/dashboard/server_addr 0.0.0.0
```

### See how the service is accessed
```
ceph mgr services

{
    "dashboard": "https://ceph-87cdd3b2-987b-11eb-989e-000c29b12ae1-mgr.ceph01.gmziaa:8443/"
}
````

### Dashboard Enable rgw

* *establish rgw user
```
radosgw-admin user create --uid=admin --display-name="admin"  --system

...
    "keys": [
        {
            "user": "admin",
            "access_key": "CTQ0CYY7GWGQWQ48VW79",
            "secret_key": "EDRCRzQuaN747USI938iSDdiEVpDnCPelfB01bef"
        }
    ],
```

## Removing a Mon
If you want to remove one of your monitors (maybe a mon is no longer in quorum for some reason or you changed the architecture – run the following commands:
```
sudo ceph mon remove <YOUR_MON>
sudo cephadm rm-daemon --name mon.<YOUR_MON> --fsid <CLUSTER_ID> --force
```
Replace <YOUR_MON> with the name of you node and <CLUSTER_ID> with your ceph cluster id. You can check the status on the corresponding node with:
```
sudo cephadm ls
```
## Removing a Host

If something went wrong or you change your nodes hardware you can remove a ceph host completely from your cluster:

### Remove the OSDs
First delete the disk and than mark the disk as ‘out’ and ‘down’. You can do this from the Web Interface. Removing a Disk can take some time.

### Remove the Monitor
After you have successful removed the OSD you can now remove the monitor

```
sudo ceph mon remove nodeX
```
### Remove the host
Finally you can remove the host form the cluster

```
sudo ceph orch host rm nodeX --force
```

### Purge the Host Data
Now you should also delete the old ceph data on the host to be removed. Otherwise you can not rejoin this node later.
```
sudo rm -R /etc/ceph/
sudo rm -R /var/lib/ceph/
```


### To Troubleshoot This Problem

```
# ceph health detail
HEALTH_WARN 24 pgs stale; 3/300 in osds are down
...
pg 2.5 is stuck stale+active+remapped, last acting [2,0]
...
osd.10 is down since epoch 23, last address 192.168.106.220:6800/11080
osd.11 is down since epoch 13, last address 192.168.106.220:6803/11539
osd.12 is down since epoch 24, last address 192.168.106.220:6806/11861

```

### Start the deep scrubbing process on the placement group:
```
# ceph pg deep-scrub <id>
#  ceph pg deep-scrub 0.6
```
```
# ceph -w | grep <id>

```

```
# ceph -w | grep 0.6
```

### Unclean Placement Groups

The ceph health command returns an error message similar to the following one:

HEALTH_WARN 197 pgs stuck unclean



# ceph pg <id> query

# ceph pg 0.5 query


```

{ "state": "down+peering",
  ...
  "recovery_state": [
       { "name": "Started\/Primary\/Peering\/GetInfo",
         "enter_time": "2012-03-06 14:40:16.169679",
         "requested_info_from": []},
       { "name": "Started\/Primary\/Peering",
         "enter_time": "2012-03-06 14:40:16.169659",
         "probing_osds": [
               0,
               1],
         "blocked": "peering is blocked due to down osds",
         "down_osds_we_would_probe": [
               1],
         "peering_blocked_by": [
               { "osd": 1,
                 "current_lost_at": 0,
                 "comment": "starting or marking this osd lost may let us proceed"}]},
       { "name": "Started",
         "enter_time": "2012-03-06 14:40:16.169513"}
   ]
}
```

# ceph health detail

```

```
State	What it means	Most common causes	See
inactive

The PG has not been able to service read/write requests.

Peering problems
Section 7.1.4, “Inactive Placement Groups”

unclean

The PG contains objects that are not replicated the desired number of times. Something is preventing the PG from recovering.

unfound objects
OSDs are down
Incorrect configuration
Section 7.1.3, “Unclean Placement Groups”

stale

The status of the PG has not been updated by a ceph-osd daemon.

OSDs are down
Section 7.1.1, “Stale Placement Groups”

```


List the stuck PGs:

# ceph pg dump_stuck inactive
# ceph pg dump_stuck unclean
# ceph pg dump_stuck stale
```




### Ceph fs

#### Adding MDS in linux with ceph

```
ceph orch apply mds test --placement="3 mon1 mon2 mon3"

```


## How to mount directory in cephfs


```
cat ceph.client.admin.keyring
```
* Copy the key of the user who will be using the mounted CephFS filesystem. It should look something like this:
```
[client.admin]
   key = AQCj2YpRiAe6CxAA7/ETt7Hcl9IyxyYciVs47w==
```
* Open a text editor.

* Paste the key into an empty file. It should look something like this:
```
AQCj2YpRiAe6CxAA7/ETt7Hcl9IyxyYciVs47w==
```
* Save the file with the user name as an attribute (e.g., admin.secret).

* Ensure the file permissions are appropriate for the user, but not visible to other users.

```
sudo mount -t ceph 172.16.112.120:6789:/ /mnt/mycephfs -o name=admin,secretfile=admin.secret

```


#### KERNEL DRIVER
* Mount CephFS as a kernel driver.
```
sudo mkdir /mnt/mycephfs
sudo mount -t ceph {ip-address-of-monitor}:6789:/ /mnt/mycephfs
```
* The Ceph Storage Cluster uses authentication by default. Specify a user name and the secretfile you created in the Create a Secret File section. For example:
```
sudo mount -t ceph 192.168.0.1:6789:/ /mnt/mycephfs -o name=admin,secretfile=admin.secret
```

#### FILESYSTEM IN USER SPACE (FUSE)
* Mount CephFS as a Filesystem in User Space (FUSE).

```
sudo mkdir ~/mycephfs
sudo ceph-fuse -m {ip-address-of-monitor}:6789 ~/mycephfs
```
* The Ceph Storage Cluster uses authentication by default. Specify a keyring if it is not in the default location (i.e., /etc/ceph):
```
sudo ceph-fuse -k ./ceph.client.admin.keyring -m 192.168.0.1:6789 ~/mycephfs
```

### Verification
* List the service:
```
ceph orch ls
```

* Check the CephFS status:
```
ceph fs ls
ceph fs status
```

* List the hosts, daemons, and processes:

```
ceph orch ps --daemon_type=DAEMON_NAME
```
* Example
```
ceph orch ps --daemon_type=mds
```

## Removing OSD in the ceph
To remove a failed OSD and add it back to the Ceph cluster, you can follow these steps. Before proceeding, please ensure you have a recent backup of your Ceph cluster, as removing an OSD can result in data redistribution and potential data loss.

Out and Down the OSD:
First, you need to mark the OSD as "out" and "down" in the Ceph cluster to prevent data loss during the removal process. Run the following commands:
```bash
ceph osd out <osd-id>
ceph osd down <osd-id>
```

Replace <osd-id> with the ID of the OSD you want to remove.

Crush Remove and Mark the OSD as 'Out' and 'Lost':
Next, you should remove the OSD from the CRUSH map and mark it as "out" and "lost":

``` bash
ceph osd crush remove osd.<osd-id>
ceph osd lost <osd-id>
```
Remove the OSD from the Cluster:
Once the OSD is marked as "lost," you can safely remove it from the cluster:
```bash
ceph osd rm <osd-id>
```
This command will permanently remove the OSD from the Ceph cluster.

Check the OSD Status:
Ensure that the OSD is no longer present in the cluster by checking the status:
```bash
ceph osd status

```
Re-Create the OSD:
After removing the OSD, you can add it back to the cluster. Use the cephadm utility or the relevant Ceph orchestrator command to create a new OSD on the node where the removed OSD was running. For example, using cephadm:
``` bash
ceph orch apply osd --all-available-devices
```
This command will create new OSDs using all available devices on the node.

Check OSD Status Again:
Verify that the new OSDs are added to the cluster and have a "up" status:
``` bash
ceph osd status
ceph -s
```

### How to fix osd
* Note: osd doen't restart

```
ceph-volume lvm list
ceph osd metadata osd.9
ceph-volume lvm zap --destroy /dev/sdb
```



### adding new storage to the ceph

```

ceph osd set norebalance

cephadm shell -- ceph orch host add new_osd

ceph osd crush ls new_osd

ceph osd crush ls new_osd | xargs -l -I{}  ceph osd crush reweight {} 0

ceph osd unset norebalance

```


### changing reweight on the ceph

```bash
ceph osd df
ceph osd crush reweight osd.402 2.5  # per cluster
ceph osd reweight osd.14 0.9 # if you want to fix trobleshot or manage and mantenance per server
ceph osd tree

ceph osd crush reweight osd.14 9
ceph osd find 14
```
* Find the server on which the disk is placed and find the volume of the disk from the disks on that server

Stop all clients from using the RBD images/Rados Gateway on this cluster. Ensure any other clients are not using this
Cluster.

Ensure all PGs are active+clean by checking ceph -s from an admin node.

From an admin node, set these flags noout, norecover, norebalance, nobackfill, nodown and pause using the
following commands:

Shutdown OSD nodes one by one.
```bash
ceph osd set noout
ceph osd set norecover
ceph osd set norebalance
ceph osd set nobackfill
ceph osd set nodown
ceph osd set pause
```


### trobleshoting ceph

```bash
ceph orch ps
netstat -ntlp
ip -br -c a

ceph orch ls

ceph orch apply osd --all-available-devices --dry-run #simolate

ceph orch status

ceph pg ls

ceph osd pool ls
```

For powering up the Ceph Cluster, follow the steps below in order:
* If network equipment was involved, ensure it is powered on and stable prior to powering on any Ceph hosts/nodes
* Power on the admin node
* Power on the monitor nodes
* Power on the OSD nodes
* Wait for all the nodes to come up , Verify all the services are up and the connectivity is fine between the nodes.
* If on their own nodes, power on the MDS and RGW nodes.
* From an admin node, unset these flags: noout,norecover,noreblance, nobackfill, nodown and pause using the
following commands:


```bash
 ceph osd unset noout

 ceph osd unset norecover

 ceph osd unset norebalance

 ceph osd unset nobackfill

 ceph osd unset nodown

 ceph osd unset pause
 ```

### OSD maintenance,

```bash
sudo docker container exec -it <mon container> bash
ceph osd set noout
```

#### OSD is Down & Storage Node is Down

There are two probable scenarios:
* disk hardware encounters a failure:
* There is no issue with the disk and we need to reboot the server or we went through power failure or etc
* Storage node is Down

* disk hardware encounters a failure:

```
ssh <ceph mon node>
sudo docker container exec -it <mon container> bash
ceph osd find <number>
ceph osd metadata <number> | grep "device"

ssh fr1-storage3001
sudo docker exec -it ceph-mon-fr1-storage3001 bash
ceph osd find osd.64 --cluster ceph-fr1
ceph osd metadata osd.64 --cluster ceph-fr1 | grep "mount"

ssh fr1-storage3104
sudo docker ps -a
sudo docker container logs -f ceph-osd-64
```
* remove manualy osd
```bash
ssh <target storage node>
sudo systemctl | grep ceph
sudo systemctl disable ceph-osd@<number>.service
sudo systemctl stop ceph-osd@<number>.service
sudo rm -rf /var/lib/ceph/osd/ceph-<dc_nam>-<number>
sudo rm -rf /var/run/ceph/ceph-osd.<number>.asok

for instance
ssh fr1-storage3104
sudo systemctl | grep ceph
sudo systemctl disable ceph-osd@64.service
sudo systemctl stop ceph-osd@114.service
rm -rf /var/lib/ceph/osd/ceph-fr1-114
rm -rf/var/run/ceph/ceph-osd.114.asok
```
* Also, you need to zap the lvm by following these commands please heed that you need to do the following for all of the osds
that you tried to purge:
``` bash
#ssh to one of the osd daemons doesn't matter which one
sudo docker container exec -it < osd daemon container > bash
ceph-volume lvm list
ceph-volume lvm zap < devices > --destroy
###example
ssh fr1-storage3022
sudo docker container exec -it ceph-osd-220 bash
ceph-volume lvm zap /dev/sdj --destroy
```

* make sure that the values under REWEIGHT SIZE column are equal to 0 , if they are not equal to 0 there must be some user
data on it by using the command below:

```bash
ssh <ceph mon node>
ceph osd crush reweight {osd-num} {weight}
###example
ssh fr1-storage3001
ceph osd crush reweight 167 0
# Heed that it is better to reweight OSDs in small steps
```
* If you approved that those values are equal to 0 then follow along:

```bash

#make sure that ceph is doing okay and also pay attention to osd counts
ceph -s
#if everything looks good
ceph osd purge <osd.number>
###example
ceph -s --cluster ceph-fr1
ceph osd purge osd.132
```

* Storage node is Down

```bash
ceph osd set noout

```

