Alright, let’s build you a **Btrfs command cheat sheet** that’s actually usable and as complete as we can get without dumping raw man pages.

🔥 **Key Btrfs Features:**

**Copy-on-Write (CoW)**
When data changes, the old data is *not* overwritten. A new copy is written instead.
Result:

* “Free” snapshots
* Less corruption
* Stronger consistency

---

**Subvolume**
Something between a partition and a folder.
It’s not a normal directory; it’s a filesystem inside a filesystem.

---

**Snapshot**
You “freeze” the current state of a subvolume.
Cost = almost zero
Time = instant
Perfect for backups and rollbacks.

---

**Built-in RAID**
No `mdadm`, no LVM.
Btrfs itself can create RAID0, RAID1, RAID10, etc.

---

**Send/Receive**
Turns a snapshot into a stream and sends it to a second server.
Amazing for incremental backups.

---

**Checksums everywhere**
Every data block and metadata block has a checksum → it detects silent corruption.

You’ll mostly interact with Btrfs through:

* `mkfs.btrfs` – create filesystem
* `mount` (with Btrfs options) – mount/umount
* `btrfs` – the main tool, with many subcommands:

  * `filesystem`, `subvolume`, `device`, `balance`, `scrub`, `send/receive`, `check`, `rescue`, `inspect-internal`, `quota`, `qgroup`, `property`, `replace`, `restore`, …

I’ll group things by **what you want to do** and show **key commands** + notes. At the end I’ll link to docs so you can go deeper. ([btrfs.readthedocs.io][1])

---

## 1. Creating and mounting a Btrfs filesystem

### Create a Btrfs filesystem

```bash
# Single disk
mkfs.btrfs -L mydata /dev/sdX

# Multi-device (e.g. 2 disks as one FS, default data:RAID0, metadata:RAID1)
mkfs.btrfs -L mypool /dev/sdX /dev/sdY

# Force on non-empty device
mkfs.btrfs -f -L mydata /dev/sdX
```

Useful options:

* `-L LABEL` – sets filesystem label
* `-m raid1` – metadata profile (single, dup, raid0, raid1, raid10, raid5, raid6)
* `-d raid1` – data profile

### Mounting Btrfs with useful options

```bash
mount -t btrfs /dev/sdX /mnt

# Using label
mount -t btrfs LABEL=mydata /mnt

# With common options
mount -t btrfs -o noatime,compress=zstd,space_cache=v2 /dev/sdX /mnt
```

Common mount options (Btrfs-specific): ([ArchWiki][2])

* `compress=zstd` (or `zlib`, `lzo`) – transparent compression
* `ssd` / `ssd_spread` – hint for SSD
* `autodefrag` – automatic defrag for small random writes
* `space_cache=v2` – optimized free-space cache
* `subvol=NAME` or `subvolid=ID` – mount specific subvolume
* `discard=async` – TRIM for SSDs (better than `discard` usually)

Unmount:

```bash
umount /mnt
```

---

## 2. Filesystem-level commands: `btrfs filesystem`

These operate on the **whole filesystem**, not just one subvolume.

### Show usage & layout

```bash
# Show space usage (high-level)
btrfs filesystem df /mnt

# More detailed usage including metadata/system
btrfs filesystem usage /mnt
btrfs filesystem usage -T /mnt    # adds table formatting
```

### Resize filesystem online

```bash
# Grow to fill underlying block device
btrfs filesystem resize max /mnt

# Increase by 10 GiB
btrfs filesystem resize +10G /mnt

# Shrink by 20 GiB
btrfs filesystem resize -20G /mnt
```

> Resize applies to the **mounted Btrfs** on that path, not the partition table.

---

## 3. Subvolumes & snapshots: `btrfs subvolume`

Subvolumes = independent trees. Snapshots = subvolumes that start as a copy of another. ([btrfs.readthedocs.io][3])

### List subvolumes

```bash
btrfs subvolume list /mnt
btrfs subvolume list -t /mnt     # show type, parent, etc.
```

### Create subvolumes

```bash
# Create a subvolume (like a “root”)
btrfs subvolume create /mnt/@

# Nested subvolume
btrfs subvolume create /mnt/@home
```

### Snapshots

```bash
# Read-write snapshot
btrfs subvolume snapshot /mnt/@ /mnt/@snap-2025-11-26

# Read-only snapshot (good for backups/send)
btrfs subvolume snapshot -r /mnt/@ /mnt/@snap-ro-2025-11-26
```

