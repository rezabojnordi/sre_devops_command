
## requrement for cephadm
```
apt update
apt dist-upgrade
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```
## install ceph
```

cd /tmp
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

```
ssh mon2
ssh mon3
```

## after than you must add ip address to host in ther Servers
```
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
```
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
```

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

## network cluster

```
cat <<EOF > /root/ceph.conf
 [global]
 public network = 172.16.112.0/22
 cluster network = 172.20.104.0/24
  EOF
 ```
```

cephadm bootstrap -c /root/ceph.conf --mon-ip 172.16.112.110
```

## Add host

```

ssh-copy-id -f -i /etc/ceph/ceph.pub root@mon2
ssh-copy-id -f -i /etc/ceph/ceph.pub root@mon3
ssh-copy-id -f -i /etc/ceph/ceph.pub root@osd1
ssh-copy-id -f -i /etc/ceph/ceph.pub root@osd2
ssh-copy-id -f -i /etc/ceph/ceph.pub root@osd3
```
## The new node is Ceph Part of the cluster

```

cephadm shell -- ceph config set mon public_network 172.16.112.0/22
cephadm shell -- ceph config set mon cluster_network 172.20.104.0/24
```
## Or through YAML file , have access to ceph orch apply -i host.yml Add many hosts at a time
```
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
```

cephadm shell -- ceph orch host label add mon1 mon
cephadm shell -- ceph orch host label add mon2 mon
cephadm shell -- ceph orch host label add mon3 mon
```

## check hosts in ceph structure
```
ceph orch host ls
```

## update schedule in cephadm 

```
ceph orch apply mon 5

ceph orch apply mon"mon1,mon2,mon3"
```

## cehck status in cephadm 

```
cephadm shell -- ceph status
```

## add osd in ceph cluster
```
cephadm shell -- ceph orch host add osd1
cephadm shell -- ceph orch host add osd2
cephadm shell -- ceph orch host add osd3
```

## add monitor in ceph cluster

```

cephadm shell -- ceph orch host label add  osd1 osd
cephadm shell -- ceph orch host label add  osd2 osd
cephadm shell -- ceph orch host label add  osd3 osd
```

## search cluster for find new osd

```
cephadm shell -- ceph orch apply osd --all-available-devices
```

## List disk devices
```
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
