# iptables cheatsheet

### Add a port:
```
sudo iptables -A INPUT -p tcp --dport xxxx -j ACCEPT
```
### List rules:
```
sudo iptables -L
```
### Remove a port:
```
sudo iptables -D INPUT -p tcp --dport xxxx -j ACCEPT
```
### Backup all rules to files:
```
iptables-save > IPtablesbackup.txt
```
### Restore from file:
```
iptables-restore < IPtablesbackup.txt 
```



