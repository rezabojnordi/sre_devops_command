```
modprobe zfs

apt install -y zfsutils-linux

mkdir /data


# 1. Create the pool with performance tunings enabled on the root
zpool create -f -o ashift=12 \
  -O compression=lz4 \
  -O atime=off \
  -O xattr=sa \
  -O acltype=posixacl \
  -O mountpoint=none \
  mypool /dev/sdb

# 2. Create the dataset and mount it to /data
zfs create -o mountpoint=/data mypool/data

