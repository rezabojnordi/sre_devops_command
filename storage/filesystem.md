# Test Process

## Install and Configure dm-compress (if supported)

```bash
sudo apt install dmsetup
sudo dmsetup create compressed --table '0 2048000 compress /dev/sdb lz4'
```

### Format the device with XFS:

```bash
sudo mkfs.xfs /dev/mapper/compressed
```

### Create a mount point:

```bash
sudo mkdir -p /mnt/test_xfs
```

### Mount the filesystem:

```bash
sudo mount /dev/mapper/compressed /mnt/test_xfs
```

### Copy test data:

```bash
cp -r application.db/ blockstore.db/ state.db/ /mnt/test_xfs
```

---

## EXT4

### Overview:

EXT4 is a widely used journaling filesystem known for its stability and backward compatibility with EXT3 and EXT2.

### Key Features:

- Improved performance compared to EXT3.
- Support for large files and volumes (up to 1 EiB).
- Metadata checksumming.

### Compression Methods:

EXT4 does not natively support compression, but the following methods can be used:

- **e2compr (Experimental)**: An extension to enable compression on EXT4, though not officially supported or recommended for production.
- **Application-Level Compression**: Similar to XFS, applications can implement their own compression mechanisms.

### Test Process:

#### Install e2fsprogs for EXT4 tools:

```bash
sudo apt install e2fsprogs
```

#### Enable experimental compression:

```bash
sudo tune2fs -O compress /dev/sdb
```

#### Create a mount point:

```bash
sudo mkdir -p /mnt/test_ext4
```

#### Mount the filesystem:

```bash
sudo mount /dev/sdb /mnt/test_ext4
```

#### Copy test data:

```bash
cp -r application.db/ blockstore.db/ state.db/ /mnt/test_ext4
```

---

## Compression:

ZFS supports multiple compression algorithms, including LZ4, which is lightweight and optimized for speed.

LZ4 compression is particularly effective for datasets with repetitive or compressible data.

### Test Process:

#### Create a ZFS pool:

### Debian12


```
deb http://deb.debian.org/debian bookworm main non-free non-free-firmware contrib
deb http://deb.debian.org/debian bookworm-updates main non-free non-free-firmware contrib
deb http://deb.debian.org/debian-security/ bookworm-security main non-free non-free-firmware contrib
```


```
apt update

```

### Install zfs package on a Debian Linux 12:

```
apt install linux-headers-amd64 zfsutils-linux zfs-dkms zfs-zed
```

### Are you using a cloud server with cloud Linux kernel? Try:

```
apt install linux-headers-cloud-amd64 zfsutils-linux zfs-dkms zfs-zed

```


### Test it by running zfs version command:

```
modprobe zfs #<--load the module
zfs version

```
```bash
sudo apt install build-essential libssl-dev libelf-dev linux-headers-$(uname -r)
git clone https://github.com/openzfs/zfs.git
cd zfs
./autogen.sh
./configure
make
sudo make install

```



```bash
sudo zpool create mypool /dev/sdb
```

#### Enable LZ4 compression:

```bash
sudo zfs set compression=lz4 mypool
```

#### Create a dataset:

```bash
sudo zfs create mypool/test
```

#### Create a mount point:

```bash
sudo mkdir -p /mnt/test_zfs
sudo zfs set mountpoint=/mnt/test_zfs mypool/test
```

#### Copy test data:

```bash
cp -r application.db/ blockstore.db/ state.db/ /mnt/test_zfs
```

#### Verify compression:

```bash
sudo zfs get compressratio mypool
```

**Note:** if you increse the block you can use below command to update zfs 

```
sudo zpool online -e mypool /dev/sdb
```
### Suitability for Mantra Nodes:

During the evaluation, enabling LZ4 compression on ZFS resulted in a **25% reduction in storage usage** for Mantra node data. This significant reduction demonstrates the advantages of using ZFS for blockchain nodes.


