
## ifconfig
ifconfig (interface configurator) command is used to initialize an interface, assign IP Address to interface and enable or disable interface on demand.


```
ifconfig
```

ifconfig with interface (eth0) command only shows specific interface details like IP Address, MAC Address, etc. with -a option will display all available interface details if it is disabled also.

```
ifconfig eth0

```

Set IP Address and Gateway in Linux.
Assigning an IP Address and Gateway to the interface on the fly. The setting will be removed in case of a system reboot.

```
ifconfig eth0 192.168.50.5 netmask 255.255.255.0
```

### Enable eth0


```

 ifup eth0

```

### Disable eth0

```
ifdown eth0
```

ifquery command used to parse the network interface configuration, enabling you to receive answers to query about how it is currently configured.

```
sudo ifquery eth0
```

### Setting MTU Size
By default MTU size is 1500. We can set the required MTU size with the below command. Replace XXXX with size.

```
ifconfig eth0 mtu XXXX

```

### Set Interface in Promiscuous Mode
The network interface only received packets belonging to that particular NIC. If you put the interface in the promiscuous mode it will receive all the packets. This is very useful to capture packets and analyze them later. For this, you may require superuser access.

```
 ifconfig eth0 - promisc
```

### IP Command

ip command is another useful command-line utility for displaying and manipulating routing, network devices, interfaces. It is a replacement for ifconfig and many other networking commands. (Read our article “What’s Difference Between ifconfig and ip Command” to learn more about it.)

The following command will show the IP address and other information about a network interface.

```
ip addr show

```
To temporarily assign IP Address to a specific network interface (eth0), type.
```
sudo ip addr add 192.168.56.1 dev eth0
```
To remove an assigned IP address from a network interface (eth0), type.

```
sudo ip addr del 192.168.56.15/24 dev eth0
```

To show the current neighbor table in the kernel, type.

```
ip neigh
```


### Netstat Command

Netstat (Network Statistic) command displays connection info, routing table information, etc. To display routing table information use option as -r.

```
netstat -r
```
### Route Command

route command also shows and manipulates the ip routing table. To see the default routing table in Linux, type the following command.

```
route
```

### Add Route in Linux



```
route add -net 10.10.10.0/24 gw 192.168.0.1
```

### Delete Route in Linux


```
route del -net 10.10.10.0/24 gw 192.168.0.1
```

### Add Default Gateway in Linux


```
route add default gw 192.168.0.1
```

### Host Command
host command to find a name to IP or IP to name in IPv4 or IPv6 and also query DNS records.

```
host www.google.com
```
Using -t an option to find out DNS Resource Records like CNAME, NS, MX, SOA, etc.
```
host -t CNAME www.redhat.com
```
ethtool is a replacement for mii-tool. It is to view, setting speed and duplex of your Network Interface Card (NIC). You can set duplex permanently in /etc/sysconfig/network-scripts/ifcfg-eth0 with ETHTOOL_OPTS variable.

```
ethtool eth0
```
### Nmcli and Nmtui Tools
The Nmcli and Nmtui tools are used to configure network settings and also used to manage network devices, create, modify, activate/deactivate, and delete network connections in Linux systems.

```
nmcli

nmtui
```
### NetHogs – Monitor Per Process Network Bandwidth

NetHogs is an open-source nice small program (similar to Linux top command) that keeps a tab on each process network activity on your system. It also keeps a track of real-time network traffic bandwidth used by each program or application.

# nethogs



## Monitor Linux Network Interface

```
sudo ifconfig
OR
sudo ip addr show
```
Then use the -i flag to specify the interface you want to monitor. For example the command below used to monitor bandwidth on the wireless interface on the test computer.

```
sudo iftop -i wlp2s0

sudo iftop -n  eth0
```

To turn on port display, use the -P switch.

```
sudo iftop -P eth0
```


## Listing all Connections

The basic ss command without any options simply lists all the connections regardless of the state they are in.
```
ss
```
## Listing Listening and Non-listening Ports

You can retrieve a list of both listening and non-listening ports using the -a option as shown below.

```
ss -a
```
##  Listing Listening Sockets

To display listening sockets only, use the -l flag as shown.

```
ss -l
```
## List all TCP Connections

To display all TCP connection, use the -t option as shown

```
ss -t
```

## List all Listening TCP Connections

To have a view of all the listening TCP socket connection use the -lt combination as shown.

```
ss -lt
```

## List all UDP Connections

To view all the UDP socket connections use the -ua option as shown.

```
ss -ua
```
## List all Listening UDP Connections

To list listening UDP connections use the -lu option.

```
ss -lu

```

## Display PID (Process IDs) of Sockets

To display the Process IDs related to socket connections, use the -p flag as shown.

```
ss -p
```

## Display Summary Statistics

To list the summary statistics, use the -s option.

```
ss -s
```

##  Display IPv4 and IPv6 Socket Connections

If you are curious about the IPv4 socket connections use the -4 option.

```
ss -4

```

To display IPv6 connections, use the -6 option.

```
ss -6
```

#  Filter Connections by Port Number

```
ss -at '( dport = :22 or sport = :22 )'

ss -at '( dport = :ssh or sport = :ssh )'

```