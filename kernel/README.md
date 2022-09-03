
## requirementing compile kernel
```
sudo apt install flex 
sudo apt-get install bison
sudo apt-get install libncurses-dev flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf
sudo apt install dwarves
scripts/config --undefine CONFIG_SYSTEM_TRUSTED_KEYS
```


## chose module on custome kernel
```
make config
```
## or
```
make maneuconfig
```
afther that when you add or active params or driver on custome kernel afther that you must save config and finally 


```
make clean
make -j8 all
```
## or
```
make
```



lkernel.org

lkm.org

## compiling kernel on your server
```
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.17.1.tar.xz
tar xvf linux-5.17.1.tar.xz

sudo apt install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison dwarves -y

cd linux-5.17.1
make mrproper


make menuconfig


make -j <number_cpu>


make -j 4

scripts/config --disable SYSTEM_TRUSTED_KEYS
scripts/config --set-str SYSTEM_TRUSTED_KEYS ""
scripts/config --disable SYSTEM_REVOCATION_KEYS

make modules_install


sudo make install

sudo update-initramfs -c -k 5.17.1

sudo update-grub

reboot

```