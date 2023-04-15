## How to install convoy

```
wget -c https://github.com/rancher/convoy/releases/download/v0.5.2/convoy.tar.gz

cp convoy/convoy convoy/convoy-pdata_tools /usr/local/bin/

```

```
vim etc/systemd/system/convoy.service/

[Unit]
Description=Convoy daemon

[Service]
ExecStart=/usr/local/bin/convoy daemon
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

```
sudo convoy daemon --drivers vfs --driver-opts vfs.path=<vfs_path>
sudo systemctl daemon-reload
sudo systemctl start convoy
sudo systemctl enable convoy
```

```
vim /etc/convoy/convoy.json

{
    "log-level": "debug",
    "log-format": "text",
    "log-file": "/var/log/convoy.log",
    "driver": "vfs",
    "vfs.path": "/storage/volumes"
}# 
```

```
vim convoy.cfg

[Global]
Driver=nfs

[nfs]
MountPoint=/storage/volumes

```

Note:
installing convoy on all swarm node then You must active cnovoy on Docker node

```
vim /etc/docker/plugins/convoy.spec

unix:///var/run/convoy/convoy.sock
```

# Note: Then important command for Convoy On linux
```
convoy list
convoy create
convoy backup
convoy snapshot
```
```
sudo convoy create volume_name

* Device Mapper: Default volume size is 100G. --size option is supported.
* EBS: Default volume size is 4G. --size and some other options are supported.

sudo docker run -it -v test_volume:/test --volume-driver=convoy ubuntu


```
### Delete a Volume
```
sudo convoy delete <volume_name>

or

sudo docker rm -v <container_name>
```
### List and Inspect a Volume
```
sudo convoy list
sudo convoy inspect vol1
```
### Take Snapshot of a Volume
```
sudo convoy snapshot create vol1 --name snap1vol1
```
### Delete a Snapshot
```
sudo convoy snapshot delete snap1vol1
```

### Backup a Snapshot
Device Mapper or VFS: You can backup a snapshot to an NFS mount/local directory or an S3 object store:
```
sudo convoy backup create snap1vol1 --dest vfs:///opt/backup/

or
sudo convoy backup create snap1vol1 --dest s3://backup-bucket@us-west-2/
```


* Once the right Docker daemon version is running, install and configure the Convoy volume plugin as follows:

```
wget https://github.com/rancher/convoy/releases/download/v0.5.2/convoy.tar.gz
tar xvzf convoy.tar.gz
sudo cp convoy/convoy convoy/convoy-pdata_tools /usr/local/bin/
sudo mkdir -p /etc/docker/plugins/
sudo bash -c 'echo "unix:///var/run/convoy/convoy.sock" > /etc/docker/plugins/convoy.spec'
```

## Demo test
You can use a file-backed loopback device to test and demo Convoy Device Mapper driver. A loopback device, however, is known to be unstable and should not be used in production.

```
truncate -s 100G data.vol
truncate -s 1G metadata.vol
sudo losetup /dev/loop5 data.vol
sudo losetup /dev/loop6 metadata.vol
```
Once the data and metadata devices are set up, you can start the Convoy plugin daemon as follows:

```
sudo convoy daemon --drivers devicemapper --driver-opts dm.datadev=/dev/loop5 --driver-opts dm.metadatadev=/dev/loop6
```
You can create a Docker container with a convoy volume. As a test, create a file called /vol1/foo in the Convoy volume:

```
sudo docker run -v vol1:/vol1 --volume-driver=convoy ubuntu touch /vol1/foo
```

## Creating Snapshot as Nfs
```
sudo convoy snapshot create vol1 --name snap1vol1
sudo mkdir -p /opt/convoy/
sudo convoy backup create snap1vol1 --dest vfs:///opt/convoy/
```

### The convoy backup command returns a URL string representing the backup dataset. You can use this URL to recover the volume on another host:

```
sudo convoy create res1 --backup <backup_url>
```
### The following command creates a new container and mounts the recovered Convoy volume into that container:

```
sudo docker run -v res1:/res1 --volume-driver=convoy ubuntu ls /res1/foo
```

## Start Convoy Daemon

```
sudo convoy daemon --drivers devicemapper --driver-opts dm.datadev=/dev/convoy-vg/data --driver-opts dm.metadatadev=/dev/convoy-vg/metadata
```

# NFS
First, mount the NFS share to the root directory used to store volumes. Substitute <vfs_path> with the appropriate directory of your choice:

```
sudo mkdir <vfs_path>
sudo mount -t nfs <nfs_server>:/path <vfs_path>
```
## The NFS-based Convoy daemon can be started as follows:

```
sudo convoy daemon --drivers vfs --driver-opts vfs.path=<vfs_path>
```


## Docker-compose

```
version: "3.6"
services:
 NAME_OF_SERVICE:
   image: YOUR_DESIRED_IMAGE
   ...
   volumes:
     - CONVOY_VOLUME_1:PATH_TO_CONTAINER_DIRECTORY
     - CONVOY_VOLUME_2:PATH_TO_CONTAINER_DIRECTORY
     - CONVOY_VOLUME_3:PATH_TO_CONTAINER_DIRECTORY
...
volumes:
 CONVOY_VOLUME_1:
   driver: convoy
 CONVOY_VOLUME_2:
   driver: convoy
 CONVOY_VOLUME_3:
   driver: convoy
```



## Other source for learning convoy
```
wget https://github.com/rancher/convoy/releases/download/v0.5.0/convoy.tar.gz
tar -xvzf convoy.tar.gz
sudo cp convoy/convoy convoy/convoy-pdata_tools /usr/local/bin/

```

Then setup a communication socket between Docker and Convoy:

```
sudo mkdir -p /etc/docker/plugins/
sudo bash -c 'echo "unix:///var/run/convoy/convoy.sock" > /etc/docker/plugins/convoy.spec'
```
* The next step is to start Convoy and for this we need a specific directory on the distributed file system for instance: /shared/volumes/convoy. Convoy could then be started:

```
sudo convoy daemon --drivers vfs --driver-opts vfs.path=/shared/volumes/convoy
```

* You can then test the volume create either with the convoy command or with docker:
```
# Create with Convoy
sudo convoy create test_volume
# Create a volume explicitly
docker volume ls docker volume create -d convoy test_volume
# Create a volume on the fly
docker run -it -v test_volume:/test --volume-driver=convoy debian

cd /test
ls
date > $HOSTNAM.txt
```

