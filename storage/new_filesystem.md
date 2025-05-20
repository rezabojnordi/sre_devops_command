
```
sudo e2label /dev/sdb1 supra

/dev/disk/by-label/supra /data ext4  defaults,prjquota,usrquota,grpquota 0 2
```
```
=======================

apt-get install gdisk
gdisk /dev/sdb
o
n
w
mkfs.ext4 /dev/sdb1
==============================
```

```
gdisk /dev/sdb
w
growpart /dev/sdb 1
resize2fs /dev/sdb1

xfs_growfs /data
```

### debian has problem on the growpart in cloud
```
sudo parted /dev/sda
print
resizepart 1 100%
quit
```


##btrfs filesystem
```
sudo btrfs filesystem resize max /mnt/storage
```
## zfs
```
sudo zpool online -e mypool /dev/sdb
```
