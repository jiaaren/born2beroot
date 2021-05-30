1. Downloading VirtualBox - https://www.virtualbox.org/wiki/Downloads
   1. windows hosts
2. Downloading Debian ISO (Optical Disc Image - CD) file - https://www.debian.org/distrib/
3. Installing Debian - https://linuxhint.com/install_debian10_virtualbox/ (GNOME)
                     - https://www.howtoforge.com/tutorial/debian-minimal-server/ 
4. Using virtual machine
   1. Right Ctrl - Host Key
   2. Partitioning
      1. GRUB - for loading through BIOS?

Sudo
- Installing sudo - https://unix.stackexchange.com/questions/354928/bash-sudo-command-not-found
  - apt-get install sudo -y
- changing to root user
  - "su -" and type in password
- changing users back to jkhong - "su - jkhong" - https://unix.stackexchange.com/questions/156962/how-to-change-to-normal-user-in-the-command-line-when-logged-in-as-the-root-user
- by default, root users can only
  - shutdown/reboot

Configuring SSH
- sudo vim /etc/ssh/sshd_config
  - update port number
  - update permitrootlogin

UFW
- sudo apt install ufw
- sudo ufw allow 4242/tcp
- sudo ufw enable
- sudo ufw status

Group    
- sudo usermod -aG <group> <username>
- sudo groupadd <new_groupname>
- view 
  - user: id <username>
  - group: getent group <groupname>

Password
- modified /etc/login.defs - modified: PASS_MAX_DAYS, PASS_MIN_DAYS and PASS_WARN_AGE to 30, 2, and 7
- Installed libpam-pwquality
- modified /etc/pam.d/common-password, to include: minlen, ucredit, dcredit, maxrepeat, difok, reject_username, enforce_for_root

Change password
- passwd
- for some reason root doesn't comply with difok?

Sudo
- modifying the sudoers file - 
  - sudo visudo
- extended secure_path
- badpass_message
- passwd_tries
- iolog_dir
- log_input, log_output
- requiretty

Monitoring.sh
- ssh
  - modify portforwarding in virtual box
    - ssh -p 1234 jkhong@127.0.0.1
  - ssh-keygen -t rsa -b 4096
- cat ~/.ssh/id_rsa.pub

Cron
- crontab
- */10 * * * * bash/root/monitoring/monitoring.sh
- crontab -e (to edit in vim)

Linux security modules
1. E.g. Apparmor and SELinux
   - cannot run at the same time - why not?
   - What is the difference between both?
2. App armor
   1. Background over Apparmor? - https://wiki.debian.org/AppArmor/HowToUse
   2. Introduction over Apparmor - https://www.youtube.com/watch?v=xF9KDIhIDJQ
   3. Checking status - sudo apparmor_status | more
   4. Starting from Debian v10 onwards Apparmor is configured to run in stardup as default

UFW (uncomplicated firewall)
- blocks all incoming connections, allow all outbound connections, i.e. no one will be able to connect unless we specifically open the port- check status - sudo ufw status
  - will show as inactive first time round
- Default policies


Modifying UFW and SSH - C
Installing UFW - https://linuxize.com/post/how-to-setup-a-firewall-with-ufw-on-debian-10/
1. sudo apt install ufw
2. sudo ufw status verbose (should be inactive)
3. sudo ufw allow OpenSSH (accept SSH connections, not required)
4. SSH - to update port number - https://linuxize.com/post/how-to-change-ssh-port-in-linux/
   1. update SSH config file, update Port and PermitRootLogin
   2. if SSH is still active, restart using 'sudo service ssh restart'
5. sudo ufw enable
6. sudo ufw status numbered (view ufw open ports) 



UFW commands
1. sudo ufw enable
2. sudo ufw disable
3. sudo ufw reset
4. sudo ufw allow
5. sudo ufw status (verbose) - makes sure that OpenSSH (i.e. port 22 is not opened)

Info on SSH
1. https://linuxize.com/post/how-to-set-up-ssh-keys-on-debian-10/
   1. Github uses 4096 bits SSH key pair, need to use command:
      1. ssh-keygen -t rsa -b 4096 -C "your_email@domain.com" (new account?)

SSH host to guest
1. Tried using Guest Additions in virtual box but nothing happens
2. Tried connecting through SSH using NAT/ Bridged Adapter, but ended up sticking to NAT with portforwarding 
   1. https://www.youtube.com/watch?v=oOfZgDxLHrQ&ab_channel=MarcoLucidi
   2. to log into via host 
      1. ssh -p 2000 jkhong42@127.0.0.1 (Use this to confirm that my port connection works, and demonstrate with sudo ufw status that its the only one opened)
      2. 2000 is the random port assigned which is > 1024 

