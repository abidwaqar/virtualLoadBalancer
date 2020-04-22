# virtualLoadBalancer
Creating virtual network that connects network namespaces using a brdige, veth pairs and iptables.

Tutorial Link: https://ops.tips/blog/using-network-namespaces-and-bridge-to-isolate-servers/

After following this tutorial wrote a bash script which will perform the following operations:

1. Creates two network namespaces.
2. Creates two veth pairs as done in tutorial.
3. Creates a linux bridge.
4. Connects both namespaces with bridge using already created veth pairs.
5. Sets up bridge and veth pairs **up** to ensure that they are working.
6. Assigns IP addresses and ping 4 packet from one namespace to the other namespace. Using ping -c 4 to limit ping to four packets. (Packet loss should be zero percent.)
7. Add default route in both namespaces and iptable rule on your machine to enable communication with the internet.
8. Enable ipv4 ip_forwarding.
9. Ping 4 packet to 8.8.8.8 from both namespaces. (packet loss should be zero     percent)
10. Ping **google.com** from both namespaces (This is done by configuring resolv.conf file)
11. Deletes iptables rule, namespaces, veth pairs and linux bridge.