#!/bin/sh
#bridge_setup.sh

ifconfig eth0 down
ifconfig eth1 down
ifconfig eth0 0.0.0.0
ifconfig eth1 0.0.0.0
ifconfig eth0 down
ifconfig eth1 down

brctl addbr br0
#brctl stp br0 off
brctl addif br0 eth0
wait $!
brctl addif br0 eth1
wait$!

ip link set eth0 up
ip link set eth1 up
ip link set br0 up

echo 'starting dhcp client'
dhclient br0
