#!/bin/bash

#modprobe ip_conntrack_ftp
#modprobe nf_conntrack_ftp

# vars
IPT="/sbin/iptables"
IPT6="/sbin/ip6tables"
echo " * IPv4 policy
==================================================
"
echo " ** flush old policies for IPv4"
$IPT -F
$IPT -X

echo " ** setting default policies for IPv4"
$IPT -P INPUT DROP
$IPT -P OUTPUT DROP
$IPT -P FORWARD DROP

echo " ** allowing IPv4 loopback devices"
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT

echo " ** Allow established and related packets
"
$IPT -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

echo " * Open the following ports on INPUT chain
--------------------------------------------------"
echo " ** allowing ftp on port 20 for IPv4"
$IPT -A INPUT -p tcp --dport 20  -m state --state NEW -j ACCEPT

echo " ** allowing ftp on port 21 for IPv4"
$IPT -A INPUT -p tcp --dport 21  -m state --state NEW -j ACCEPT

echo " ** allowing sftp on port 22 for IPv4"
$IPT -A INPUT -p tcp --dport 22  -m state --state NEW -j ACCEPT

echo " ** allowing smtp on port 25 for IPv4"
$IPT -A INPUT -p tcp --dport 25  -m state --state NEW -j ACCEPT

echo " ** allowing dns on port 53 for IPv4"
$IPT -A INPUT -p udp -m udp --dport 53 -j ACCEPT

echo " ** allowing http on port 80 for IPv4"
$IPT -A INPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT

echo " ** allowing imap on port 143 for IPv4"
$IPT -A INPUT -p tcp --dport 143 -m state --state NEW -j ACCEPT

echo " ** allowing https on port 443 for IPv4"
$IPT -A INPUT -p tcp --dport 443 -m state --state NEW -j ACCEPT

echo " ** allowing smtps on port 465 for IPv4"
$IPT -A INPUT -p tcp --dport 465 -m state --state NEW -j ACCEPT

echo " ** allowing imaps on port 993 for IPv4"
$IPT -A INPUT -p tcp --dport 993 -m state --state NEW -j ACCEPT

echo " ** allowing monit on port 2812 for IPv4"
$IPT -A INPUT -p tcp --dport 2812 -m state --state NEW -j ACCEPT

echo " ** allowing sieve on port 4190 for IPv4"
$IPT -A INPUT -p tcp --dport 4190 -m state --state NEW -j ACCEPT

echo " ** allowing bittorrent-tracker on port 6881 for IPv4"
$IPT -A INPUT -p tcp --dport 6881 -m state --state NEW -j ACCEPT

echo " ** allowing http-proxy on port 8080 for IPv4"
$IPT -A INPUT -p tcp --dport 8080 -m state --state NEW -j ACCEPT

echo " ** allowing ssh on port 45626 for IPv4"
$IPT -A INPUT -p tcp --dport 45626 -m state --state NEW -j ACCEPT

echo " ** allowing munin on port 4949 for IPv4"
$IPT -A INPUT -p tcp --dport 4949 -m state --state NEW -j ACCEPT

echo " ** allowing jabber without SSL on port 5222 for IPv4"
$IPT -A INPUT -p tcp --dport 5222 -m state --state NEW -j ACCEPT

echo " ** allowing jabber with SSL on port 5223 for IPv4"
$IPT -A INPUT -p tcp --dport 5223 -m state --state NEW -j ACCEPT

echo " ** allowing jabber on port 5269 for IPv4"
$IPT -A INPUT -p tcp --dport 5269 -m state --state NEW -j ACCEPT

echo " ** allowing jabber on port 5347 for IPv4"
$IPT -A INPUT -p tcp --dport 5347 -m state --state NEW -j ACCEPT

echo " ** allowing ntp on port 123 for IPv4"
$IPT -A INPUT -p udp --dport 123 -j ACCEPT

echo " ** allowing ping responses for IPv4"
$IPT -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT

#echo " ** enable the Syn-flood protection on IPv4"
# $IPT -A INPUT -p tcp --syn -m limit --limit 1/s -j ACCEPT

