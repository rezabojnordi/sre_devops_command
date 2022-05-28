# How to install OS on rescue mode for Hetzner by Ehsan Shirzadi

### Step1: Create a file `/setupmode` and set values
```commandline
DRIVE1 /dev/sda
DRIVE2 /dev/sdb
SWRAID 1
SWRAIDLEVEL 0
HOSTNAME Ubuntu-2004-focal-64-minimal-hwe
PART /boot  ext3     512M
PART lvm    vg0       all
LV vg0   root   /        ext4         400G
IMAGE /root/.oldroot/nfs/install/../images/Ubuntu-2004-focal-64-minimal-hwe.tar.gz
```
### Step2: Run `installimage`


