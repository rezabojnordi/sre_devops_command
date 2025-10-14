# README — ZFS RAID1 (Mirror) for Blockchain Data

**Disks:** `/dev/nvme2n1` and `/dev/nvme3n1`
**Fault tolerance:** 1 disk can fail
**Mountpoint:** `/data`
**Compression:** `lz4`
⚠️ **Destructive:** All data on the listed disks will be erased.

---

## 1) Wipe old signatures (optional but recommended)

```bash
sudo wipefs -a /dev/nvme2n1 /dev/nvme3n1
```

## 2) Create a mirrored ZFS pool mounted at `/data`

```bash
sudo zpool create -f \
  -o ashift=12 \
  -o autotrim=on \
  -O compression=lz4 \
  -O atime=off \
  -O xattr=sa \
  -O acltype=posixacl \
  -m /data \
  chainpool \
  mirror /dev/nvme2n1 /dev/nvme3n1
```

**Options:**

* `-f` force create (overwrites leftovers)
* `ashift=12` 4KiB alignment (best for NVMe/SSD)
* `autotrim=on` enable TRIM for SSDs
* `compression=lz4` fast, lightweight compression
* `atime=off` fewer writes (better performance)
* `xattr=sa` store xattrs in inodes (perf/space)
* `acltype=posixacl` POSIX ACL support
* `-m /data` mountpoint for the pool’s root dataset
* `mirror …` build RAID1 over the two NVMe devices

## 3) Create a dataset optimized for blockchain DBs

```bash
sudo zfs create chainpool/chain
sudo zfs set recordsize=16K chainpool/chain
sudo zfs set compression=lz4 chainpool/chain
sudo zfs set atime=off chainpool/chain
```

* `recordsize=16K` is a good starting point for LevelDB/RocksDB workloads.

## 4) Verify

```bash
zpool status
zpool list
zfs list
df -h /data
zfs get compressratio chainpool/chain
```

## 5) (Optional) Ownership for your user

```bash
sudo chown -R "$USER:$USER" /data
```

## 6) Tear down (only if you want to rebuild)

```bash
sudo zpool destroy chainpool
```

**Notes:**

* Consider using `/dev/disk/by-id/...` paths for stability across reboots.
* Run periodic scrubs: `sudo zpool scrub chainpool`.
* RAID1 halves raw capacity but gives resilience and steady IOPS.
