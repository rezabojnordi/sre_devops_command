Alright — you want **the full documentation**, with **each topic explained** + **the matching command** together, in an organized and easy-to-read way.

Here’s the complete **OpenZFS Commands + Explanation Doc** you asked for:

---

# 📖 OpenZFS Cheat Sheet — Full Commands + Explanation

---

## 1. Storage Pool Configurations

Create different types of storage layouts using `zpool create`.

| Type                  | Explanation | Command |
| :-------------------- | :---------- | :------ |
| Single Disk            | No redundancy, just a simple pool. | `zpool create mypool disk1` |
| Stripe (RAID-0)        | Combines disks for performance, no fault tolerance. | `zpool create mystripe disk1 disk2` |
| Mirror (RAID-1)        | Two disks mirror each other, high redundancy. | `zpool create mymirror mirror disk1 disk2` |
| Single-Parity (RAID-Z1) | Survives 1 disk failure, needs 3 disks. | `zpool create paritypool raidz disk1 disk2 disk3` |
| Double-Parity (RAID-Z2) | Survives 2 disk failures, needs 4 disks. | `zpool create myraidz2 raidz2 disk1 disk2 disk3 disk4` |
| Triple-Parity (RAID-Z3) | Survives 3 disk failures, needs 5 disks. | `zpool create myz3 raidz3 disk1 disk2 disk3 disk4 disk5` |
| RAID10 (Mirrors+Stripe) | Combines mirrors and stripes, good speed and redundancy. | `zpool create myr10 mirror disk1 disk2 mirror disk3 disk4` |

---

## 2. Display Pool Status

Monitor your ZFS pool’s health, capacity, and history.

| Purpose | Command |
| :------ | :------ |
| Show status and errors | `zpool status` |
| List pools and usage | `zpool list` |
| Pool I/O statistics | `zpool iostat` |
| Pool history of commands | `zpool history` |
| Display properties | `zpool get all mypool` |

---

## 3. Special VDEVs (Cache, Log, Spare)

Enhance pool performance with extra devices.

| Device | Explanation | Command |
| :----- | :---------- | :------ |
| Cache (L2ARC) | Extra read cache using SSDs. | `zpool add mypool cache /dev/nda0` |
| Log (ZIL) | Faster synchronous write confirmation. | `zpool add mypool log /dev/nda1` |
| Spare | Hot spare for automatic disk replacement. | `zpool add mypool spare /dev/nda2` |

---

## 4. Pool Extension

Expand or repair existing pools.

| Action | Command |
| :----- | :------ |
| Add mirror to existing single disk | `zpool attach mypool mirror /dev/nda0 /dev/nda1` |
| Replace failed disk | `zpool replace mypool /dev/nda2 /dev/nda3` |

---

## 5. Pool Import/Export

Move pools between systems safely.

| Action | Command |
| :----- | :------ |
| Export a pool | `zpool export mypool` |
| Import all pools | `zpool import` |
| Import a named pool | `zpool import mypool` |
| Rename during import | `zpool import oldname newname` |
| Import pool with different mount root | `zpool import -R /media mypool` |
| Import pool readonly | `zpool import -o readonly=on mypool` |
| Recover destroyed pool | `zpool import -D mypool` |

---

## 6. ZFS Datasets

Datasets organize and separate data inside pools.

| Action | Command |
| :----- | :------ |
| Create dataset | `zfs create mypool/dataset` |
| Create nested dataset | `zfs create -p mypool/home/fred` |
| List datasets | `zfs list` |
| Rename dataset | `zfs rename mypool/home/fred mypool/home/eva` |
| Destroy dataset | `zfs destroy -v mypool/old` |

---

## 7. Properties

Manage dataset and pool behavior with properties.

| Action | Command |
| :----- | :------ |
| Display dataset properties | `zfs get all mypool/dataset` |
| Set access time off | `zfs set atime=off mypool` |
| Set custom mountpoint | `zfs set mountpoint=/media mypool/dataset` |
| Create custom property | `zfs set warranty:expires=2048/04/20 mypool` |