### Delete subvolumes/snapshots

```bash
btrfs subvolume delete /mnt/@snap-2025-11-26
```

> You must delete **child subvolumes** before the parent.

### Set default subvolume (for root)

```bash
# Find ID of subvolume you want as default
btrfs subvolume list /mnt

# Set, e.g. ID 256
btrfs subvolume set-default 256 /mnt
```

After this, mounting `/dev/sdX` without `subvol=` will mount that subvolume.

---

## 4. Devices & RAID: `btrfs device`

Btrfs manages **multiple devices inside one filesystem**, including RAID layouts.

### List devices

```bash
btrfs filesystem show
btrfs filesystem show /mnt
```

### Add a device

```bash
btrfs device add /dev/sdY /mnt
```

This adds the device to the pool, but doesn’t automatically rebalance existing data (see `balance`).

### Remove a device

```bash
btrfs device remove /dev/sdY /mnt
# or by device ID
btrfs device remove devid /mnt
```

Btrfs will migrate data off that device (similar to balance).

### Device stats

```bash
btrfs device stats /mnt
```

Shows read/write errors, corruption, etc.

---

## 5. Balancing data: `btrfs balance`

**Balance** = gradually read and re-write chunks to rebalance profiles or free devices.

### Basic balance

```bash
# Full balance (can be heavy on big FS)
btrfs balance start /mnt

# Show status
btrfs balance status /mnt
```

### Profile conversion

```bash
# Convert data to RAID1
btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt

# Convert data back to single
btrfs balance start -dconvert=single -mconvert=single /mnt
```

### Filter small chunks

```bash
# Balance only chunks with more than 50% free space
btrfs balance start -dusage=50 /mnt
```

You can pause/cancel:

```bash
btrfs balance pause /mnt
btrfs balance cancel /mnt
```

---

## 6. Data scrubbing: `btrfs scrub`

**Scrub = verify all data & metadata using checksums and repair if redundant copies exist.**

```bash
# Start scrub in background
btrfs scrub start /mnt

# Scrub specific device in the filesystem
btrfs scrub start /dev/sdX

# Show status
btrfs scrub status /mnt

# Cancel scrub
btrfs scrub cancel /mnt

# Resume scrub
btrfs scrub resume /mnt
```

You should run `scrub` periodically (e.g., monthly) especially with RAID1/10.

---

## 7. Quotas & qgroups: `btrfs quota` and `btrfs qgroup`

Btrfs can limit space used by subvolumes via **quota groups (qgroups)**. ([Wikipedia][4])

### Enable or disable quota support

```bash
btrfs quota enable /mnt
btrfs quota disable /mnt
```

### Show qgroup usage

```bash
btrfs qgroup show /mnt
btrfs qgroup show -pcre /mnt   # detailed (parent/child, limits, etc.)
```

### Set limits

```bash
# Set a 50G limit for qgroup 0/256 (subvolume ID 256)
btrfs qgroup limit 50G /mnt/@
# or explicit
btrfs qgroup limit 50G 0/256 /mnt
```

---

## 8. Send/Receive for backups & replication

Btrfs can generate a **binary stream** of changes between snapshots and replay it elsewhere. ([Wikipedia][4])

### Full send

```bash
# Read-only snapshot recommended
btrfs subvolume snapshot -r /mnt/@ /mnt/@snap-ro-2025-11-26

# Send to file
btrfs send /mnt/@snap-ro-2025-11-26 > /backup/root-2025-11-26.btrfs
```

### Incremental send

```bash
# Base snapshot
btrfs subvolume snapshot -r /mnt/@ /mnt/@snap-ro-2025-11-25

# New snapshot
btrfs subvolume snapshot -r /mnt/@ /mnt/@snap-ro-2025-11-26

# Incremental stream
btrfs send -p /mnt/@snap-ro-2025-11-25 /mnt/@snap-ro-2025-11-26 > /backup/inc-2025-11-26.btrfs
```

### Receive on another machine

```bash
ssh root@backup "btrfs receive /btrfs-backup" < /backup/root-2025-11-26.btrfs
```

---

## 9. Check, repair, rescue

### **WARNING:** Btrfs devs say `btrfs check --repair` is dangerous unless you know what you’re doing or are following expert advice. Use **scrub** and **restore** first. ([Wikipedia][4])

### Offline check (unmounted fs)

```bash
btrfs check /dev/sdX
```

### Repair (last resort)

