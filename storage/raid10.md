```
sudo apt update
sudo apt install mdadm
sudo mdadm --create /dev/md0 --raid-devices=2 --level=0 /dev/nvme1n1 /dev/nvme0n1

sudo mdadm --create /dev/md1 --raid-devices=2 --level=0 /dev/nvme4n1 /dev/nvme5n1

sudo mdadm --create /dev/md2 --raid-devices=2 --level=1 /dev/md0 /dev/md1

sudo mdadm --detail /dev/md2

sudo mkfs.ext4 /dev/md2

sudo mount /dev/md2 /mnt

sudo mdadm --detail --scan >> /etc/mdadm/mdadm.conf
```
```
sudo apt update
sudo apt install zfsutils-linux

sudo zpool create zp0 /dev/md2

sudo zfs create zp0/zd0


sudo zfs set mountpoint=/data zp0/zd0


zfs list

sudo zfs set mountpoint=/data zp0/zd0
```
