#!/bin/bash

#Architecture
uname -a | awk '{printf "#Architecture: " $0 "\n"}'

#CPU physical
nproc | awk '{printf "#CPU physical: " $0 "\n"}'

#vCPU


#Memory usage
free -m | awk 'NR == 2 {printf "#Memory Usage : %d/%dMB (%.2f%%)\n", $3, $2, $3/$2*100}'

#Disk usage


#CPU usage


#Last boot
who -b | awk '{printf "#Last boot: %s %s\n", $3, $4}'

#LVM use
lsblk --list -o TYPE | grep lvm | wc -l | awk '{printf "#LVM use: "
	if ($1 == "0")
		print "no"
	else
		print "yes"
	}'

#TCP connections
ss -s | grep TCP | awk 'NR==1 {printf "#TCP Connections: %d ESTABLISHED\n", $4}'

#User log
who | wc -l | awk '{printf "#User log: %d\n", $1}'

#Network
ip route | awk 'NR==2 {printf "#Network: IP %s ", $9}'
ip addr show enp0s3 | grep "link/ether " | awk '{printf "(%s)\n", $2}'

#Sudo
cat /var/log/sudo/sudo.log | grep TSID | wc -l | awk '{printf "#Sudo: %s cmd\n", $1}'
