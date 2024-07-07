# Debian networking on proxmox cheatsheet 

### Config for `/etc/network/interfaces`:
```
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto ens18
iface ens18 inet static
        address 136.243.249.146
        netmask 255.255.255.240
        gateway 136.243.249.158
        pointopoint 136.243.249.158
        dns-nameservers 4.2.2.4

```
This restart networking:
```
systemctl restart networking
```
Set device UP
```
ip link set dev ens18 up
```
Set DNS `/etc/resolv.conf`:
```
nameserver 8.8.8.8
nameserver 8.8.4.4
```
Done!

### Now enable remote-ssh:
```
sudo apt install openssh-server
```
Edit `/etc/ssh/sshd_config`:
```
PermitRootLogin yes
```
Restart sshd service:
```
service sshd restart
```

