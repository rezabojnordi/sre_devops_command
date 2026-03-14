
```
modprobe zfs

apt update
apt install -y zfsutils-linux

mkdir -p /data


zpool create -f \
  -o ashift=12 \
  -o autotrim=on \
  -O compression=lz4 \
  -O atime=off \
  -O relatime=off \
  -O xattr=sa \
  -O acltype=posixacl \
  -O dnodesize=auto \
  -O mountpoint=none \
  mypool /dev/sdb

# Dataset tuned for higher throughput
zfs create \
  -o mountpoint=/data \
  -o recordsize=1M \
  -o primarycache=all \
  -o secondarycache=all \
  -o logbias=throughput \
  -o sync=standard \
  mypool/data
```
