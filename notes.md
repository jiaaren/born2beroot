# **Born2beroot**

- [**Born2beroot**](#born2beroot)
    - [**Virtual Box**](#virtual-box)
    - [**Sudo**](#sudo)
    - [**SSH (Secure Shell)**](#ssh-secure-shell)
    - [**UFW (Uncomplicated FIrewall)**](#ufw-uncomplicated-firewall)
    - [**Admin commands**](#admin-commands)
    - [**Linux Security models**](#linux-security-models)
    - [**Monitoring**](#monitoring)
    - [**Cron**](#cron)
    - [**Lsblk**](#lsblk)
    - [**Drive partitioning**](#drive-partitioning)
    - [**Monitoring bash script**](#monitoring-bash-script)
    - [**Bonus**](#bonus)
    - [**Random (purge and remove)**](#random-purge-and-remove)

### **Virtual Box**
1. Downloading VirtualBox - https://www.virtualbox.org/wiki/Downloads (windows hosts)
2. Background over Debian releases - https://www.debian.org/releases/
   - stable - latest official release distribution of Debian
   - testing - distribution which includes packages not accepted into a 'stable' release yet
   - unstable - where active development of Debian occurs
3. Downloading Debian ISO (Optical Disc Image - CD) file
   - https://www.debian.org/distrib/
4. Installing Debian (minimal server, i.e. requirements of b2br)
   - https://www.howtoforge.com/tutorial/debian-minimal-server/
   - Specific instructions for installing for b2br (for bonus section, i.e with encrypted partitioning)
     - Select manual partitioning
       - a.	Boot 500MB /boot, bootable, boot (name)
       - b.	Create encrypted partitions (over free space) - will take time for erasing and encrypting data.
       - c.	LVM partitioning
         -  i.	Create volume group – LVMGroup
         -  ii.	Create LVM volumes
       - d.	Editing partitions, to update the following:
         1.	Use as
         2.	Mount point
         3.	Label (for some reason type var-log with one ‘-‘, will show va--log? And typing var—log > var----log
         4.	swap select 'Use as' – swap
5. Installing Debian (w/ GUI, e.g. GNOME)
   - https://linuxhint.com/install_debian10_virtualbox/ (GNOME)
6. Using virtual machine
   1. Right Ctrl - Host Key, to exit virtual machine environment
7. Setting Networking
   - Main choices include NAT and Bridge adapter
     - NAT masks network activity as if it came from Host OS
     - Bridged mode replicates another node in physical network, i.e. guest VM will receive own IP if DHCP is enabled.
   - Configuiring SSH connection to:
     - NAT (https://www.youtube.com/watch?v=oOfZgDxLHrQ)
       - Edit Port forwarding rules in Advanced options of Network Settings in VBox
       - Update Host IP and Host Port (can be customised)
       - Update Guest IP and Guest Port (need to be consistent with what has been set up in VBox, default would be 10.0.2.15)
       - E.g. if setting up SSH, guest Port would be 22, however for the purpose of the b2br project, port would be 4242 since we will be explicitly customising it afterwards.
     - Bridge adapter
       - Had some trouble applying this for my laptop, since it is connected using a wifi network adapter. So defaulted to NAT instead.
       - Essentially a new IP address will be assigned to the VM by my router's DHCP, and enabling us to connect to the VM via SSH using the new IP address.

### **Sudo**
- Installing sudo

      apt-get install sudo -y

- Changing to root user

      su

- Changing between users 

      su <username>

- by default, only root users can shutdown/reboot

      sudo shutdown
      sudo shutdown now (shutdown immediately)
      sudo reboot

- to replay sudo command and view user actions

      sudoreplay <id>

### **SSH (Secure Shell)**
https://linuxize.com/post/how-to-change-ssh-port-in-linux/

- To update SSH settings, update sshd_config file
   
      sudo vim /etc/ssh/sshd_config (Unix/MacOS/Linux)
      port number
      permitrootlogin no

- Restarting SSH service

      sudo service ssh restart

- Accessing port

      ssh -p <port_number> <username>@<ip_address>
      e.g. ssh -p 4242 jkhong@127.0.0.1
      **Note: ** port needs to be > 1024, as there is a possibility that ports <= 1024 may already be reserved for another protocol.


### **UFW (Uncomplicated FIrewall)**
https://linuxize.com/post/how-to-setup-a-firewall-with-ufw-on-debian-10/
- Blocks all incoming connections, allow all outbound connections, i.e. no one will be able to connect unless we specifically open the port
- Will show as inactive first time round, we would have to enable ufw manually

- Installing ufw
      
      sudo apt install ufw

- Allowing ufw port

      sudo ufw allow 4242/tcp

      sudo ufw allow OpenSSH (equivalent to allow 22/tcp)

- Enabling/disabling ufw

      sudo ufw enable
      sudo ufw disable

- Viewing ufw status
      
      sudo ufw status

### **Admin commands**
<ins>Group and user commands</ins>
  - Adding new user

         useradd -m <username> (need m to set user directory)
         passwd <username> (set password)
  
  - Modifying other user information (not used in project)
    https://linuxize.com/post/usermod-command-in-linux/ 

  - Adding user to group

        sudo usermod -aG <group> <username>

   - Remove user from group

         gpasswd -d <user> <group>

  - Creating new group

        sudo groupadd <new_groupname>

  - Displaying

        id <username>              (for each user)
        getent group <groupname>   (for each group)

<ins>Password</ins>
- Installed libpam-pwquality

      sudo apt install libpam-pwquality

- Manual

      man pwqualift.conf
      man 8 pam_pwquality

- Modify password aging controls

      vim /etc/login.defs
      PASS_MAX_DAYS  30
      PASS_MIN_DAYS  2
      PASS_WARN_AGE  7

- Modify password policy

      vim /etc/pam.d/common-password

      retry=3 minlen=10 ucredit=-1 dcredit=-1 maxrepeat=3 difok=7 reject_username enforce_for_root

- Change password

      passwd

<ins>Sudo</ins>
https://www.sudo.ws/man/1.8.15/sudoers.man.html
- Modifying sudoers file 

      sudo visudo
      Defaults secure_path "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
      Defaults badpass_message="<custom message>"
      Defaults passwd_tries=3 (default would be  anyway)
      Defaults iolog_dir="/var/log/sudo/"
      Defaults log_input, log_output
      Defaults requiretty

- Other commands
  - instead of iolog_dir, we can save sudo commands in logfile

### **Linux Security models**
- Eg. Apparmor and SELinux
  - Both provide "mandatory access control" (MAC) security, via restriction of actions certain processes can take.
  - SELinux mainly used on RedHat linux distributions, e.g. CentOS
  - Both Apparmor and SELinux cannot be run at the same time
- Apparmor
  - Starting from Debian v10 onwards Apparmor is configured to run in stardup as default
  - [Background](https://wiki.debian.org/AppArmor/HowToUse)
  - [Introduction](https://www.youtube.com/watch?v=xF9KDIhIDJQ)
  - Apparmor manages access control via 'profiles', some packages/applications come installed with their own Apparmor profiles. 

  - View Apparmor status

            sudo aa-status

### **Monitoring**

      Refer to monitoring.sh file

### **Cron**
- To add cron action

      crontab

- To edit crontab

      crontab -e

- Add instruction to run 

      */10 * * * * /root/monitoring/monitoring.sh | wall

### **Lsblk**
https://linuxconfig.org/introduction-to-the-lsblk-command
  1. NAME        - device name (only device name is displayed by default)
  2. MAJ:MIN     - numbers used by kernel to internally identify devices, first number specifying device type (e.g. 8 is for SCSI discs)
  3. RM          - removable, only device marked as removable is sr0, i.e. optical drive
  4. SIZE        - size of device
  5. RO          - read only (displays 1 or 0)
  6. TYPE        - used to identify device or partition type, e.g. crypt, lvm, disk, rom(DVD/CD-ROM device, i.e. optical drive)
  7. MOUNTPOINT  - info on current mountpoint of device

### **Drive partitioning**
Why:
  - E.g. of uses Use of multiple operating systems in different partitions
  - able to separately reformat or manage disks without disturbing the other via creation of 'groups' of disks or partitions that can be assembled into a single (or multiple) file systems


### **Monitoring bash script**
1. OS and kernel version
https://linux.die.net/man/1/uname

         uname -a ()
         hostnamectl
         lsb_release -a
         cat /etc/os-release

1. Physical CPUs
   
         lscpu
         nproc

2.  Virtual CPUs (i.e. cores)
https://webhostinggeeks.com/howto/how-to-display-the-number-of-processors-vcpu-on-linux-vps/

         cat /prac/cpuinfo

3.  RAM

         free
         /proc/meminfo

4. Disc size

         df -l -T --total | grep total

5.   CPU usage
- How utilisation is calculated - https://support.site24x7.com/portal/en/kb/articles/how-is-cpu-utilization-calculated-for-a-linux-server-monitor
         
         mpstat
         top

6. Last reboot

         last reboot | head -1
         who -b

7.  LVMs

         lsblk (presence of any lsblk)

8.  TCP connections established

         ss -s

9. User log

         who

10. IP and MAC address

         ip route
         ip addr

### **Bonus**
- Wordpress with lighttpd
  - https://www.how2shout.com/linux/install-wordpress-on-lighttpd-web-server-ubuntu/
- MariaDB
  - https://www.digitalocean.com/community/tutorials/how-to-install-mariadb-on-debian-10

### **Random (purge and remove)**

            sudo apt-get purge <package-name>
            sudo apt-get remove <package-name>

- **remove** - remove is identical to install except that packages are removed instead of installed. Note that removing a package leaves its configuration files on the system. If a plus sign is appended to the package name (with no intervening space), the identified package will be installed instead of removed.
- **purge** - purge is identical to remove except that packages are removed and purged (any configuration files are deleted too).