#!/bin/bash
#fw4_setup.sh

#Flush rules
iptables -F
iptables -X

#DEFAULTS POLICIES

iptables -P INPUT DROP
#ACCEPT OUTPUT FOR SSH AND OTHER SERVICES
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

#INPUT/OUTPUT TABLE

#Allow everythin on the loopback interface
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#Allow USB interface communication (requires physical access)
iptables -A INPUT -i usb0 -j ACCEPT
iptables -A OUTPUT -o usb0 -j ACCEPT

#Deny everything that's not on the bridge
iptables -A INPUT -i eth0 -j DROP
iptables -A INPUT -i eth1 -j DROP
iptables -A OUTPUT -o eth0 -j DROP
iptables -A OUTPUT -o eth1 -j DROP

#ALLOW ESTABLISHED CONNECTIONS (see arch wiki simple statefull firewall)
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT

#ALLOW SERVICES
iptables -A INPUT -p tcp --dport 3141 -j ACCEPT #SSH

#FORWARD TABLE

#Set badnwidth limit
iptables -t mangle -I OUTPUT -m set --match-set slowips dst,src -j CLASSIFY --set-class 1:12

#Allow established connnections
iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD -m state --state INVALID -j DROP

#Allow DHCP to and from private LAN
iptables -A FORWARD -p udp --dport 67:68 -j ACCEPT
iptables -A FORWARD -p udp --sport 67:68 -j ACCEPT

#Allow connections to Albufer VPN 0
iptables -A FORWARD -m physdev --physdev-in eth1 --physdev-out eth0 -d 78.46.150.244 -j ACCEPT
#Allow connections to Albufer VPN 1
iptables -A FORWARD -m physdev --physdev-in eth1 --physdev-out eth0 -d 144.76.47.106 -j ACCEPT
#DNS
iptables -A FORWARD -m physdev --physdev-in eth1 --physdev-out eth0 -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -m physdev --physdev-in eth0 --physdev-out eth1 -p udp --sport 53 -j ACCEPT

#Drop traffic to private LAN
iptables -A FORWARD -m physdev --physdev-in eth1 --physdev-out eth0 -d 192.168.0.0/24 -j DROP

#Reject traffic from private LAN to FF Router
iptables -A FORWARD -m physdev --physdev-in eth0 --physdev-out eth1 -j REJECT
