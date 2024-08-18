

This document provides step-by-step instructions for setting up and managing an Open vSwitch (OVS) bridge, adding ports, configuring networking, and inspecting the setup.

1. Create a New OVS Bridge
Command:
```bash
ovs-vsctl add-br mybridge
```

2. Display OVS Configuration
Command:
```bash
ifconfig mybridge up

```

4. Delete the OVS Bridge
Command:
```bash
ovs-vsctl del-br mybridge

```
5. Add a Physical Interface to the OVS Bridge
Command:
```bash
ovs-vsctl add-port mybridge eth0

```

6. Display OVS Configuration (After Adding Port)
Command:
```bash
ovs-vsctl show

```
8. Clear IP Address of eth0
Command:

```bash
ifconfig eth0 0

or

ip addr flush dev eth0


```
9. Obtain IP Address for the OVS Bridge
Command:
```bash
dhclient mybridge

```

10. Display Routing Table
Command:

```bash
route -n

```
11. Create Virtual Network Interfaces (TAP)
Commands:
```bash
ip tuntap add mode tap vport1
ip tuntap add mode tap vport2
ifconfig vport1 up
ifconfig vport2 up

or
ip tuntap add mode tap vport1
ip tuntap add mode tap vport2
ip link set vport1 up
ip link set vport2 up



```
Description:
These commands create two virtual network interfaces (vport1 and vport2) in TAP mode, which can be used for network bridging or tunneling.

12. Add Virtual Interfaces to OVS Bridge
Command:

```bash
ovs-vsctl add-port mybridge vport1 -- add-port mybridge vport2

```

13. Display OVS Configuration (After Adding Virtual Ports)
Command:

```bash
ovs-vsctl show

```

14. Display Runtime Data for the OVS Bridge
Command:
```bash
ovs-vsctl rdb/show mybridge

```
Description:
This command shows the runtime database for mybridge, providing detailed information about the bridge’s current state.

15. Display OpenFlow Switch Details
Command:

```bash
ovs-ofctl show mybridge


```

16. Dump OpenFlow Flows
Command:

```bash
ovs-ofctl dump-flows mybridge

```
Description:
This command dumps all OpenFlow flows currently installed on mybridge, providing visibility into how traffic is being handled by the OVS.

17. List All OVS Bridges
Command:

```bash
ovs-vsctl list Bridge

```
Description:
This command lists all OVS bridges configured on the system, along with their properties.

18. List All OVS Ports
Command:
```bash
ovs-vsctl list Port | more

```
19. List All OVS Interfaces
Command:
```bash
ovs-vsctl list Interface

```


# Open vSwitch Configuration and Networking Setup

This document provides step-by-step instructions for setting up and managing an Open vSwitch (OVS) bridge, adding ports, configuring networking, and inspecting the setup.

![OVS Network Setup Diagram](./VXLAN5.png)