```bash
btrfs check --repair /dev/sdX
```

Use only if you’ve backed up or have been told to by docs or devs.

### `btrfs restore` – copy data from broken FS

```bash
# Restore everything from broken FS to /mnt/recover (doesn't modify src)
btrfs restore -v /dev/sdX /mnt/recover

# Restore specific file/subdir
btrfs restore -vi -t 5 /dev/sdX /mnt/recover
```

### `btrfs rescue` – low-level rescue helpers

Some subcommands (names can vary slightly by version):

```bash
btrfs rescue super-recover /dev/sdX
btrfs rescue chunk-recover /dev/sdX
btrfs rescue zero-log /dev/sdX
```

These deal with damaged superblocks, chunk trees, or log trees.

---

## 10. Device replacement: `btrfs replace`

Replace a failing device **online**.

```bash
# Replace old device with new device while mounted
btrfs replace start /dev/sdX /dev/sdY /mnt

# Monitor progress
btrfs replace status /mnt

# Cancel replacement
btrfs replace cancel /mnt
```

---

## 11. Properties: `btrfs property`

Set properties on files, dirs, subvolumes, or the filesystem.

### Common properties

* `compression` – per-file/per-dir compression
* `ro` – mark subvolume read-only

```bash
# Show properties of path
btrfs property get /mnt/@

# Enable compression on a directory (new data)
btrfs property set -ts /mnt/data compression zstd

# Make subvolume read-only
btrfs property set -ts /mnt/@snap-2025-11-26 ro true
```

---

## 12. Inspect internal structures: `btrfs inspect-internal`

Mostly for debugging/low-level analysis.

```bash
# Dump tree of a mounted FS
btrfs inspect-internal dump-tree /dev/sdX | less

# Show logical to physical mapping
btrfs inspect-internal logical-resolve /mnt/path/to/file

# Show inode info
btrfs inspect-internal inode-resolve INODE /mnt
```

You usually don’t need this day-to-day, but it’s powerful for advanced debugging.

---

## 13. Defrag & compression tweaking

### Defragment specific file or dir

```bash
# Defrag a file and re-compress with zstd
btrfs filesystem defragment -r -v -czstd /mnt/data
```

Common options:

* `-r` – recursive
* `-c[zstd|zlib|lzo]` – recompress
* `-f` – flush data after defrag

---

## 14. Space & usage tools recap

Quick toolbox:

```bash
btrfs filesystem show             # list Btrfs filesystems & devices
btrfs filesystem df /mnt          # per-profile usage
btrfs filesystem usage /mnt       # detailed usage
btrfs device stats /mnt           # per-device error stats
btrfs qgroup show /mnt            # quota usage
```

---

## 15. Where to read “everything” (docs)

For **full detail** (all options, all commands), best references:

* Official Btrfs docs: ([btrfs.readthedocs.io][1])
* Btrfs subvolume & related manpages (online man pages): ([man7.org][5])
* ArchWiki Btrfs article (very practical, lots of examples): ([ArchWiki][2])
* Kernel Btrfs Wiki / FAQ (background, caveats, troubleshooting): ([btrfs.wiki.kernel.org][6])

Search in your system too:

```bash
man btrfs
man btrfs-subvolume
man btrfs-filesystem
man mkfs.btrfs
```

---

If you want, next step I can:

* Design a **“day-1 to day-30” Btrfs practice plan**
* Or give you **ready-made example setups** (single disk, laptop w/ subvolumes for root/home/snapshots, multi-disk RAID1, etc.) with exact commands.

[1]: https://btrfs.readthedocs.io/?utm_source=chatgpt.com "Welcome to BTRFS documentation! — BTRFS documentation"
[2]: https://wiki.archlinux.org/title/Btrfs?utm_source=chatgpt.com "Btrfs - ArchWiki"
[3]: https://btrfs.readthedocs.io/en/latest/btrfs-subvolume.html?utm_source=chatgpt.com "btrfs-subvolume(8) - BTRFS documentation!"
[4]: https://en.wikipedia.org/wiki/Btrfs?utm_source=chatgpt.com "Btrfs"
[5]: https://man7.org/linux/man-pages/man8/btrfs-subvolume.8.html?utm_source=chatgpt.com "btrfs-subvolume(8) - Linux manual page"
[6]: https://btrfs.wiki.kernel.org/index.php?title=FAQ&utm_source=chatgpt.com "kernel btrfs FAQ - Btrfs Wiki"
