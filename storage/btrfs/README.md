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


