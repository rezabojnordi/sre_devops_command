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

### Suitability for Mantra Nodes:

During the evaluation, enabling LZ4 compression on ZFS resulted in a **25% reduction in storage usage** for Mantra node data. This significant reduction demonstrates the advantages of using ZFS for blockchain nodes.


