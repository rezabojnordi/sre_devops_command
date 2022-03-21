
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
