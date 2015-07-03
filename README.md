#ffka-bridge-fw

Freifunk (see http://freifunk.net/en/) is a movement in Germany to connect a second router (Freifunk router) that provides (via WLAN) free internet to your neighbours or the bus station in front of your house. However in Germany open WLANs can get their operators into trouble if a client uses this open WLAN for illegal activities due to a law known as Störerhaftung. This is why Freifunk router of younger communities have a built in VPN connection, but: "Programmierer rechnen mit Einsen, Nullen, Hexadezimalen, Zeigern, kurz mit Allem und vor allem mit dem Schlimmsten." That means: We're paranoid. So what can you do to protect your private network in case someone hacks his way into your Freifunk router? The most radical solution is to leave the Freifunk router powered off, a better, less radical solution is to build a firewall in bridge mode out of linux and some hardware you actualy wouldn't need anymore. So whether you're setting up a firewall for a second router (could be a Freifunk router or a transparent VPN or Tor proxy) or you're curious about iptabels and bridge firewalls: Here you'll find scripts to setup the bridge and the iptables rules.

#Install

After you got your Linux box up and running with two network interfaces (most probably ethernet) and a connection to the box (e.g. via serial) copy the scripts into a directory like /bin/scripts and make sure they're exacutable (e.g. # chmod 755 setup.sh). Make sure you adapt the scripts to your needs: The newtork interfaces could have different names, maybe you wnat to disable the ssh connection, disable/enable ipv6, allow connections to a different ipaddress, disable bandwidth limit... The setup for which these scripts has been written for is described below. The next step is to execute setup.sh and your bridge firewall should be up and running. Because the firewall might get rebooted (due to whatever reason) you should make sure that the firewall is automatically set up during boot, for e.g. systemd have a look at https://wiki.archlinux.org/index.php/Systemd_FAQ#How_can_I_make_a_script_start_during_the_boot_process.3F .

# Network setup

This is the setup for which this script has been designed:

Internet <-> home_router <- private lan -> bridge_firewall <-> ffka_router ( <- ffka WLAN -> ffka_client(s) )

bridge_firewall:
  has an ip address in the private lan (you might prefer to change this for a real bridged fireall)
  
  allow ssh into it from the private LAN via ipv4 and (globally) via ipv6 (you might prefer to change this too)
  
  deny ssh into it from the ffka_router
  
  allow connections from the ffka_router to its VPN
  
  allow dhcp traffic from the ffka_router to the home_router and back
  
  allow the freifunk_router to perform dns lookups
  
  (limit bandwidth) WARNING: The current settings for limiting bandwidth were not tested. If you buy a router that's cheap enough, it's already limited ;)
  
  if a connection is not allowed, forbid it (e.g. connections from the ffka_router to the home_router)


Freifunk on IRC: irc.hackint.net #freifunk

Freifunk Karlsruhe config: https://github.com/ffka/site-ffka/blob/master/site.conf
