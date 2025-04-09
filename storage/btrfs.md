

---

```markdown
# 🔧 Btrfs Auto-Mount with Subvolume on Extra Disk

This guide walks you through setting up a secondary disk (`/dev/sdb`) with the Btrfs file system, creating a subvolume, and mounting it on a Linux system.

---

## 🧾 Step-by-step Instructions

### 1. 🔍 List available block devices
```bash
lsblk -dn -o NAME,TYPE
```
**Example output:**
```
sda disk
sdb disk
```

---

### 2. 🏠 Identify root disk (to exclude it)
```bash
findmnt -n -o SOURCE /
```
**Example output:**
```
/dev/sda3
```
So root disk is `/dev/sda`, and extra disk is `/dev/sdb`.

---

### 3. 📎 Check if `/dev/sdb` already has a filesystem
```bash
blkid -o value -s TYPE /dev/sdb
```

---

### 4. 💽 Format the extra disk as Btrfs
```bash
mkfs.btrfs -f /dev/sdb
```

---

### 5. 📁 Create a mount point for the main Btrfs volume
```bash
mkdir -p /mnt/snarkos
chmod 755 /mnt/snarkos
```

---

### 6. 🔗 Mount the Btrfs filesystem
```bash
mount -o discard,defaults /dev/sdb /mnt/snarkos
```

---

### 7. 🧱 Create a Btrfs subvolume
```bash
btrfs subvolume create /mnt/snarkos/snarkos-data
```

---

### 8. 📁 Create a mount point for the subvolume
```bash
mkdir -p /mnt/snarkos-data
chmod 755 /mnt/snarkos-data
```

---

### 9. 🔗 Mount the subvolume
```bash
mount -o subvol=snarkos-data,discard,defaults /dev/sdb /mnt/snarkos-data
```

---

## ✅ Optional: Persist mounts via `/etc/fstab`

To make the mount persistent across reboots, add the following lines to `/etc/fstab`:

```
/dev/sdb /mnt/snarkos btrfs discard,defaults 0 0
/dev/sdb /mnt/snarkos-data btrfs subvol=snarkos-data,discard,defaults 0 0
```

---

## 📝 Notes

- Replace `/mnt/snarkos` and `snarkos-data` with your preferred mount paths or subvolume names.
- Use `-f` with `mkfs.btrfs` cautiously, as it will erase all data on the disk.
```

-------------------------------------------------------------------------------------

SNAPSHOT_DIR="/mnt/snarkos/snapshots"
SUBVOLUME_DIR="/mnt/snarkos/snarkos-data"
BUCKET_NAME="snarkos-mainnet"
GCS_PATH="gs://$BUCKET_NAME/latest.tar.lz4"

sudo mkdir -p "$SNAPSHOT_DIR"


SNAPSHOT_NAME="$SNAPSHOT_DIR/block_storage_snapshot"
sudo btrfs subvolume snapshot $SUBVOLUME_DIR $SNAPSHOT_NAME


sudo tar -cf - "$SNAPSHOT_NAME" | lz4 -c | gsutil cp - "$GCS_PATH"