Groups
https://linuxize.com/post/how-to-add-user-to-group-in-linux/
1. display groups of a user - 
   1. id <username> - read 'man id'
2. adding user to group
   1. usermod -a -G <group> <user>
3. remove user
   1. gpasswd -d <user> <group>
4. create group
   1. groupadd <new group name>


User
1. displaying users in group - https://unix.stackexchange.com/questions/241215/how-can-i-find-out-which-users-are-in-a-group-within-linux
   1. getent group <group name>
2. creating new users - https://linuxize.com/post/how-to-create-users-in-linux-using-the-useradd-command/
   1. useradd -m <username> (need m to set user directory)
   2. passwd <username> - need to set password for us to log in as that user
   3. What is 'user home directory?'
3. modifying user information (not really used in project)
      https://linuxize.com/post/usermod-command-in-linux/

Password
https://www.linuxtechi.com/enforce-password-policies-linux-ubuntu-centos/
https://ostechnix.com/how-to-set-password-policies-in-linux/
man pwqualift.conf
man 8 pam_pwquality

- Installed libpam-pwquality
- modified /etc/pam.d/common-password, to include: minlen, ucredit, dcredit, maxrepeat, difok
- modified /etc/login.defs - modified: PASS_MAX_DAYS, PASS_MIN_DAYS and PASS_WARN_AGE to 30, 2, and 7

1. expire every 30 days
2. min number of days before modification of password - 2
   1. (OK) Password expire every 30 days
   2. (OK) Min no of days allowed before modification of password - 2 days
   3. (OK) User to receive warning message 7 days before password expires
   4. (OK) 10 characters long, 1 uppercase, 1 number, no 3 consecutive identical characters
   5. (OK) not incude name of user
   6. (OK) must have at least 7 character which were not part of the previous password
   7. (OK) Of course, Root password has to comply with this policy? - read 'man 8 pam_pwquality' to include enforce_for_root

changing password
- type 'passwd'

Configuring sudo
- modifying the sudoers file 
  - sudo visudo

1. (OK) Authentication using sudo limited to 3 attempts
2. (OK) custom message displayed if error due to wrong password when using sudo
   1. https://www.tecmint.com/sudo-insult-when-enter-wrong-password/
   2. Add an insult - Default    insults
   3. Custom message - badpass_message="Password is wrong, please try again"
3. each action using sudo archived, inputs and outputs - log file saved in /var/log/sudo
   1. iolog_dir (saves to directory)
   2. logfile (saves to file)
4. TTY mode enabled for security
5. restrict paths used by sudo?
   1. /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin 

View hostname
- type 'hostname'





LVM
- Background 
  - https://www.howtogeek.com/howto/36568/what-is-logical-volume-management-and-how-do-you-enable-it-in-ubuntu/
  - https://opensource.com/business/16/9/linux-users-guide-lvm


Lsblk
- background
  - identifying number of partitions, in born2beroot, 3 partitions from sda, i.e sda1, sda2, sda5
  - standard partitions can be identified via the TYPE column, i.e. if 'part' is shown
- overview of header names - https://linuxconfig.org/introduction-to-the-lsblk-command
  1. NAME        - device name (only device name is displayed by default)
  2. MAJ:MIN     - numbers used by kernel to internally identify devices, first number specifying device type (e.g. 8 is for SCSI discs)
  3. RM          - removable, only device marked as removable is sr0, i.e. optical drive
  4. SIZE        - size of device
  5. RO          - read only (displays 1 or 0)
  6. TYPE        - used to identify device or partition type, e.g. crypt, lvm, disk, rom(DVD/CD-ROM device, i.e. optical drive)
  7. MOUNTPOINT  - info on current mountpoint of device

What is GRUB?

Drive partitions
- Why?
  - E.g. drive C & D
  - Use of multiple operating systems in different partitions
  - able to separately reformat or manage disks without disturbing the other
  - Currently - because of NTFS - partitioning not as important as before
Logical Volume Manager (LVM)
- creation of 'groups' of disks or partitions that can be assembled into a single (or multiple) file systems


