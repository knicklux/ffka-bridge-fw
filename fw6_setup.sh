#!/bin/bash
#fw6_setup.sh

#Flush rules
ip6tables -F
ip6tables -X

#Allow everything on loopback
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT

#Drop every incoming connection
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
#Allow outgoing connections
ip6tables -P OUTPUT DROP

#Allow established connections from br0
ip6tables -A INPUT -i br0 -m state --state ESTABLISHED,RELATED -j ACCEPT
ip6tables -A OUTPUT -o br0 -m state --state ESTABLISHED,RELATED -j ACCEPT

#Allow Forwarding from br0 to eth0
ip6tables -A FORWARD -i br0 -o eth0 -j ACCEPT

#Allow ICMP to br0
ip6tables -A INPUT -i br0 -p ipv6-icmp -j ACCEPT
ip6tables -A OUTPUT -o br0 -p ipv6-icmp -j ACCEPT

#Allow Services
ip6tables -A INPUT -i br0 -p tcp --destination-port 3141 -j ACCEPT
ip6tables -A INPUT -i eth0 -p tcp --dport 3141 -j ACCEPT

#Drop everything not allowed
ip6tables -A INPUT -i br0 -j DROP

#Drop traffic on ethernet interfaces
ip6tables -A INPUT -i eth0 -j REJECT
ip6tables -A OUTPUT -o eth0 -j REJECT
ip6tables -A INPUT -i eth1 -j REJECT
ip6tables -A OUTPUT -o eth1 -j REJECT
