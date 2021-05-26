#!/bin/bash

#Architecture
uname -a | awk '{printf "#Architecture: " $0 "\n"}'

#CPU physical
nproc | awk '{printf "#CPU physical: " $0 "\n"}'

#vCPU
cat /proc/cpuinfo | grep processor | wc -l | awk '{printf "#vCPU: %d\n", $0}'

#Memory usage
free -m | awk 'NR == 2 {printf "#Memory Usage : %d/%dMB (%.2f%%)\n", $3, $2, $3/$2*100}'

#Disk usage
df --block-size=1048576 --total | grep '^/dev/' \
	| awk '{total_space+=$2}{used_space+=$3}END{printf "#Disk Usage: %.1f/%.1fGb (%.f%%)\n", used_space/1000, total_space/1000, used_space/total_space*100}'

#CPU usage
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" \
	| awk '{printf "#CPU load: %.1f%%\n", 100 - $1}'

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
