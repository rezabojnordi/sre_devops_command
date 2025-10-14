# README — ZFS RAID5 (RAIDZ1) for Blockchain Data

**Disks (example):** `/dev/nvme2n1` `/dev/nvme3n1` `/dev/nvme4n1`
**Minimum disks:** **3**
**Fault tolerance:** 1 disk can fail
**Mountpoint:** `/data`
**Compression:** `lz4`
⚠️ **Destructive:** All data on the listed disks will be erased.

> If your third disk path isn’t `/dev/nvme4n1`, replace it with the correct device path before running.

---

## 1) Wipe old signatures (optional but recommended)

```bash
sudo wipefs -a /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1
```

## 2) Create a RAIDZ1 (RAID5-like) ZFS pool mounted at `/data`

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
  raidz1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1
```

**Options (brief):**

* `-f` force create (overwrites leftovers)
* `ashift=12` 4KiB alignment (best for NVMe/SSD)
* `autotrim=on` enable TRIM for SSDs
* `compression=lz4` fast, lightweight compression
* `atime=off` fewer writes (better performance)
* `xattr=sa` store xattrs in inodes (perf/space)
* `acltype=posixacl` POSIX ACL support
* `-m /data` mountpoint for the pool’s root dataset
* `raidz1 ...` create RAIDZ1 (RAID5-like) across the three devices

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

---

### Notes

* RAIDZ1 is space-efficient and tolerates one disk failure. For large-capacity NVMe or higher resiliency, consider **RAIDZ2** (needs ≥4 disks, tolerates two failures).
* Prefer using persistent paths like `/dev/disk/by-id/...` in production to avoid device-name changes after reboots.
* Run periodic scrubs: `sudo zpool scrub chainpool`.
