# README — ZFS RAID10 (Striped Mirrors) for Blockchain Data

**Disks (example):** `/dev/nvme2n1` `/dev/nvme3n1` `/dev/nvme4n1` `/dev/nvme5n1`
**Minimum disks:** **4** (even number)
**Fault tolerance:** 1 disk per mirror vdev (e.g., up to 2 if failures are in different mirrors)
**Mountpoint:** `/data`
**Compression:** `lz4`
⚠️ **Destructive:** All data on the listed disks will be erased.

> If your extra disks aren’t exactly `/dev/nvme4n1` and `/dev/nvme5n1`, replace them with the correct device paths before running.

---

## 1) Wipe old signatures (optional but recommended)

```bash
sudo wipefs -a /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1
```

## 2) Create a RAID10-like ZFS pool (striped mirrors) mounted at `/data`

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
  mirror /dev/nvme2n1 /dev/nvme3n1 \
  mirror /dev/nvme4n1 /dev/nvme5n1
```

**Option summary:**

* `-f` force create (overwrites leftovers)
* `ashift=12` 4KiB alignment (best for NVMe/SSD)
* `autotrim=on` enable TRIM for SSDs
* `compression=lz4` fast, lightweight compression
* `atime=off` fewer writes (better performance)
* `xattr=sa` store xattrs in inodes (perf/space)
* `acltype=posixacl` POSIX ACL support
* `-m /data` mountpoint for the pool’s root dataset
* two `mirror` vdevs striped together → RAID10 behavior

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

## 5) (Optional) Give ownership of /data to your user

```bash
sudo chown -R "$USER:$USER" /data
```

## 6) Tear down (only if you want to rebuild)

```bash
sudo zpool destroy chainpool
```

**Notes:**

* RAID10 offers strong IOPS and resilience; usable capacity equals the sum of one disk in each mirror pair.
* Prefer persistent device paths in production: `/dev/disk/by-id/...`.
* Run periodic scrubs: `sudo zpool scrub chainpool`.
