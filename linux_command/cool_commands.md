# Cool terminal commands cheatsheet 
### Terminal commands:

Want to know your public IP?
### wget -qO - icanhazip.com

Remove all files but one?
### rm -v !("filename")

Base64 Encode
### echo string_to_encode | base64

Base64 Decode
### echo ZWhzYW5zaDg0Okp1Y2lhbEB4NjQ= | base64 --decode

Remove all files but two?
### rm -v !("filename1"|"filename2") 

Remove all files but two types?
### rm -v !(*.zip|*.odt)

Rename terminal window
echo $'\033]30;NewName\007'

List all files but *conf
### ls -I "*conf"

List all dirs
### ls -d */

list all files containing my_text
###grep -iRl "my_text" *

get certificate:
```
certbot certonly -d domain —expand -d www.domain.com
```

Change timzone for ubuntu
```
sudo timedatectl set-timezone Asia/Tehran
```
See listening ports:
```
ss -tulpn
```

Echo with a typewriter effect:
```
apt install pv
echo "You can simulate on-screen typing just like in the movies" | pv -qL 10
```

Grep lines before and after:
```
grep -A 5 keyword filename #after
grep -B 5 keyword filename #before
grep -C 5 keyword filename #center
```
Tunnel network traffic:
```
sudo sshuttle --dns -vvr root@x.x.x.x 0/0
```
If encountered with the error `fatal: server died with error code 255` run this command instead:
```
sudo sshuttle --dns -vvr root@x.x.x.x[:443] --exclude x.x.x.x 0/0
```

Hard disk performance test:
```
fio --loops=5 --size=1024m --filename=/mnt/nfs/test12.txt --stonewall --ioengine=libaio --direct=1 \
  --name=Seqread --bs=1m --rw=read \
  --name=Seqwrite --bs=1m --rw=write \
  --name=512Kread --bs=512k --rw=randread \
  --name=512Kwrite --bs=512k --rw=randwrite \
  --name=4kQD32read --bs=4k --iodepth=32 --rw=randread \
  --name=4kQD32write --bs=4k --iodepth=32 --rw=randwrite
```

### Problem with apt update?
```
printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
```
Change system DNS:
```
vim /etc/systemd/resolved.conf 
systemctl restart systemd-resolved.service 
```
Change system DNS another way:
```
vim /etc/systemd/resolved.conf 
systemctl restart systemd-resolved
```

Fix missing VPN client
```
sudo apt install network-manager-pptp-gnome
```
Find all sockets on your system:
```
sudo find / -type s
```
ls and numerical permissions:
```
 ls -l | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/) \
             *2^(8-i));if(k)printf("%0o ",k);print}'
```
Unset env variables:
```
unset GNUPLOT_DRIVER_DIR
```
Check for your public IP:
```
wget -qO - icanhazip.com
```

### Run a python script as a linux command:
Put a shebang `#! /usr/bin/python` on top of script
Then make in executable:
```
sudo chmod +x script.py
```
Put it inside `/usr/bin`
Remove `.py` so `script.py` will be `script`
Run!

### Remove a virtual network interface:
```
sudo ip link delete interface_name
```

### Find a directory:
```
find / -name DIRNAME -type d
```
### Check traffics on the port:
```
tcpdump -i <interface-name> port <port-number>
```
### Check traffics on the port a few exclusions:
```
tcpdump -i <interface-name> port <port-number> -n port not 22 and not arp and port not 53
```
### Check traffics on the port 443:
```
tcpdump -i ens3 port 443
```
### Color specific word in output (| is necessary):
```
command | grep --color -P "word|"
```
### Add user to sudoers:
Edit this file: `/etc/sudoers` and add this line to the end of file:
```
username  ALL=(ALL) NOPASSWD:ALL
```

### Set default ssh port for specific host: `~/.ssh/config`
```
Host git.greenrnd.com
    User git
    Hostname git.greenrnd.com
    Port 2580
```

### How much disk is used by journalctl
```
journalctl --disk-usage
```

### How to increase your swap size?
```
SWAP_PATH=/root/swap.swp
swapoff -a
dd if=/dev/zero of=$SWAP_PATH bs=1M count=16384 #count=1024*16=16GBi
chmod 600 $SWAP_PATH
mkswap $SWAP_PATH
swapon $SWAP_PATH
```
Finally, edit `/etc/fstab` and comment current swap file:
```
/swapfile                                 none            swap    sw              0       0
```
and add this line:
```
/root/swap.swp             swap        swap         defaults                0       0
```

### How to see SSL certificate details:
```
echo | openssl s_client -showcerts -servername gnupg.org -connect gnupg.org:443 2>/dev/null | openssl x509 -inform pem -noout -text
```
### List all partitions
```
sudo lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL
```
### Filter output by multiple keywords:
```
ls | egrep "(kw1|kw2)"
```