echo " ** enable the PortScan Protection on IPv4"
$IPT -A INPUT -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT

echo " * Open the following ports on OUTPUT chain
--------------------------------------------------"
echo " ** allowing DNS on port 53"
$IPT -A OUTPUT -p udp --dport 53 -j ACCEPT

echo " ** allowing ICMP ping"
$IPT -A OUTPUT -p icmp -j ACCEPT

echo " ** allowing NTP on port 123
"
$IPT -A OUTPUT -p udp --dport 123 -j ACCEPT
echo " * LOG and drop policy
--------------------------------------------------"
echo " ** drop everything else in OUTPUT chain and Log it"
$IPT -A OUTPUT -j LOG --log-prefix "OUTPUT_DROP: "
$IPT -A OUTPUT -j DROP
echo " ** drop everything else in FORWARD chain"
$IPT -A FORWARD -j DROP
echo " ** drop everything else in INPUT chain and Log it
"
$IPT -A INPUT -j LOG --log-prefix "INPUT_DROP: "
$IPT -A INPUT -j DROP
####################################################################################
#                                                                                  #
#                                 IPv6 Policy                                      #
#                                                                                  #
####################################################################################
echo " * IPv6 Policy
==================================================
"
echo " ** flush old policies for IPv6"
$IPT6 -F
$IPT6 -X
#$IPT6 -t mangle -F
#$IPT6 -t mangle -X

echo " ** allowing IPv6 loopback devices"
$IPT6 -A INPUT -i lo -j ACCEPT
$IPT6 -A OUTPUT -o lo -j ACCEPT

echo " ** setting default policies for IPv6"
$IPT6 -P INPUT DROP
$IPT6 -P OUTPUT DROP
$IPT6 -P FORWARD DROP

echo " ** Allow established and related packets
"
$IPT6 -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT6 -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

#
# INPUT chain
#
echo " * Open the following ports on INPUT chain
--------------------------------------------------"
echo " ** allowing sftp on port 22 for IPv6"
$IPT6 -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT

echo " ** allowing dns on port 53 for IPv6"
$IPT6 -A INPUT -p udp -m udp --dport 53 -j ACCEPT

echo " ** allowing http on port 80 for IPv6"
$IPT6 -A INPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT

echo " ** allowing https on port 443 for IPv6"
$IPT6 -A INPUT -p tcp --dport 443 -m state --state NEW -j ACCEPT

echo " ** allowing ssh on port 45626 for IPv6"
$IPT6 -A INPUT -p tcp --dport 45626 -m state --state NEW -j ACCEPT

#
# DDOS Protection on IPv6
#

echo " ** allowing ping responses for IPv6"
$IPT6 -A INPUT -p ipv6-icmp -m limit --limit 1/s -j ACCEPT

#echo " ** enable the Syn-flood protection on IPv6"
# $IPT6 -A INPUT -p tcp --syn -m limit --limit 1/s -j ACCEPT

echo " ** enable the PortScan Protection on IPv6
"
$IPT6 -A INPUT -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT

#
# OUTPUT chain for IPv6
#

echo " * Open the following ports on OUTPUT chain
--------------------------------------------------"
echo " ** allowing DNS on port 53"
$IPT6 -A OUTPUT -p udp --dport 53 -j ACCEPT

echo " ** allowing ICMP ping
"
$IPT6 -A OUTPUT -p ipv6-icmp -j ACCEPT

#
# LOG, and DROP steeings for INPUT, OUTPUT and FORWARD chain for IPv6
#
echo " * LOG and drop policy
--------------------------------------------------"
echo " ** drop everything else in OUTPUT chain and Log it in IPv6"
$IPT6 -A OUTPUT -j LOG --log-prefix "OUTPUT_DROP: "
$IPT6 -A OUTPUT -j DROP
echo " ** drop everything else in FORWARD chain in IPv6"
$IPT6 -A FORWARD -j DROP
echo " ** drop everything else in INPUT chain and Log it in IPv6"
$IPT6 -A INPUT -j LOG --log-prefix "INPUT_DROP: "
$IPT6 -A INPUT -j DROP