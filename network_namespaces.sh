#!/bin/bash

#Creating Namespaces
sudo ip netns add I16-0229-1
sudo ip netns add I16-0229-2

#Creating veth pairs
sudo ip link add veth1 type veth peer name br-veth1
sudo ip link add veth2 type veth peer name br-veth2

#Creating Linux Bridge
sudo ip link add br1 type bridge

#Associating namespaces with bridge using veth pairs

#setting veth front end with namespaces
sudo ip link set veth1 netns I16-0229-1
sudo ip link set veth2 netns I16-0229-2

#setting veth backend with bridge
sudo ip link set br-veth1 master br1
sudo ip link set br-veth2 master br1

#Setting up bridge and veth pairs up
sudo ip link set br1 up
sudo ip link set br-veth1 up
sudo ip link set br-veth2 up
sudo ip netns exec I16-0229-1 ip link set veth1 up
sudo ip netns exec I16-0229-2 ip link set veth2 up

#Assigning IP addresses
sudo ip netns exec I16-0229-1 ip addr add 192.168.1.11/24 dev veth1
sudo ip netns exec I16-0229-2 ip addr add 192.168.1.12/24 dev veth2
sudo ip addr add 192.168.1.10/24 brd + dev br1

#ping second namespace
sudo ip netns exec I16-0229-1 ping 192.168.1.12 -c 4

#adding default gateway
sudo ip -all netns exec ip route add default via 192.168.1.10
sudo iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -j MASQUERADE
sudo sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec I16-0229-1 ping 8.8.8.8 -c 4

#Command to cocnfigure google.com
sudo apt update
sudo apt install resolvconf
sudo echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
sudo echo 'nameserver 8.8.4.4' >> /etc/resolv.conf
sudo systemctl start resolvconf.service

#Pinging google.com
sudo ip netns exec I16-0229-1 ping google.com -c 4
sudo ip netns exec I16-0229-2 ping google.com -c 4

#deleting
sudo iptables -t nat -D POSTROUTING -s 192.168.1.0/24 -j MASQUERADE
sudo ip netns del I16-0229-1
sudo ip netns del I16-0229-2
sudo ip link delete veth1
sudo ip link delete veth2
sudo ip link set br1 down
sudo brctl delbr br1
