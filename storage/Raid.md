
### You can create raid between 2 nvme dist after that create lvmcache
```
sudo apt install mdadm


sudo mdadm --create --verbose /dev/[ RAIDarray Nameor Number] --level=[RAID Level] --raid-devices=[Number of storage devices] [Storage Device] [Storage Device]


sudo mdadm --create --verbose /dev/md0 --level=raid0 --raid-devices=2 /dev/sdb /dev/sdc

cat /proc/mdstat

sudo mkfs –t [File system type] [RAID Device]

sudo mkfs -t ext4 /dev/md1

sudo blkid /dev/md1

sudo vim /etc/fstab

UUID=f0879cd2-cb6f-40eb-9a66-cb700336a96a /mount ext4 defaults 0 0

mount -a

apt install mdadm
sudo mdadm --create --verbose /dev/md0 --level=raid0 --raid-devices=2 /dev/nvme0n1 /dev/nvme1n1
mkfs.xfs /dev/md0
pvcreate /dev/md0
vgextend storage /dev/md0
lvcreate -L 10G -n lv_cache_metadata storage  /dev/md0
lvcreate  -l 90%FREE -n lv_cache storage /dev/md0
lvconvert --type cache-pool --cachemode writethrough --poolmetadata /dev/storage/lv_cache_metadata /dev/storage/lv_cache
lvconvert --type cache --cachepool /dev/storage/lv_cache /dev/storage/storagelv
apt-get install thin-provisioning-tools
echo "dm_cache" >> /etc/initramfs-tools/modules
echo "dm_cache_mq"  >> /etc/initramfs-tools/modules
echo "dm_cache_smq"  >> /etc/initramfs-tools/modules
echo "dm_persistent_data"  >> /etc/initramfs-tools/modules
echo "dm_bufio"  >> /etc/initramfs-tools/modules


nano /etc/initramfs-tools/hooks/cache_hook


#!/bin/sh
 
PREREQ="lvm2"
 
prereqs()
{
    echo "$PREREQ"
}
 
case $1 in
prereqs)
    prereqs
    exit 0
    ;;
esac
 
if [ ! -x /usr/sbin/cache_check ]; then -rdn
    exit 0
fi
 
. /usr/share/initramfs-tools/hook-functions
 
copy_exec /usr/sbin/cache_check
 
manual_add_modules dm_cache dm_cache_mq dm_cache_smq dm_persistent_data dm_bufio


chmod +x /etc/initramfs-tools/hooks/cache_hook
update-initramfs -v -u -k all
```
