## Submission

- [Submission](#submission)
	- [**How virtual machine works**](#how-virtual-machine-works)
	- [**CentOS vs Debian**](#centos-vs-debian)
		- [CentOS](#centos)
		- [Debian](#debian)
	- [**Aptitude and apt**](#aptitude-and-apt)
		- [Both are:](#both-are)
		- [Apt](#apt)
		- [Aptitude](#aptitude)
	- [**AppArmor**](#apparmor)
		- [Background](#background)
		- [Commands](#commands)
	- [**User and groups**](#user-and-groups)
		- [Commands](#commands-1)
	- [**Hostname and partitions**](#hostname-and-partitions)
	- [**Sudo**](#sudo)
	- [**UFW**](#ufw)
		- [Background](#background-1)
		- [Commands](#commands-2)
	- [**SSH (Secure Shell)**](#ssh-secure-shell)
		- [Background](#background-2)
		- [Commands](#commands-3)
	- [**Monitoring & cron**](#monitoring--cron)
	- [**Bonuses**](#bonuses)
		- [Partitions](#partitions)
		- [Wordpress](#wordpress)
		- [Borg (bonus application)](#borg-bonus-application)
		- [Download & Setup](#download--setup)
		- [Creating and initialising (without encryption) backup folder](#creating-and-initialising-without-encryption-backup-folder)
		- [Creating backup cycle and setting up with cron](#creating-backup-cycle-and-setting-up-with-cron)
		- [Viewing backups](#viewing-backups)
		- [Extracting backup files](#extracting-backup-files)
	- [**Random**](#random)

### **How virtual machine works**
- Virtualisation technology
	- Simulate virtual hardware
	- Allows multiple VMs on a single machine
	- Physical machine (host), VMs (guests)
- Managed by hypervisor software
	- responsible managing and provisioning (memory & storage) from hosts to guests
	- also resp for virtualising VMs

### **CentOS vs Debian**
- https://www.educba.com/centos-vs-debian/
#### CentOS
- more stable supported by larger community
- slight edge over desktop applications
- maintained for long (10 years) - great support for enterprise applications
- very stable (updates are released after long gap)

#### Debian
- more packages
- used for servers more often
- upgrading to newer (stable) version is easy and less painful

### **Aptitude and apt**
- https://www.tecmint.com/difference-between-apt-and-aptitude/#:~:text=What%20is%20Aptitude%3F,and%20install%20or%20remove%20it.&text=One%20of%20its%20highlight%20is,apt%2Dget's%20command%20line%20arguments.
#### Both are:
- Package management (i.e. software) installation and removal
- Designed for debian packages

#### Apt
- when entered, searches packages (software) in ‘/etc/apt/sources.list’
- low level
- accessed via command line interface (CLI)

#### Aptitude
- adds user interface to the functionality
- can emulate apt-get's command line arguments
- high level application vs Apt
- vaster in functionality, integrates apt-get, and apt-mark and apt-cache
- additional functions: 
	- (i) marking package to be manually or automatically installed, 
	- (ii) holding package making it unable for upgradation
- better for conflict resolution
- CLI and text

### **AppArmor**
#### Background
- https://www.youtube.com/watch?v=KYM-Dzivnjs&ab_channel=ChrisTitusTechChrisTitusTech
- Debian based SELinux
- restrict access to application / scripts / program to only do certain things
- Also allows set up of profiles to limit access the program
- can view profiles in apparmor_status

#### Commands
		sudo systemctl status ufw
		sudo ufw status
		sudo systemctl status ssh
		head -n2 /etc/os-release (OS name)

### **User and groups**
#### Commands
		id <username>
		sudo adduser <new_user>
		modified /etc/login.defs
		modified /etc/pam.d/common-password
		sudo usermod -aG <group> <username>
		sudo groupadd <new_groupname>

### **Hostname and partitions**
		hostname
		sudo hostnamectl set-hostname <new hostname>
		sudo vim /etc/hosts

### **Sudo**
		sudo visudo
		cd /var/log/sudo


### **UFW**
#### Background
- uncomplicated firewall
- blocks all tcp access (if switched on)

#### Commands
		sudo ufw allow 8080/tcp
		sudo ufw delete allow 8080/tcp

### **SSH (Secure Shell)**
#### Background
- secure shell (SSH)
	- before anybody can intercept
	- secure way to access between unsecured network
	- uses cryptography
	- without SSH package can be opened by anybody
	- with SSH - package is locked - when i receive it 
sudo vim /etc/ssh/sshd_config
test ssh
-  To test with and without root user

#### Commands
		sudo systemctl status ssh

### **Monitoring & cron**
		cron
		crontab -e
        * * * * * sleep 30;
		*/10 * * * * *
		/etc/init.d/cron stop
		/etc/init.d/cron start

### **Bonuses**
#### Partitions

		lsblk

#### Wordpress

		sudo systemctl status lighttpd
		sudo systemctl status mariadb
		php -v
		<Host ip address>/wp

#### Borg (bonus application)
- https://borgbackup.readthedocs.io/en/stable/

#### Download & Setup

		apt-get install borgbackup

#### Creating and initialising (without encryption) backup folder

		mkdir <backupfile>
		borg init --encryption none <backupfile>/

#### Creating backup cycle and setting up with cron

		*/15 * * * * borg create <backup destination>::File-$(date '+\%d-\%m-\%Y_\%H:\%M:\%S') <source folder>
		e.g.: */15 * * * * borg create ~/backup::File-$(date '+\%d-\%m-\%Y_\%H:\%M:\%S') ~/downloads

#### Viewing backups

		borg list <filename>
		e.g. borg list ~/backup

#### Extracting backup files
- First need to create extraction folder

		mkdir <extraction folder>

- To run inside extraction folder

		borg extract <backup folder>::<backup name> <source folder>
		e.g. borg extract ~/backup::<backup name> home/jkhong/downloads

### **Random**
Checking file size
		
		du -sh <filename>
		du -h <filename>