Monitoring bash script
1. OS and kernel version
   1. uname -a (https://linux.die.net/man/1/uname)
   2. hostnamectl
   3. lsb_release -a
   4. cat /etc/os-release
2. Physical
   1. lscpu
   2. nproc
3.  and virtual cpus??
    1.  https://webhostinggeeks.com/howto/how-to-display-the-number-of-processors-vcpu-on-linux-vps/
4.  RAM
    1.  short script -  free -t | awk 'NR == 2 {print "Current Memory Utilization is : " $3/$2*100}' - 
         https://www.2daygeek.com/linux-check-cpu-memory-swap-utilization-percentage/
    2.   /proc/meminfo
    3.   free
5.   Disc size
     1.   df -l -T --total | grep total
6.   CPU usage ??
     1.   mpstat
     2.   https://support.site24x7.com/portal/en/kb/articles/how-is-cpu-utilization-calculated-for-a-linux-server-monitor
7. last reboot - https://www.cyberciti.biz/tips/linux-last-reboot-time-and-date-find-out.html
   1.  last reboot | head -1
   2.  who -b
8.  LVMs?
    1.  just use lsblk and filter through?, count how many of lvm, if more than 0 print yes

9.  TCP connections established (https://www.cyberciti.biz/faq/check-network-connection-linux/)
    1.  ss -s

10. Project requirements
   3. Choose operating systems - either Debian or CentOS
      1. Debian recommended if new to system admin, CentOS complex
      2. Questions
         1. What is Debian/CentOS actually?
         2. Why choose Debian/CentOS? (or other OS for the matter)
         3. Debian - choose Debian latest stable (no testing/unstable)?
         4. CentOS - latest stable?
         5. CentOS - what is KDump? SELinux needs to be running at startup?
         6. Debian - Apparmor must be running at startup?
         7. What is difference between aptitude and apt?
   4. Setting up configuration files
      1. Create 2 encrypted partitions using LVM
         1. Questions
            1. What is LVM?
            2. How do i create the expected partitioning (per the picture)?
      2. SSH service - 
         1. to run on port 4242 only
         2. Security reasons - must not be possible to connect using SSH as root
         3. Will be tested during eval by creation of a new account
            1. What does creating a new account even mean?
      3. Configure firewall
         1. configure with UFW firewall
         2. Leave only port 4242 open
            1. What does this really mean?
         3. Firewall must be active when launching virtual machine
            1. CentOS - have to use UFW instead of default firewall, need DNF to probably install it
      4. Others
         1. Hostname of VM - login ending with 42 (i.e. jkhong42)
         2. Implement strong password policy
            1. What does this even mean? Password for logging in into what?
               1. Password expire every 30 days
               2. Min no of days allowed before modification of password - 2 days
               3. User to receive warning message 7 days before password expires
               4. 10 characters long, 1 uppercase, 1 number, no 3 consecutive identical characters
               5. not incude name of user
               6. must have at least 7 character which were not part of the previous password
               7. Of course, Root password has to comply with this policy? 
         3. Configure and install sudo following strict rules
            1. What is sudo?
            2. What is strict rules?
         4. In addition to root user, a user with my login as username has to be present
            1. User has to be long to the user42 and sudo groups
               1. What are groups?
            2. During defense, need to create a new user and assign it to a group.


LAMP
https://www.youtube.com/watch?v=WY8jwTNYTfg&ab_channel=%28mt%29MediaTemple%28mt%29MediaTemple
- Solution stack used to build web application servers
- Easy to install, ideal for development environments
- most common stack used for hosting websites
- Linux (OS) - Apache (web server software) - Mysql - PHP (all open source)
- OS - based foundation of where the rest can run
- Apache - Receives and handles all requests from users (e.g. people may be requesting html, jpeg files)
- PHP - generating dynamic webpages
  - apache first sends http to PHP and then sends the http back to the user
- database engine - data needed to generate PHP


Lighttpd
- apt-get install lighttpd
- enable disable start stop
  - sudo systemctl <command> lighttpd
- check in conjunction with 
  - sudo ufw status
  - ss -tunlp
- after installing
  - making sure TCP is allowed
  - and lighttpd is enabled and started
  - and port forwarding is set correctly
  - should be able to access site via 127.0.0.1

Check status of lighttpd
sudo systemctl status lighttpd


uninstall apache2
- apt-get remove --purge


purge apache (no need any more)
install ilghttpd
enable tcp
Status - sudo systemctl status <any program>
apt-get install mariadb-server
https://www.how2shout.com/linux/install-wordpress-on-lighttpd-web-server-ubuntu/
sudo systemctl status mariadb

sudo apt-get autoclean
sudo apt-get clean

apparently 127.0.0.1 still works upon start up

Installing mariadb
apt-get install mariadb-server

suddenly no space
https://askubuntu.com/questions/178909/not-enough-space-in-var-cache-apt-archives
ran some commands here


How virtual machine works
- Virtualisation technology
  - Simulate virtual hardware
  - Allows multiple VMs on a single machine
  - Physical machine (host), VMs (guests)
- Managed by hypervisor software
  - responsible managing and provisioning (memory & storage) from hosts to guests
  - also resp for virtualising VMs

CentOS vs Debian
https://www.educba.com/centos-vs-debian/
CentOS
- more stable supported by larger community
- slight edge over desktop applications
- maintained for long (10 years) - great support for enterprise applications
- very stable (updates are released after long gap)

Debian
- more packages
- used for servers more often
- upgrading to newer (stable) version is easy and not painful
- desktop friendly applications 

Aptitude and apt
https://www.tecmint.com/difference-between-apt-and-aptitude/#:~:text=What%20is%20Aptitude%3F,and%20install%20or%20remove%20it.&text=One%20of%20its%20highlight%20is,apt%2Dget's%20command%20line%20arguments.
- Package management (i.e. software) installation and removal
- Designed for debian packages

Apt
- when entered, searches packages (software) in ‘/etc/apt/sources.list’

- low level
- only CLI

Aptitude
- adds user interface to the functionality
- can emulate apt-get's command line arguments

- high level
- vaster in functionality, integrates apt-get, and apt-mark and apt-cache
- additional functions: (i) marking package to be manually or automatically installed, (Ii) holding package making it unable for upgradation
- better for conflict resolution
- CLI and text

AppArmor
https://www.youtube.com/watch?v=KYM-Dzivnjs&ab_channel=ChrisTitusTechChrisTitusTech
- Debian based SELinux
- restrict access to application / scripts / program to only do certain things
- Also allows set up of profiles to limit access the program
- can view profiles in apparmor_status

Simple set up
- sudo systemctl status ufw
  - sudo ufw status
- sudo systemctl status ssh
- OS name - 
  - head -n2 /etc/os-release

User
- id jkhong
- sudo adduser jiaren
- modified /etc/login.defs
- modified /etc/pam.d/common-password

- sudo usermod -aG <group> <username>
- sudo groupadd <new_groupname>

- sudo chage -l <username>
   
Hostname and partitions
- hostname
- changing (https://linuxize.com/post/how-to-change-hostname-on-debian-10/)
  - sudo hostnamectl set-hostname <new hostname>
  - sudo vim /etc/hosts
Explanation of lvm
- resize/ w/o losing information
- physical partition may result in data corrput
   
Sudo
-installed
- sudo usermod -aG sudo jiaren
- sudo visudo
- cd /var/log/sudo
  - change to root
  - sample sudo - echo


UFW
- uncomplicated firewall
- blocks all tcp access (if switched on)
- sudo ufw allow 8080/tcp
- sudo ufw delete allow 8080/tcp

SSH
- sudo systemctl status ssh
- secure shell (SSH)
  - before anybody can intercept
  - secure way to access between unsecured network
  - uses cryptography
  - without SSH package can be opened by anybody
  - with SSH - package is locked - when i receive it 
sudo vim /etc/ssh/sshd_config
test ssh
-  with and without root user

Monitoring
- cron
- crontab -e
- * * * * * sleep 30;
- */10 * * * * *
   /etc/init.d/cron stop
/etc/init.d/cron start
   
Bonuses
- partitions - lsblk
- Wordpress
  - sudo systemctl status lighttpd
  - sudo systemctl status mariadb
  - php -v
  - 127.0.0.1/wp

Borg
- deduplication (eliminating duplicate or redundant information)
- each file is split into a number of variable length chunks
- only chunks that have never been seen before are added to the repository

Advantages
- file and directory names can be the same
- if big file changes a little, only minor changes need to be made
- stuff may get shifted but still undergo deduplication
- speed of backup, easy installation, free and open source software
   
Download
- apt-get install borgbackup
Creating backup folder
- mkdir <backupfile>
- need to locate where are the backup files too
Initialising without encryption
  - borg init --encryption none <backupfile>/
crontab
- */15 * * * * borg create <backup destination>::File-$(date '+\%d-\%m-\%Y_\%H:\%M:\%S') <source folder>
- e.g.: */15 * * * * borg create ~/backup::File-$(date '+\%d-\%m-\%Y_\%H:\%M:\%S') ~/downloads
viewing backups
- borg list <filename>
- e.g. borg list ~/backup
Extracting
- need extraction folder
  - mkdir <extraction folder>
- run inside extraction folder
  - borg extract <backup folder>::<backup name> <source folder>
  - borg extract ~/backup::<backup name> home/jkhong/downloads
Checking file size
-  du -sh <filename>

du -h <filename>

   
