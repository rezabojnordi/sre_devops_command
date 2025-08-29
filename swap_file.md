```bash
sudo dd if=/dev/zero of=./swapfile bs=1M count=384000 status=progress
or
sudo fallocate -l 2G /swapfile

sudo chmod 600 /swapfile

sudo mkswap /swapfile

sudo swapon /swapfile

sudo nano /etc/fstab

/swapfile none swap sw 0 0

swapon --show

sudo sysctl vm.swappiness=10

```
