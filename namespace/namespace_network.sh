ip netns add a
ip netns help
ip nens delete a

################# add namespace for network
ip netns add nsa
ip netns add nsb

############### show namespace
ip netns
or 
ip netns show

#################### exec to namespace or connect to namespace for network
ip netns exec nsb bash
ip link set lo up
ip link add vetha type veth peer name vethb
ip link show
ip link set veth netns nsb
ip link show
ip addr add 192.168.10.1/24 dev vethb
ip link set vethb up
ip addr show
#################### exec to namespace or connect to namespace for network nsb
ip netns exec nsb bash
ip link set lo up
ip link add vethb type veth peer name vetha
ip addr add 192.168.10.2/24 dev vetha
ip link set vetha up
#################### for routing in namesmapce u need change ip_forward
cat /proc/sys/net/ipv4/ip_forward --> 0
echo 1 > /proc/sys/net/ipv4/ip_forward
########



