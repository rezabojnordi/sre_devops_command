# Networking cheatsheet 

### NAT private networok to internet(Public):
This code must executed on HA on the node acting as a gateway
```
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o public_interface -j MASQUERADE
iptables -A FORWARD -i public_interface -o local_interface -m state  --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i local_interface -o public_interface -j ACCEPT
```
### Forward ssh from port 20101 to port 22 of a local computer:
```
iptables -t nat -A POSTROUTING -o public_interface -j MASQUERADE
iptables -t nat -A PREROUTING -p tcp -i public_interface --dport 20101 -j DNAT --to-destination 192.168.0.101:22
iptables -A FORWARD -p tcp -d 192.168.0.101 --dport 22 -j ACCEPT
```


