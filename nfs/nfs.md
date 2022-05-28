# NFS (Network File Sharing) cheatsheet 

### Server configuration:
```
sudo apt install nfs-kernel-server
sudo mkdir /ro_dir
sudo chmod 755 /ro_dir
sudo mkdir rw_dir
sudo chmod 777 /rw_dir
```
Now edit `/etc/exports`:
```
/ro_dir   *(ro,sync,no_subtree_check)
/rw_dir   192.168.10.20(rw,sync,no_subtree_check)
```
Note: you can share a directory only for specific IP like above
```
sudo exportfs -arvf
sudo systemctl start nfs-kernel-server
sudo systemctl enable nfs-kernel-server
```
### Client configuration:
```
sudo apt install nfs-common
```
Now you can see mountables on server:
```
showmount -e server_ip
```
```
sudo mkdir /mnt/ro_dir
sudo mkdir /mnt/rw_dir
sudo mount -t nfs server_ip:/ro_dir /mnt/ro_dir
sudo mount -t nfs server_ip:/rw_dir /mnt/rw_dir
```
Now you can see the partition you just mounted:
```
mount
```
If you want to unmount:
```
sudo unmount /mnt/ro_dir
```
If you want to make mount permament edit `/etc/fstab`:
```
server_ip:/ro_dir   /mnt/ro_dir   nfs   defaults,_netdev 0 0
server_ip:/rw_dir   /mnt/rw_dir   nfs   defaults,_netdev 0 0
```
And load all:
```
sudo mount -a
```