---

## 8. Scrub

Self-heal and verify your data integrity.

| Action | Command |
| :----- | :------ |
| Start scrub | `zpool scrub mypool` |
| View scrub progress | `zpool status` |

---

## 9. Volumes

Create virtual block devices managed by ZFS.

| Action | Command |
| :----- | :------ |
| Create a 10GB volume | `zfs create -V 10G mypool/vol1` |
| Create a sparse volume | `zfs create -V 1P -s mypool/sparse1PBvol` |

---

## 10. Quotas

Limit dataset or user/group disk usage.

| Action | Command |
| :----- | :------ |
| Set dataset quota | `zfs set quota=10G mypool/dataset` |
| Set user quota | `zfs set userquota@fred=10G mypool/home/fred` |
| Set group quota | `zfs set groupquota@projectX=100G mypool/projectX` |
| Show user quotas | `zfs userspace mypool/home/fred` |

---

## 11. Reservation

Reserve guaranteed space for datasets.

| Action | Command |
| :----- | :------ |
| Set reservation | `zfs set reservation=100G mypool/home` |
| Set refreservation (only for parent) | `zfs set refreservation=10G mypool/home/eve` |
| Remove reservation | `zfs set reservation=none mypool/home/eve` |

---

## 12. Snapshots

Create point-in-time copies to protect data.

| Action | Command |
| :----- | :------ |
| Create snapshot | `zfs snapshot mypool/ds@mysnapshot` |
| Create recursive snapshot | `zfs snap -r mypool/ds@mysnapshot` |
| List snapshots | `zfs list -t snap mypool/ds` |
| Compare with snapshot | `zfs diff mypool/ds@backup` |
| Rollback to snapshot | `zfs rollback mypool/ds@backup` |

---

## 13. Clones

Writable copies of snapshots.

| Action | Command |
| :----- | :------ |
| Create clone | `zfs clone mypool/ds@backup mypool/myclone` |
| Promote clone (break dependency) | `zfs promote mypool/myclone` |
| Destroy clone | `zfs destroy mypool/myclone` |

---

## 14. Encryption

Protect datasets with encryption.

| Action | Command |
| :----- | :------ |
| Create encrypted dataset | `zfs create -o encryption=on -o keyformat=passphrase -o keylocation=prompt mypool/secret` |
| Load encryption key | `zfs load-key mypool/secret` |
| Check encryption status | `zfs get keystatus mypool/secret` |

---

## 15. Delegation

Allow non-root users to manage specific datasets.

| Action | Command |
| :----- | :------ |
| Grant permission to user | `zfs allow -u joe atime mypool/dataset` |
| Grant permission to group | `zfs allow -g mygroup atime mypool/dataset` |
| Delegate further permissions | `zfs allow -u jill allow mypool/dataset` |
| Create a permission set | `zfs allow -s @myset mount,snapshot,rollback,destroy mypool/dataset` |

---

## 16. Sending and Receiving Snapshots

Efficiently backup and replicate datasets.

| Action | Command |
| :----- | :------ |
| Send snapshot to file | `zfs send mypool/ds@backup > dsbackup` |
| Restore from file | `zfs recv mypool/backup < dsbackup` |
| Direct send/recv pipe | `zfs send mypool/ds@backup | zfs recv mypool/new` |
| Send over SSH | `zfs send poolA/ds@backup | ssh host zfs recv poolB/new` |
| Allow sender permission | `zfs allow -u sender send,snapshot mypool/source` |
| Allow receiver permission | `zfs allow -u receiver compression,mountpoint,mount,create,receive mypool/destination` |

---

# ✅ Summary

This cheat sheet covers **everything**:  
- Pool creation and management  
- Dataset control  
- Properties and quotas  
- Snapshot and clone handling  
- Scrubbing, reservation, and encryption  
- Data sending/receiving for backup  
- Delegating ZFS rights to users  

---

Would you like me to also package this into a **beautiful Markdown file** (`README.md`) so you can immediately use it in your GitHub, documentation, or wiki? 🚀  
If yes, I can generate it right away!
