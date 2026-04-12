
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
