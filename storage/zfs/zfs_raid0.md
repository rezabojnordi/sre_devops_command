# ZFS RAID0 Pool for Blockchain Data — Quick README

**Purpose:** Create a ZFS **RAID0 (stripe)** pool on two NVMe drives, mount it at `/data`, enable **lz4** compression, and add a dataset tuned for blockchain databases.
⚠️ **Destructive:** These steps **erase all data** on `/dev/nvme2n1` and `/dev/nvme3n1`.

---

## 1) Wipe old signatures (optional but recommended)

```bash
sudo wipefs -a /dev/nvme2n1 /dev/nvme3n1
```

* `wipefs -a` removes existing filesystem/RAID signatures so ZFS can claim the disks cleanly.

---

## 2) Create the ZFS pool (RAID0) mounted at `/data`

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
  /dev/nvme2n1 /dev/nvme3n1
```

**What the options mean:**

* `zpool create` — create a new ZFS storage pool.
* `-f` — force creation (overwrites any leftovers on the disks).
* `-o ashift=12` — 4 KiB sector alignment, optimal for SSD/NVMe.
* `-o autotrim=on` — enable continuous TRIM for SSD/NVMe longevity/perf.
* `-O compression=lz4` — enable fast, lightweight compression by default.
* `-O atime=off` — don’t update last-access time; reduces write I/O.
* `-O xattr=sa` — store extended attributes in inodes (space/perf win).
* `-O acltype=posixacl` — POSIX ACL support if you need fine-grained perms.
* `-m /data` — mountpoint for the root dataset of the pool.
* `chainpool` — the pool name (you can change it if desired).
* Listing multiple disks without a vdev keyword (`mirror`/`raidz`) creates a **stripe (RAID0)** across them.

---

## 3) Create a dataset optimized for blockchain DBs

```bash
sudo zfs create chainpool/chain
sudo zfs set recordsize=16K chainpool/chain
sudo zfs set compression=lz4 chainpool/chain
sudo zfs set atime=off chainpool/chain
```

* `zfs create chainpool/chain` — dataset at `/data/chain`.
* `recordsize=16K` — good starting point for LevelDB/RocksDB-like workloads.
* `compression=lz4` — reinforces lz4 on this dataset.
* `atime=off` — avoids extra metadata writes.

---

## 4) Verify

```bash
zpool status
zpool list
zfs list
df -h /data
zfs get compressratio chainpool/chain
```

* `zpool status` — health & layout (should show 2 devices in a stripe).
* `zpool list` — capacity/alloc/frag.
* `zfs list` — datasets and mountpoints.
* `df -h /data` — mounted size/usage.
* `zfs get compressratio` — check compression effectiveness over time.

---

## 5) Tear down (if you need to rebuild)

```bash
sudo zpool destroy chainpool
```

Destroys the pool and all datasets (data lost). Use only if you want to recreate from scratch.

---

## Notes

* **RAID0 risk:** If **either** NVMe fails, the **entire** pool is lost. Keep backups or be ready to re-sync your blockchain data.
* For production, consider ECC RAM and regular `zpool scrub` runs.
