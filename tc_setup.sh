#!/bin/bash
tc qdisc add dev eth1 parent root handle 1: hfsc default 11
tc class add dev eth1 parent 1: classid 1:1 hfsc sc rate 100mbit ul rate 100mbit

#fast queue (1:11)
tc class add dev eth1 parent 1:1 classid 1:11 hfsc sc rate 50mbit ul rate 20mbit
#slow queue (1:12)
tc class add dev eth1 parent 1:1 classid 1:12 hfsc sc rate 15mbit ul rate 5mbit

tc qdisc add dev eth1 parent 1:11 handle 11:1 pfifo
tc qdisc add dev eth1 parent 1:12 handle 12:1 pfifo

#create ipset
ipset create slowips hash:ip,port

#Add AlbuferVPN to slow queue
ipset add slowips 78.46.150.244
ipset add slowips 144.76.47.106
