Here are the **most important `btrfs` commands** for managing Btrfs file systems:

---

### 🔧 **Filesystem Management**

| Command                            | Description                                     |
| ---------------------------------- | ----------------------------------------------- |
| `mkfs.btrfs /dev/sdX`              | Create a new Btrfs file system.                 |
| `btrfs filesystem show`            | Show all Btrfs file systems and their devices.  |
| `btrfs filesystem df /mount/point` | Show space usage at the file system level.      |
| `btrfs filesystem resize +5G /mnt` | Resize the Btrfs filesystem. (e.g., grow by 5G) |

---

### 🧩 **Subvolume Operations**

| Command                                              | Description                      |
| ---------------------------------------------------- | -------------------------------- |
| `btrfs subvolume list /mnt`                          | List all subvolumes.             |
| `btrfs subvolume create /mnt/@home`                  | Create a new subvolume.          |
| `btrfs subvolume delete /mnt/@home`                  | Delete a subvolume.              |
| `btrfs subvolume snapshot /mnt/@ /mnt/@_snapshot`    | Create a snapshot.               |
| `btrfs subvolume snapshot -r /mnt/@ /mnt/@_snapshot` | Create a **read-only** snapshot. |

---

### 📸 **Snapshot Management**

| Command                       | Description                  |                                            |
| ----------------------------- | ---------------------------- | ------------------------------------------ |
| \`btrfs send /mnt/@\_snapshot | btrfs receive /mnt/backup/\` | Send and receive snapshot (backup/mirror). |

---

### 💾 **Device and RAID Management**

| Command                             | Description                                           |
| ----------------------------------- | ----------------------------------------------------- |
| `btrfs device add /dev/sdY /mnt`    | Add a new device to a Btrfs volume.                   |
| `btrfs device delete /dev/sdY /mnt` | Remove a device from the Btrfs volume.                |
| `btrfs balance start /mnt`          | Start rebalancing (redistribute data across devices). |
| `btrfs balance status /mnt`         | Check rebalance status.                               |

---

### 🧮 **Scrubbing and Repair**

| Command                         | Description                                   |
| ------------------------------- | --------------------------------------------- |
| `btrfs scrub start /mnt`        | Start a scrub (check data integrity).         |
| `btrfs scrub status /mnt`       | View scrub status.                            |
| `btrfs check /dev/sdX`          | Check file system (read-only by default).     |
| `btrfs check --repair /dev/sdX` | Attempt repair (⚠️ risky – use with caution). |

---

### 🔍 **Info & Stats**

| Command                       | Description                              |
| ----------------------------- | ---------------------------------------- |
| `btrfs filesystem usage /mnt` | Detailed usage (data, metadata, system). |
| `btrfs device stats /mnt`     | I/O error statistics.                    |




Here’s a **well-organized, deeply thought-out guide** to **important `btrfs` commands** and **related system administration commands**, including how to set up Btrfs with RAID, manage snapshots, check disk usage, and perform maintenance. I've also added essential system-level commands for context.

---

## 🔧 1. **Create a Btrfs Filesystem**

```bash
mkfs.btrfs /dev/sdX
```

* To create Btrfs on multiple devices (for RAID):

```bash
mkfs.btrfs -m raid1 -d raid1 /dev/sdX /dev/sdY
```

* `-m`: metadata RAID level
* `-d`: data RAID level
  *Common levels: raid0, raid1, raid10, single (default), raid5, raid6*

---

## 📁 2. **Mount Btrfs Filesystem**

```bash
mount /dev/sdX /mnt
```

* With options:

```bash
mount -o compress=zstd,noatime /dev/sdX /mnt
```

* Useful options:

  * `compress=zstd|lzo|zlib`
  * `autodefrag`
  * `space_cache=v2`
  * `subvol=subvolume_name`

---

## 🧱 3. **Create and Use Subvolumes**

```bash
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
```

* Mount a subvolume:

```bash
mount -o subvol=@ /dev/sdX /mnt
```

---

## 🌀 4. **Snapshot Management**

* Create read-only snapshot:

```bash
btrfs subvolume snapshot -r /mnt/@ /mnt/@snapshot
```

* Create writable snapshot:

```bash
btrfs subvolume snapshot /mnt/@ /mnt/@snapshot_rw
```

* Delete snapshot:

```bash
btrfs subvolume delete /mnt/@snapshot
```

---

## 📊 5. **Check Usage & Balance**

* Show disk usage:

```bash
btrfs filesystem df /mnt
```

* Balance chunks (e.g. RAID changes, space reclaim):

```bash
btrfs balance start /mnt
```

* Balance specific filters (e.g. only metadata):

```bash
btrfs balance start -dusage=75 -musage=75 /mnt
```

---

## 🩺 6. **Check and Repair**

* Check filesystem (read-only):

```bash
btrfs check /dev/sdX
```

* With repair (only if needed):

```bash
btrfs check --repair /dev/sdX
```

> ⚠️ Use `--repair` **only as a last resort**.

---

## 🔁 7. **Add/Remove Devices**

* Add new device:

```bash
btrfs device add /dev/sdY /mnt
```

* Remove a device:

```bash
btrfs device remove /dev/sdY /mnt
```

---

## 🧩 8. **Convert from ext3/ext4 to Btrfs**

```bash
btrfs-convert /dev/sdX
```

* This is reversible (backup required).
* Converts in-place but retains an ext2 image that can be restored.

---

## 🧮 9. **Btrfs RAID Reshaping (Change RAID Level)**

* Example: Convert RAID1 to single:

```bash
btrfs balance start -dconvert=single -mconvert=single /mnt
```

* Common conversions:

  * `single` ←→ `raid1`
  * `raid0`, `raid10`, `raid5/6` (experimental)

---

## 📄 10. **fstab Entry Example for Btrfs**

```bash
UUID=xxxx-xxxx /mnt btrfs defaults,compress=zstd,subvol=@ 0 0
```

---

## ✅ BONUS: System Commands You Often Need with Btrfs

### 📦 Disk Partitioning

```bash
lsblk
fdisk /dev/sdX
parted /dev/sdX
```

### 🔒 Encrypt a Btrfs volume with LUKS

```bash
cryptsetup luksFormat /dev/sdX
cryptsetup open /dev/sdX secure_btrfs
mkfs.btrfs /dev/mapper/secure_btrfs
```

### 📦 Bootloader (with Btrfs subvolumes)

* Grub users often configure `/boot/grub/grub.cfg` to handle subvolumes properly.


