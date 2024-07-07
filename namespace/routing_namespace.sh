routing = enable
router = core
namespace =a,b,c,d
veth a 192.168.10.1/24
veth b 192.168.20.1/24
veth c 192.168.30.1/24

a:
 core 192.168.10.10/24


############ in server
ip netns add core
ip netns add a
ip netns add b
ip netns add c
ip link add core type veth peer name nsa
ip link set core netns a
ip link set nsa netns core

ip link add core type veth peer name nsb
ip link set core netns b
ip link set nsb netns core

ip link add core type veth peer name nsc
ip link set core netns c
ip link set nsc netns core
######################## exec in namespace core
ip netns exec core bash
cat /proc/sys/netns/ipv4_forward
echo 1 > /proc/sys/netns/ipv4_forward
ip l
ip link set lo up
ip addr add 192.168.10.1/24 dev nsa
ip addr add 192.168.20.1/24 dev nsb
ip addr add 192.168.30.1/24 dev nsc

ip a |grep inet   ### show interface
ip link set nsa up
ip link set nsb up
ip link set nsc up
ip r or route
ping 192.168.10.10 

####################### exec namespace a
ip netns exec a bash
ip l
ip link set lo up
ip addr add 192.168.10.10/24 dev core
ip link set core up
#ip route add 192.168.30.0/24 via 192.168.10.1 dev core
ip route add default via 192.168.10.1
####################### exec namespace b
ip netns exec b bash
ip l
ip link set lo up
ip addr add 192.168.20.10/24 dev core
ip link set core up
ip route add default via 192.168.20.1
####################### exec namespace c
ip netns exec c bash
ip l
ip link set lo up
ip addr add 192.168.30.10/24 dev core
ip link set core up
ip route add 192.168.10.0/24 via 192.168.30.1 dev core
ip route del 192.168.10.0/24
ip route add default via 192.168.30.1

