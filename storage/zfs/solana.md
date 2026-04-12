## best prasctise for solana
```
systemctl stop solana-rpc.service

umount /data
mdadm --stop /dev/md1

mdadm --zero-superblock /dev/nvme0n1p1
mdadm --zero-superblock /dev/nvme1n1p1
mdadm --zero-superblock /dev/nvme2n1p1
mdadm --zero-superblock /dev/nvme3n1p1

wipefs -a /dev/nvme0n1
wipefs -a /dev/nvme1n1
wipefs -a /dev/nvme2n1
wipefs -a /dev/nvme3n1

mkdir -p /data/solana

zpool create -f \
  -o ashift=12 \
  -o autotrim=on \
  -O mountpoint=/data/solana/accounts \
  -O atime=off \
  -O compression=off \
  -O xattr=sa \
  -O acltype=posixacl \
  -O relatime=off \
  sol-accounts \
  mirror /dev/disk/by-id/<ACC1> /dev/disk/by-id/<ACC2>

zpool create -f \
  -o ashift=12 \
  -o autotrim=on \
  -O mountpoint=none \
  -O atime=off \
  -O compression=off \
  -O xattr=sa \
  -O acltype=posixacl \
  -O relatime=off \
  sol-ledger \
  mirror /dev/disk/by-id/<LED1> /dev/disk/by-id/<LED2>

zfs set recordsize=16K sol-accounts
zfs set logbias=latency sol-accounts
zfs set sync=standard sol-accounts

zfs create \
  -o mountpoint=/data/solana/ledger \
  -o recordsize=1M \
  -o atime=off \
  -o compression=off \
  -o logbias=throughput \
  -o sync=standard \
  sol-ledger/ledger

zfs create \
  -o mountpoint=/data/solana/snapshots \
  -o recordsize=1M \
  -o atime=off \
  -o compression=off \
  -o logbias=throughput \
  -o sync=standard \
  sol-ledger/snapshots

zfs mount -a

zpool status
zpool list
zfs list
zfs get mountpoint,recordsize,compression,atime,logbias,sync sol-accounts sol-ledger/ledger sol-ledger/snapshots
```


#### 2 TB
```
zpool create -f \
  -o ashift=12 \
  -o autotrim=on \
  -O mountpoint=none \
  -O atime=off \
  -O compression=off \
  -O xattr=sa \
  sol \
  mirror /dev/disk/by-id/<disk1> /dev/disk/by-id/<disk2>

zfs create \
  -o mountpoint=/data/solana/ledger \
  -o recordsize=1M \
  -o logbias=throughput \
  sol/ledger

zfs create \
  -o mountpoint=/data/solana/accounts \
  -o recordsize=16K \
  -o logbias=latency \
  sol/accounts

zfs create \
  -o mountpoint=/data/solana/snapshots \
  -o recordsize=1M \
  -o logbias=throughput \
  sol/snapshots

zpool status
zpool list
zfs list
zfs get recordsize,compression,atime,logbias,mountpoint sol/ledger sol/accounts sol/snapshots
```
