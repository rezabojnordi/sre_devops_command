```
# Increase max file descriptors
fs.file-max = 2097152

# Increase TCP buffer size for high performance
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.rmem_default = 16777216
net.core.wmem_default = 16777216
net.core.optmem_max = 16777216

# Allow more queued connections
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 65535
net.ipv4.tcp_max_syn_backlog = 65535

# Reduce TIME_WAIT delay
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_tw_reuse = 1

# Enable fast recycling of closed sockets
#net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_syncookies = 1

# Increase ephemeral ports for high concurrent connections
net.ipv4.ip_local_port_range = 1024 65535

# Reduce dropped connections
net.ipv4.tcp_abort_on_overflow = 1
```
