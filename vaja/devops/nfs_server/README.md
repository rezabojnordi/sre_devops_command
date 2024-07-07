# nfs_server

### How to deploye nfs on master nodes

```


apt-get install nfs-kernel-server

dpkg -l | grep nfs-kernel-server


<Directory> <subnet/24> (rw,all_squash,anonuid=0,anongid=0,sync,no_subtree_check)

/storage/ 192.168.220.0/24(rw,all_squash,anonuid=0,anongid=0,sync,no_subtree_check)
```

### How to deploye nfs on worker nodes

‍‍‍```
apt-get install nfs-common 

showmount -e <ip>

nfs-server-ip:/home/username    /mnt/nfs-share   nfs    rw,soft,intr,noatime,x-gvfs-show

showmount -e 192.168.220.18

### How to fix error when nfs-comon doesn't start
```
sudo rm /lib/systemd/system/nfs-common.service
 
sudo systemctl daemon-reload
 
systemctl restart nfs-common

```

### How to tuunign os for file storage

* vim /etc/sysctl.conf

```
fs.inotify.max_user_watches=1048576
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
net.ipv4.ip_forward=1
net.netfilter.nf_conntrack_max=262144
vm.dirty_background_ratio=5
vm.dirty_ratio=10
vm.swappiness=5
net.bridge.bridge-nf-call-ip6tables=1
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-arptables=1
net.ipv4.igmp_max_memberships=1024
net.ipv4.neigh.default.gc_thresh1=512
net.ipv4.neigh.default.gc_thresh2=1024
net.ipv4.neigh.default.gc_thresh3=2048
net.ipv4.route.gc_thresh=2048
net.ipv4.neigh.default.gc_interval=60
net.ipv4.neigh.default.gc_stale_time=120
net.ipv6.neigh.default.gc_thresh1=512
net.ipv6.neigh.default.gc_thresh2=1024
net.ipv6.neigh.default.gc_thresh3=2048
net.ipv6.route.gc_thresh=2048
net.ipv6.neigh.default.gc_interval=60
net.ipv6.neigh.default.gc_stale_time=120
net.ipv6.conf.lo.disable_ipv6=0
fs.aio-max-nr=131072
net.core.rmem_default=262144
net.core.wmem_default=262144
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.ipv4.tcp_fin_timeout=20
net.ipv4.tcp_keepalive_time=300
net.ipv4.tcp_keepalive_probes=5
net.ipv4.tcp_keepalive_intvl=15
net.ipv4.tcp_rmem=8192 87380 16777216
net.ipv4.tcp_wmem=8192 87380 16777216
net.ipv4.udp_rmem_min=16384
net.ipv4.udp_wmem_min=16384
net.core.somaxconn=32768
net.core.netdev_max_backlog=16384
net.ipv4.ip_local_port_range=10000 65535
fs.inotify.max_user_instances=1024
net.ipv4.conf.all.accept_source_route=0
net.ipv4.conf.default.accept_source_route=0
net.ipv4.icmp_echo_ignore_broadcasts=1
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.default.send_redirects=0
net.ipv6.conf.all.accept_source_route=0
net.ipv4.conf.default.accept_redirects=0
kernel.randomize_va_space=2

```
