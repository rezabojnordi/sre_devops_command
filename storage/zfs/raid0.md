
```
modprobe zfs

apt update
apt install -y zfsutils-linux

mkdir -p /data
```

```bash
sudo mkdir -p /data

ID1="$(for i in /dev/disk/by-id/nvme-*; do [ "$(readlink -f "$i")" = "/dev/nvme2n1" ] && echo "$i" && break; done)"
ID2="$(for i in /dev/disk/by-id/nvme-*; do [ "$(readlink -f "$i")" = "/dev/nvme3n1" ] && echo "$i" && break; done)"

echo "Using disks:"
echo "$ID1"
echo "$ID2"

[ -z "$ID1" ] && echo "ERROR: by-id path for /dev/nvme2n1 not found" && exit 1
[ -z "$ID2" ] && echo "ERROR: by-id path for /dev/nvme3n1 not found" && exit 1

sudo zpool create -f \
  -o ashift=12 \
  -o autotrim=on \
  -o cachefile=/etc/zfs/zpool.cache \
  -O compression=lz4 \
  -O atime=off \
  -O xattr=sa \
  -O acltype=posixacl \
  -O recordsize=128K \
  -O mountpoint=/data \
  chainpool \
  "$ID1" "$ID2"

sudo zfs set logbias=throughput chainpool
sudo zfs set primarycache=metadata chainpool

sudo zpool status
df -h /data
```
