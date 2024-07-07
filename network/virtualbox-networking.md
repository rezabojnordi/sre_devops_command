# Virtualbox networking cheatsheet 

Clone all VMs as you want. The go to the tools/preferences and choose network. Add a network supporting DHCP.
Then go to each VM's network settings and select `NAT Network` the select `your defined network`
Finally you need to change each VM's machine-id like this:
### Change machine-id:
```
sudo rm /etc/machine-id
sudo dbus-uuidgen --ensure=/etc/machine-id
```

That's it!


