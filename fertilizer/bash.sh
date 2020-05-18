#!/bin/bash

echo 'Enter the First Number :'
read a
echo 'Enter the Second Number :'
read b
x=$(expr "$a" + "$b")
echo $a + $b = $x
#!/bin/bash

arr=('-' '\' '|' '/')
while true; do
	for c in "${arr[@]}"; do
		printf "\r %c " $c
		sleep .5
	done
done
#!/bin/bash
name=$1
path=$2
tar -czvf $name.tar.gz $path 
gpg -c $name.tar.gz
rm -rf $name.tar.gz
#!/bin/bash
echo "Enter A Number"
read n
arm=0
temp=$n
while [ $n -ne 0 ]; do
	r=$(expr $n % 10)
	arm=$(expr $arm + $r \* $r \* $r)
	n=$(expr $n / 10)
done
echo $arm
if [ $arm -eq $temp ]; then
	echo "Armstrong"
else
	echo "Not Armstrong"
fi
#!/bin/bash
echo "Enter a number :"
read Binary
if [ $Binary -eq 0 ]; then
	echo "Enter a valid number "
	return
else
	while [ $Binary -ne 0 ]; do
		Bnumber=$Binary
		Decimal=0
		power=1
		while [ $Binary -ne 0 ]; do
			rem=$(expr $Binary % 10)
			Decimal=$((Decimal + (rem * power)))
			power=$((power * 2))
			Binary=$(expr $Binary / 10)
		done
		echo " $Decimal"
	done
fi
#!/bin/bash

IP4FW=/sbin/iptables
IP6FW=/sbin/ip6tables
LSPCI=/usr/bin/lspci
ROUTE=/sbin/route
NETSTAT=/bin/netstat
LSB=/usr/bin/lsb_release

## files ##
DNSCLIENT="/etc/resolv.conf"
DRVCONF="/etc/modprobe.conf"
NETALIASCFC="/etc/sysconfig/network-scripts/ifcfg-eth?-range?"
NETCFC="/etc/sysconfig/network-scripts/ifcfg-eth?"
NETSTATICROUTECFC="/etc/sysconfig/network-scripts/route-eth?"
SYSCTL="/etc/sysctl.conf"

## Output file ##
OUTPUT="network.$(date +'%d-%m-%y').info.txt"

## Email info to?? ##
SUPPORT_ID="your_name@service_provider.com"

chk_root() {
	local meid=$(id -u)
	if [ $meid -ne 0 ]; then
		echo "You must be root user to run this tool"
		exit 999
	fi
}

write_header() {
	echo "---------------------------------------------------" >>$OUTPUT
	echo "$@" >>$OUTPUT
	echo "---------------------------------------------------" >>$OUTPUT
}

dump_info() {
	echo "* Hostname: $(hostname)" >$OUTPUT
	echo "* Run date and time: $(date)" >>$OUTPUT

	write_header "Linux Distro"
	echo "Linux kernel: $(uname -mrs)" >>$OUTPUT
	$LSB -a >>$OUTPUT

	[ -x ${HWINF} ] && write_header "${HWINF}"
	[ -x ${HWINF} ] && ${HWINF} >>$OUTPUT

	[ -x ${HWINF} ] && write_header "${HWINF}"
	[ -x ${HWINF} ] && ${HWINF} >>$OUTPUT

	write_header "PCI Devices"
	${LSPCI} -v >>$OUTPUT

	write_header "$IFCFG Output"
	$IFCFG >>$OUTPUT

	write_header "Kernel Routing Table"
	$ROUTE -n >>$OUTPUT

	write_header "Network Card Drivers Configuration $DRVCONF"
	[ -f $DRVCONF ] && grep eth $DRVCONF >>$OUTPUT || echo "Error $DRVCONF file not found." >>$OUTPUT

	write_header "DNS Client $DNSCLIENT Configuration"
	[ -f $DNSCLIENT ] && cat $DNSCLIENT >>$OUTPUT || echo "Error $DNSCLIENT file not found." >>$OUTPUT

	write_header "Network Configuration File"
	for f in $NETCFC; do
		if [ -f $f ]; then
			echo "** $f **" >>$OUTPUT
			cat $f >>$OUTPUT
		else
			echo "Error $f not found." >>$OUTPUT
		fi
	done

	write_header "Network Aliase File"
	for f in $NETALIASCFC; do
		if [ -f $f ]; then
			echo "** $f **" >>$OUTPUT
			cat $f >>$OUTPUT
		else
			echo "Error $f not found." >>$OUTPUT
		fi
	done

	write_header "Network Static Routing Configuration"
	for f in $NETSTATICROUTECFC; do
		if [ -f $f ]; then
			echo "** $f **" >>$OUTPUT
			cat $f >>$OUTPUT
		else
			echo "Error $f not found." >>$OUTPUT
		fi
	done

	write_header "IP4 Firewall Configuration"
	$IP4FW -L -n >>$OUTPUT

	write_header "IP6 Firewall Configuration"
	$IP6FW -L -n >>$OUTPUT

	write_header "Network Stats"
	$NETSTAT -s >>$OUTPUT

	write_header "Network Tweaks via $SYSCTL"
	[ -f $SYSCTL ] && cat $SYSCTL >>$OUTPUT || echo "Error $SYSCTL not found." >>$OUTPUT

	echo "The Network Configuration Info Written To $OUTPUT. Please email this file to $SUPPORT_ID."
}

chk_root
dump_info
#!/bin/bash

DARKGRAY='\033[1;30m'
RED='\033[0;31m'
LIGHTRED='\033[1;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
LIGHTPURPLE='\033[1;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
DEFAULT='\033[0m'

COLORS=($DARKGRAY $RED $LIGHTRED $GREEN $YELLOW $BLUE $PURPLE $LIGHTPURPLE $CYAN $WHITE )

for c in "${COLORS[@]}";do
    printf "\r $c LOVE $DEFAULT "
    sleep 1
done#!/bin/bash

echo -n "Enter File Name : "
read fileName

if [ ! -f $fileName ]; then
	echo "Filename $fileName does not exists"
	exit 1
fi

tr '[A-Z]' '[a-z]' <$fileName >>small.txt
#!/usr/bin/env bash

for F in *
do
	if [[ -f $F ]]
	then
		echo $F: $(cat $F | wc -l)
	fi
done
MAX=95
EMAIL=server@127.0.0.1

USE=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage ""}')
if [ $USE -gt $MAX ]; then
	echo "Percent used: $USE" | mail -s "Running out of CPU power" $EMAIL
fi
#!/bin/bash

printf "0x%x\n" $1
#!/bin/bash

for ((i = 32; i >= 0; i--)); do
	r=$((2 ** $i))
	Probablity+=($r)
done

[[ $# -eq 0 ]] && {
	echo -e "Usage \n \t $0 numbers"
	exit 1
}

echo -en "Decimal\t\tBinary\n"
for input_int in $@; do
	s=0
	test ${#input_int} -gt 11 && {
		echo "Support Upto 10 Digit number :: skiping \"$input_int\""
		continue
	}

	printf "%-10s\t" "$input_int"

	for n in ${Probablity[@]}; do

		if [[ $input_int -lt ${n} ]]; then
			[[ $s == 1 ]] && printf "%d" 0
		else
			printf "%d" 1
			s=1
			input_int=$(($input_int - ${n}))
		fi
	done
	echo -e
done
#!/bin/bash

echo " Enter your directory: "
read x
du -sh "$x"
MAX=95
EMAIL=server@127.0.0.1
PART=sda1

USE=$(df -h | grep $PART | awk '{ print $5 }' | cut -d'%' -f1)
if [ $USE -gt $MAX ]; then
	echo "Percent used: $USE" | mail -s "Running out of disk space" $EMAIL
fi
#!/bin/bash
echo .Enter the First Number: .
read a
echo .Enter the Second Number: .
read b
echo "$a / $b = $(expr $a / $b)"
#!/bin/bash

echo "Welcome, I am ready to encrypt a file/folder for you"
echo "currently I have a limitation, Place me to the same folder, where a file to be encrypted is present"
echo "Enter the Exact File Name with extension"
read file
# decryption command
# gpg -d filename.gpg > filename
gpg -c $file
echo "I have encrypted the file sucessfully..."
echo "Now I will be removing the original file"
rm -rf $file
#!/bin/bash
echo "Enter The Number"
read n
num=$(expr $n % 2)
if [ $num -eq 0 ]; then
	echo "is a Even Number"
else
	echo "is a Odd Number"
fi
#!/bin/bash
echo "Enter The Number"
read a
fact=1
while [ $a -ne 0 ]; do
	fact=$(expr $fact \* $a)
	a=$(expr $a - 1)
done
echo $fact
#!/bin/bash
x=0
y=1
i=2
while true ; do
	i=$(expr $i + 1)
	z=$(expr $x + $y)
	echo -n "$z "
	x=$y
	y=$z
	sleep .5
done
#!/usr/bin/env bash

TEMP_FILE=/sys/class/thermal/thermal_zone0/temp

ORIGINAL_TEMP=$(cat $TEMP_FILE)
TEMP_C=$((ORIGINAL_TEMP/1000))
TEMP_F=$(($TEMP_C * 9/5 + 32))

echo $TEMP_F F

#!/usr/bin/env bash
# ------------------------------------------------------------------------ #
# Script Name:   hardware_machine.sh 
# Description:   Show informations about machine hardware.
# Written by:    Amaury Souza
# Maintenance:   Amaury Souza
# ------------------------------------------------------------------------ #
# Usage:         
#       $ ./hardware_machine.sh
# ------------------------------------------------------------------------ #
# Bash Version:  
#              Bash 4.4.19
# ------------------------------------------------------------------------ #

function menuprincipal () {
clear
TIME=1
echo " "
echo $0
echo " "
echo "Choose an option below!

        1 - Verify desktop processor
	2 - Verify system kernel
	3 - Verify installed softwares
	4 - Operation system version
       	5 - Verify desktop memory
	6 - Verify serial number
	7 - Verify system IP	 
	0 - Exit"
echo " "
echo -n "Chosen option: "
read opcao
case $opcao in
	1)
		function processador () {
			CPU_INFO=`cat /proc/cpuinfo | grep -i "^model name" | cut -d ":" -f2 | sed -n '1p'`
			echo "CPU model: $CPU_INFO"
			sleep $TIME
		}	
		processador
		read -n 1 -p "<Enter> for main menu"
		menuprincipal
		;;

	2)
		function kernel () {
			#RED HAT: cat /etc/redhat-release
			KERNEL_VERSION_UBUNTU=`uname -r`
			KERNEL_VERSION_CENTOS=`uname -r`
			if [ -f /etc/lsb-release ]
			then
				echo "kernel version: $KERNEL_VERSION_UBUNTU"
			else
				echo "kernel version: $KERNEL_VERSION_CENTOS"
			fi
		}
		kernel
		read -n 1 -p "<Enter> for main menu"
		menuprincipal
		;;

	3)
		function softwares () {
			#while true; do
			TIME=3
			echo " "
			echo "Choose an option below for program's list!
			
			1 - List Ubuntu programs
			2 - List Fedora programs
			3 - Install programs
			4 - Back to menu"
			echo " "
			echo -n "Chosen option: "
			read alternative
			case $alternative in
				1)
					echo "Listing all programs Ubuntu's systems..."
					sleep $TIME
					dpkg -l > /tmp/programs.txt
					echo Programs listed and available at /tmp
					sleep $TIME
					echo " "
                                        echo "Back to menu!" | tr [a-z] [A-Z]
					sleep $TIME
					;;
				2)
					echo "Listing all programs Fedora's systems..."
					sleep $TIME
					yum list installed > /tmp/programs.txt
					echo Programs listed and available at /tmp
					sleep $TIME
					;;
				3)
					echo Installing programss...
					LIST_OF_APPS="pinta brasero gimp vlc inkscape blender filezilla"
					#use aptitude command for programs loop.
					apt install aptitude -y
					aptitude install -y $LIST_OF_APPS
					;;
				4)
					echo Back to main menu...
					sleep $TIME
					;;	
			esac
		#done
		}		
		softwares
		menuprincipal
		;;
	
	4)
		function sistema () {
			VERSION=`cat /etc/os-release | grep -i ^PRETTY`
			if [ -f /etc/os-release ]
			then
				echo "The system version: $VERSION"
			else
				echo "System not supported"
			fi
		}
		sistema
		read -n 1 -p "<Enter> for main menu"
		menuprincipal
		;;


	5)
		function memory () {
			MEMORY_FREE=`free -m  | grep ^Mem | tr -s ' ' | cut -d ' ' -f 4`
			#MEMORY_TOTAL=
			#MEMORY_USED=
			echo Verifying system memory...
			echo "Memory free is: $MEMORY_FREE"	
		}
		memory
		read -n 1 -p "<Enter> for main menu"
		menuprincipal
		;;

	6)
		function serial () {
			SERIAL_NUMBER=`dmidecode -t 1 | grep -i serial`
			echo $SERIAL_NUMBER
		}
		serial
		read -n 1 -p "<Enter> for main menu"
		menuprincipal
		;;

	7)
		function ip () {
			IP_SISTEMA=`hostname -I`
			echo IP is: $IP_SISTEMA
		}
		ip
		read -n 1 -p "<Enter> for main menu"
		menuprincipal
		;;

	0) 
	       echo Exiting the system...
       	       sleep $TIME
	       exit 0
	       ;;

	*)
		echo Invalid option, try again!
		;;
esac
}
menuprincipal
#!/bin/bash

echo "Hello World !"
#!/bin/bash

printf "%d \n " $1
#! /bin/bash
echo "Hey what's Your First Name?"
read a
echo "welcome Mr./Mrs. $a, would you like to tell us, Your Last Name"
read b
echo "Thanks Mr./Mrs. $a $b for telling us your name"
echo "*******************"
echo "Mr./Mrs. $b, it's time to say you good bye"
#!/bin/bash

list=($(ls))

for f in "${list[@]}";do
    echo $f
done#!/bin/bash
read -p "Enter String Uppercase : " i
o=$(echo "$i" | tr '[:upper:]' '[:lower:]')
echo $o#!/bin/bash
echo .Enter the First Number: .
read a
echo .Enter the Second Number: .
read b
echo "$a * $b = $(expr $a \* $b)"
#!/bin/bash

# A simple shell script to use as a pomodoro app.
# The first argument is the focus time length.
# The second argument is the break length.
# Made by Kiailandi (https://github.com/kiailandi)

wseconds=${1:-25}*60;
pseconds=${2:-wseconds/300}*60;

# Check os and behave accordingly
if [ "$(uname)" == "Darwin" ]; then
    while true; do
        date1=$((`date +%s` + $wseconds));
        while [ "$date1" -ge `date +%s` ]; do
            echo -ne "$(date -u -j -f %s $(($date1 - `date +%s`)) +%H:%M:%S)\r";
        done
        osascript -e 'display notification "Time to walk and rest!" with title "Break"';
        read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n';
        date2=$((`date +%s` + $pseconds));
        while [ "$date2" -gt `date +%s` ]; do
            echo -ne "$(date -u -j -f %s $(($date2 - `date +%s`)) +%H:%M:%S)\r";
        done
        osascript -e 'display notification "Time to get back to work" with title "Work"';
        read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n';
    done
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    while true; do
        date1=$((`date +%s` + $wseconds));
        while [ "$date1" -ge `date +%s` ]; do
            echo -ne "$(date -u --date @$(($date1 - `date +%s` )) +%H:%M:%S)\r";
        done
        notify-send "Break" "Time to walk and rest";
        read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n';
        date2=$((`date +%s` + $pseconds));
        while [ "$date2" -ge `date +%s` ]; do
            echo -ne "$(date -u --date @$(($date2 - `date +%s` )) +%H:%M:%S)\r";
        done
        notify-send "Work" "Time to get back to work";
        read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n';
    done
else
    echo -ne "Your OS is currently not supported\n";
fi#!/bin/bash
echo “Enter Any Number”
read n
i=1
c=1
while [ $i -le $n ]; do
	i=$(expr $i + 1)
	r=$(expr $n % $i)
	if [ $r -eq 0 ]; then
		c=$(expr $c + 1)
	fi
done
if [ $c -eq 2 ]; then
	echo “Prime”
else
	echo “Not Prime”
fi
#! /bin/bash
echo "Hello $USER"
echo "Hey i am" $USER "and will be telling you about the current processes"
echo "Running processes List"
ps
#!/bin/bash

while true; do
	rand=$(shuf -i 2600-2700 -n 1)
	echo -n -e '   \u'$rand
	sleep 1
done
#!/bin/bash

echo "Hello $USER"
echo "$(uptime)" >>"$(date)".txt
echo "Your File is being saved to $(pwd)"
#!/bin/bash

shuf -i $1-$2 -n 1
#!/bin/bash
# read-menu: a menu driven system information program
clear
echo "
Please Select:

    1. Display System Information
    2. Display Disk Space
    3. Display Home Space Utilization
    0. Quit
"
read -p "Enter selection [0-3] > "

if [[ $REPLY =~ ^[0-3]$ ]]; then
	if [[ $REPLY == 0 ]]; then
		echo "Program terminated."
		exit
	fi
	if [[ $REPLY == 1 ]]; then
		echo "Hostname: $HOSTNAME"
		uptime
		exit
	fi
	if [[ $REPLY == 2 ]]; then
		df -h
		exit
	fi
	if [[ $REPLY == 3 ]]; then
		if [[ $(id -u) -eq 0 ]]; then
			echo "Home Space Utilization (All Users)"
			du -sh /home/*
		else
			echo "Home Space Utilization ($USER)"
			du -sh $HOME
		fi
		exit
	fi
else
	echo "Invalid entry." >&2
	exit 1
fi
#!/bin/bash

rsync -avz -e "ssh " /path/to/yourfile user@backupserver.com:/backup/
echo "backup for $(date) " | mail -s "backup complete" user@youremail.com
#!/bin/bash
date
echo "uptime:"
uptime
echo "Currently connected:"
w
echo "--------------------"
echo "Last logins:"
last -a | head -3
echo "--------------------"
echo "Disk and memory usage:"
df -h | xargs | awk '{print "Free/total disk: " $11 " / " $9}'
free -m | xargs | awk '{print "Free/total memory: " $17 " / " $8 " MB"}'
echo "--------------------"
start_log=$(head -1 /var/log/messages | cut -c 1-12)
oom=$(grep -ci kill /var/log/messages)
echo -n "OOM errors since $start_log :" $oom
echo ""
echo "--------------------"
echo "Utilization and most expensive processes:"
top -b | head -3
echo
top -b | head -10 | tail -4
echo "--------------------"
echo "Open TCP ports:"
nmap -p -T4 127.0.0.1
echo "--------------------"
echo "Current connections:"
ss -s
echo "--------------------"
echo "processes:"
ps auxf --width=200
echo "--------------------"
echo "vmstat:"
vmstat 1 5
#! /bin/bash
clear
sum=0
i="y"

echo " Enter one no."
read n1
echo "Enter second no."
read n2
while [ $i = "y" ]; do
	echo "1.Addition"
	echo "2.Subtraction"
	echo "3.Multiplication"
	echo "4.Division"
	echo "Enter your choice"
	read ch
	case $ch in
	1)
		sum=$(expr $n1 + $n2)
		echo "Sum ="$sum
		;;
	2)
		sum=$(expr $n1 - $n2)
		echo "Sub = "$sum
		;;
	3)
		sum=$(expr $n1 \* $n2)
		echo "Mul = "$sum
		;;
	4)
		sum=$(expr $n1 / $n2)
		echo "Div = "$sum
		;;
	*) echo "Invalid choice" ;;
	esac
	echo "Do u want to continue (y/n)) ?"
	read i
	if [ $i != "y" ]; then
		exit
	fi
done
#!/bin/bash

MAX_NO=0

echo -n "Enter Number between (5 to 9) : "
read MAX_NO

if ! [ $MAX_NO -ge 5 -a $MAX_NO -le 9 ]; then
	echo "WTF... I ask to enter number between 5 and 9, Try Again"
	exit 1
fi

clear

for ((i = 1; i <= MAX_NO; i++)); do
	for ((s = MAX_NO; s >= i; s--)); do
		echo -n " "
	done
	for ((j = 1; j <= i; j++)); do
		echo -n " ."
	done
	echo ""
done
###### Second stage ######################
for ((i = MAX_NO; i >= 1; i--)); do
	for ((s = i; s <= MAX_NO; s++)); do
		echo -n " "
	done
	for ((j = 1; j <= i; j++)); do
		echo -n " ."
	done
	echo ""
done

echo -e "\n\n\t\t\t Whenever you need help, Tecmint.com is always there"
#!/bin/bash
echo .Enter the First Number: .
read a
echo .Enter the Second Number: .
read b
x=$(($a - $b))
echo $a - $b = $x
#!/bin/bash
echo .Enter The Number upto which you want to Print Table: .
read n
i=1
while [ $i -ne 10 ]; do
	i=$(expr $i + 1)
	table=$(expr $i \* $n)
	echo $table
done
#!/bin/bash
# test-file: Evaluate the status of a file
echo "Hey what's the File/Directory name (using the absolute path)?"
read FILE

if [ -e "$FILE" ]; then
	if [ -f "$FILE" ]; then
		echo "$FILE is a regular file."
	fi
	if [ -d "$FILE" ]; then
		echo "$FILE is a directory."
	fi
	if [ -r "$FILE" ]; then
		echo "$FILE is readable."
	fi
	if [ -w "$FILE" ]; then
		echo "$FILE is writable."
	fi
	if [ -x "$FILE" ]; then
		echo "$FILE is executable/searchable."
	fi
else
	echo "$FILE does not exist"
	exit 1
fi
exit
#!/bin/bash
for i in *.jpg; do
    convert "$i" -thumbnail 400 "thumbs/$i";
done;


#!/bin/bash

function finish() {
	# your cleanup here.
	echo "CTL+C pressed"
	echo "clean ..."
	sleep 1
}
trap finish EXIT

echo 'runing ...'
until false; do
	sleep 1
done
#!/bin/bash

LEVEL=$1
for ((i = 0; i < LEVEL; i++)); do
	echo $i
	CDIR=../$CDIR
done
cd $CDIR
echo "You are in: "$PWD
sh=$(which $SHELL)
exec $sh
#!/bin/bash

VERSION=$1
VERSION2=$2

function version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; }
function version_le() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" == "$1"; }
function version_lt() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" != "$1"; }
function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; }

if version_gt $VERSION $VERSION2; then
	echo "$VERSION is greater than $VERSION2"
fi

if version_le $VERSION $VERSION2; then
	echo "$VERSION is less than or equal to $VERSION2"
fi

if version_lt $VERSION $VERSION2; then
	echo "$VERSION is less than $VERSION2"
fi

if version_ge $VERSION $VERSION2; then
	echo "$VERSION is greater than or equal to $VERSION2"
fi
#!/bin/bash
# weather.sh
# Copyright 2018 computer-geek64. All rights reserved.

program=Weather
version=1.1
year=2018
developer=computer-geek64

case $1 in
-h | --help)
	echo "$program $version"
	echo "Copyright $year $developer. All rights reserved."
	echo
	echo "Usage: weather [options]"
	echo "Option          Long Option             Description"
	echo "-h              --help                  Show the help screen"
	echo "-l [location]   --location [location]   Specifies the location"
	;;
-l | --location)
	curl https://wttr.in/$2
	;;
*)
	curl https://wttr.in
	;;
esac
#!/bin/bash
# while-menu: a menu driven system information program
DELAY=1 # Number of seconds to display results
while true; do
    clear
	cat << EOF
        Please Select:
        1. Display System Information
        2. Display Disk Space
        3. Display Home Space Utilization
        0. Quit
EOF
    read -p "Enter selection [0-3] > "
    case "$REPLY" in
        0)
            break
            ;;
        1)
            echo "Hostname: $HOSTNAME"
            uptime
            ;;
        2)
            df -h
            ;;
        3)
            if [[ $(id -u) -eq 0 ]]; then
                echo "Home Space Utilization (All Users)"
                du -sh /home/*
            else
                echo "Home Space Utilization ($USER)"
                du -sh $HOME
            fi
            ;;
        *)
            echo "Invalid entry."
            ;;
    esac
    sleep "$DELAY"
done
echo "Program terminated."
#!/bin/bash
# while-read: read lines from a file
count=0
while read; do
	printf "%d %s\n" $REPLY
	count=$(expr $count + 1)
done <$1
#!/bin/bash

#Base Path
basePath='/opt/aws-lambda-adapter/'
logFilePath="$basePath"'deployments/sls-logs/'
mailTemplFile="$basePath"'deployments/mail-template.sh'

#Declaring the variable
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
DARKGRAY="\033[1;90m"
LIGHTBLUE="\033[1;94m"
LIGHTGRAY="\033[1;37m"
NOCOLOR="\033[0m"

#sls config
slsRegion='ap-southeast-1'
slsConfig='serverless.yml'
slsStage=$1
slsProfile=$2

#log file
gitCommitID=$(git log --format="%H" -n 1)
logFile="$logFilePath$gitCommitID"'.log'

#Decorator function
outputDecorator(){
 if [ $1 == 0 ]
 then
  echo -e "${RED}Error: ${NOCOLOR} $2. ${NOCOLOR}" | tee -a $logFile
 elif [ $1 == 1 ]
 then
  echo -e "${GREEN}Success: ${NOCOLOR} $2. ${NOCOLOR}" | tee -a $logFile
 elif [ $1 == -1 ]
 then
  echo -e "$2 ${NOCOLOR}" | tee -a $logFile
 fi
}

#Serverless delployment function
serverlessDeployment(){
  outputDecorator -1 "${LIGHTBLUE}NPM:${NOCOLOR}${LIGHTGRAY}  Installing the App's Dependency Packages...."
  npm install
  outputDecorator -1 "${LIGHTBLUE}NPM:${NOCOLOR}${LIGHTGRAY}  Updating the App's Dependency Packages...."
  npm update
  outputDecorator -1 "${LIGHTBLUE}SLS:${NOCOLOR}${LIGHTGRAY}  Serverless Deploying...."
  outputDecorator -1 "${YELLOW}    -------------------------------------------------------"
  if [ -z "$slsProfile"  ]; then
    serverless deploy --stage "$slsStage" --region "$slsRegion" | tee -a $logFile
  else
    serverless deploy --stage "$slsStage" --region "$slsRegion" --profile "$slsProfile" | tee -a $logFile
  fi
  outputDecorator -1 "${YELLOW}    -------------------------------------------------------"
  if [ $(grep -o 'Service Information' "$logFile" | wc -l) -gt 0 ]; then
      outputDecorator 1 "${GREEN}  Serverless Deployment has successfully finished."
  else
      outputDecorator 1 "${RED}  Serverless deploy failed."
  fi
}

#Start default OUTPUT line
 outputDecorator -1 "${DARKGRAY}############################## DEPLOYMENT LOG ##############################"
#END default line
#Check arguments supplied
#The $# variable will tell you the number of input arguments the script was passed.
if [ $# -eq 0 ]
then
  outputDecorator 0 "${RED}Environment variable not defined.${NOCOCLOR}.\n${YELLOW}Hint: Pass the arguments to script as staging/prod"
  exit 1
elif [ $slsStage == 'staging' ] || [ $slsStage == 'prod' ]
then
  outputDecorator -1 "${LIGHTBLUE}ENV:${NOCOLOR}${LIGHTGRAY}  Setting the Serverless environment as $slsStage"
else
  outputDecorator 0 "Invalid Stage Param. Stage Parameter should be either ${YELLOW}Staging ${NOCOLOR}or ${GREEN}Prod"
  exit 1
fi

#Check git command exist
if ! [ -x "$(command -v git)" ]; then
   outputDecorator 0 "${RED}git ${NOCOLOR}is not installed"
  exit 1
fi

#Git details
gitBaseName=$(basename `git rev-parse --show-toplevel`)
gitCommitID=$(git log --format="%H" -n 1)
gitNameEmailKey=0;
gitRevCommitIDs[$gitNameEmailKey]=$gitCommitID
gitUserName[$gitNameEmailKey]=$(git --no-pager show -s --format='%an <%ae>' $gitCommitID | grep -o -P '(?<=).*(?=<)')
gitUserEmail[$gitNameEmailKey]=$(git --no-pager show -s --format='%an <%ae>' $gitCommitID | grep -o -P '(?<=<).*(?=>)')

for parentCommitID in $(git log --pretty=%P -n 1 $gitCommitID) 
do 
  ((gitNameEmailKey++));
  gitRevCommitIDs[$gitNameEmailKey]=$parentCommitID
  gitUserName[$gitNameEmailKey]=$(git --no-pager show -s --format='%an <%ae>' $parentCommitID | grep -o -P '(?<=).*(?=<)')
  gitUserEmail[$gitNameEmailKey]=$(git --no-pager show -s --format='%an <%ae>' $parentCommitID | grep -o -P '(?<=<).*(?=>)')
done;

#We can just overwrite our array with the unique elements
gitRevCommitIDs=( `for i in ${gitRevCommitIDs[@]}; do echo $i; done | sort -u` )
gitUserName=( `for i in ${gitUserName[@]}; do echo $i; done | sort -u` )
gitUserEmail=( `for i in ${gitUserEmail[@]}; do echo $i; done | sort -u` )

outputDecorator -1 "${LIGHTBLUE}GIT:${NOCOLOR}${LIGHTGRAY}  Checking the Git Repository...."

#Check git repository exist
if [ -d '.git'  ] || [ -d '../.git'  ]; then
  outputDecorator -1 "${LIGHTBLUE}GIT:${NOCOLOR}${LIGHTGRAY}  Git Repository exists as $gitBaseName"
  outputDecorator -1 "${LIGHTBLUE}GIT:${NOCOLOR}${LIGHTGRAY}  Git resetting the $slsConfig file"
  outputDecorator -1 "${LIGHTBLUE}    ${NOCOLOR}${YELLOW}  --------------- Git revision details ---------------"
  outputDecorator -1 "${LIGHTBLUE}    ${NOCOLOR}${LIGHTGRAY}  Revision: $gitCommitID"
  outputDecorator -1 "${LIGHTBLUE}    ${NOCOLOR}${LIGHTGRAY}  Message : $(git log --format=%B -n 1 $gitCommitID)"
  outputDecorator -1 "${LIGHTBLUE}    ${NOCOLOR}${LIGHTGRAY}  User    : $gitUserName"
  outputDecorator -1 "${LIGHTBLUE}    ${NOCOLOR}${LIGHTGRAY}  Email   : $gitUserEmail"
  outputDecorator -1 "${LIGHTBLUE}    ${NOCOLOR}${YELLOW}  ----------------------------------------------------"
  #If the commit was a merge, and it was TREESAME to parent, follow all parents.
  if [[ "$(git cat-file -p $gitCommitID)" =~ .*Merging*. ]]; then
	outputDecorator -1 "${LIGHTBLUE}    ${NOCOLOR}${YELLOW}  Revision has merge history and it was TREESAME to following parents"
  	outputDecorator -1 "${LIGHTBLUE}    ${NOCOLOR}${YELLOW}  --------------- Git revision's Parent commit details ---------------"
	outputDecorator -1 "${LIGHTBLUE}    ${NOCOLOR}${LIGHTGRAY}  CommitId: ${gitRevCommitIDs[*]}"
        outputDecorator -1 "${LIGHTBLUE}    ${NOCOLOR}${LIGHTGRAY}  Message : $(git log --format=%B -n 1 ${gitRevCommitIDs[*]})"
  	outputDecorator -1 "${LIGHTBLUE}    ${NOCOLOR}${LIGHTGRAY}  Users    : ${gitUserName[*]}"
   	outputDecorator -1 "${LIGHTBLUE}    ${NOCOLOR}${LIGHTGRAY}  Emails   : ${gitUserEmail[*]}"
  	outputDecorator -1 "${LIGHTBLUE}    ${NOCOLOR}${YELLOW}  ----------------------------------------------------"
  fi
  #git checkout "$slsConfig"
else
  outputDecorator 0 "${RED} Git Repository ${NOCOLOR}Not exists"
  exit 1
fi

#Check serverless config file and Replace the env variable
#if [ -f 'serverless.yml' ]; then
#if [ $(ls -1 *.yml 2>/dev/null | wc -l) -gt 0 ] || [ $(ls -1 *.yaml 2>/dev/null | wc -l) -gt 0 ]; then
if [ -f "$slsConfig" ]; then
  #sed -i "s/.*stage:.*$/  stage: $slsStage/" "$slsConfig"
  outputDecorator -1 "${LIGHTBLUE}ENV:${NOCOLOR}${LIGHTGRAY}  Resetting the stage variable as $slsStage"  
  serverlessDeployment
else
  for slsDir in * ; do
   if [ -f "$basePath"'integration/'"$slsDir"'/'"$slsConfig" ]; then
    outputDecorator -1 "${LIGHTBLUE}    ${NOCOLOR}${LIGHTGRAY}  ******************** START Serverless Log for $slsDir ********************"
    outputDecorator -1 "${LIGHTBLUE}ENV:${NOCOLOR}${LIGHTGRAY}  Resetting the stage variable as $slsStage in $slsDir"
    echo $basePath'integration/'$slsDir
    cd $basePath'integration/'$slsDir
    serverlessDeployment
    outputDecorator -1 "${LIGHTBLUE}    ${NOCOLOR}${LIGHTGRAY}  ******************** END Serverless Log fro $slsDir ********************"
   fi
  done
  #echo 'Error: "$slsConfig" file is not exist.' >&2
  #exit 1
fi

#Start default OUTPUT line
 outputDecorator -1 "${DARKGRAY}############################## ENDED DEPLOYMENT LOG ##############################"
 cp "$logFile" "$logFilePath$gitBaseName"'.log'
 sed -ri "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" "$logFilePath$gitBaseName"'.log'
 echo $'\n\n\n\n\n' >> "$logFile"
 #Sending mail with the dump file
 mailTempHeader='Deployment'
 mailTempConcern='Hey there'
 mailTempBodyTitle='Please find the <b>'"${gitBaseName^}"'</b> repository deployment details, '
 mailTempBody=$(grep -Pzo '.*Service Information(.*\n)*' $logFilePath$gitBaseName'.log' | head -n -4 | tr '\r\n' '\t' | sed 's/\t/ <br \/> /g')
 #mailTempBody=$(grep -Pzo '.*Service Information(.*\n)*' $logFilePath$gitBaseName'.log' | head -n -4 | sed ':a;N;$!ba;s/\r\n/<1br \/>/g') 
 mailTempFooter='Please find the attached file for further details. <p style="font-size: 14px;color: cornflowerblue;">IF YOU HAVE ANY QUESTIONS OR CONCERNS, PLEASE CONTACT <a href="http://bugzilla.aceturtle.net/" target="_blank"><b>DevOps</b></a></p>'
 sh "$mailTemplFile" "$mailTempHeader" "$mailTempConcern" "$mailTempBodyTitle" "$mailTempBody" "$mailTempFooter" | mutt -e "set from=noreply@aceturtle.com" -e "set realname=Deployment" -e 'set content_type="text/html"' -s "${gitBaseName^} Deployment Logs: $(date +%d%b%Y-%T)" -a "$logFilePath$gitBaseName"'.log' -- $(echo ${gitUserEmail[@]} | tr ' ' ,)
 rm -f "$logFilePath$gitBaseName"'.log'
 rm -f "$logFile"
#END default line
# Bash-Scripts
UNIX' core idea is that there are many simple commands that can linked together via piping and redirection to accomplish even really complex tasks. Have a look at the following examples. I'll only explain the most complex ones; for the others,

### 1. Lambda-Deployment-Script
       Automating Deployment of Lambda Applications
       
### 2. mysql-backup-and-send-mail
#!/bin/bash
#Set the path
BACKUP_PATH='/backup/report-backup/';
FILENAME='MYSQLTABLE_report_'$(date +%d%b)'.csv';

#Set the Mysql details
MYSQL_DB='pim_app5';
MYSQL_QUERY='SELECT * FROM ReportView';

#Set the mail config
MAIL_SUBJECT='Report Dump - '$(date +%F);
MAIL_TO_IDS='*****@*****.com, *****@*****.com, *****@*****.com';

#Taking the backupo as csv using mysqldump
mysql $MYSQL_DB -e "set sql_mode='';$MYSQL_QUERY" -B | sed "s/'/\'/;s/\t/\",\"/g;s/^/\"/;s/$/\"/;s/\n//g" > $BACKUP_PATH$FILENAME

#Sending mail with the dump file
echo | mutt -s $MAIL_SUBJECT -a $BACKUP_PATH$FILENAME -- $MAIL_TO_IDS
The MIT License (MIT)


# Bash Scripts

> My collection of Bash Scripts

My collection of Bash Scripts (either created by me or from other sources) that I can share publicly

Scripts for:
- [Byzanz screen capturing](screen-capturing)
- Database backups
- Finding duplicate files
- Finding files not owned by a user group
- generating large temp files
- git diff utilities
- grep utilities
- make folders (a through z)
- move to monitor
- Dropbox startup hack
- JS utilities
- XAMPP start / stop
- System shutdown and startup
- Prompt tweaks
- Colorize tail of log
- Trackpad mouse on/off hack
# aliases
alias g=git
alias gk='gitk &'
alias gka='gitk --all &'
alias gd='git diff'
alias gdc='git diff --cached'
if [[ "$OSTYPE" == 'linux-gnu' ]]; then
	alias s=./symfony
	alias symfony=./symfony
else
	alias s=symfony
fi
#!/bin/bash
# resouces
# http://stackoverflow.com/questions/3846123/generating-permutations-using-bash
# http://stackoverflow.com/questions/17762764/generate-all-possible-combinations-of-a-function-call-using-bash-script

printf "# %s\n" {fontawesome,},{octicons,},{fontlinux,},{pomicons,},{powerlineextra,}


printf "# - %s\n" --{fontawesome,}--{octicons,}--{fontlinux,}--{pomicons,}--{powerlineextra,}


perm() {
  local items="$1"
  local out="$2"
  local i
  [[ "$items" == "" ]] && echo "$out" && return
  for (( i=0; i<${#items}; i++ )) ; do
    perm "${items:0:i}${items:i+1}" "$out${items:i:1}"
    done
  }
while read line ; do perm $line ; done < File


echo --{fa,}{o,} 
printf "--{fa,}{o,}"

printf " %s\n" {fa,}{o,}

printf " %s\n" --{fontawesome,}{octicons,}{fontlinux,}{pomicons,},{powerlineextra,},{fontawesomeextension,}

# this seems to be working:
printf " %s\n" {--fontawesome,}\ {--octicons,}

# too many spaces:
printf " %s\n" {--fontawesome,}\ {--octicons,}\ {--fontlinux,}\ {--pomicons,}\ {--powerlineextra,}\ {--fontawesomeextension,}

# try to eliminate build up of spaces:

printf " %s\n" {' --fontawesome',}{' --octicons',}{--fontlinux,}{--pomicons,}{--powerlineextra,}{--fontawesomeextension,}

# lookin' good:
printf " %s\n" {' --fontawesome',}{' --octicons',}{' --fontlinux',}{' --pomicons',}{' --powerlineextra',}{' --fontawesomeextension',}{' --powersymbols',}

# get the num of combinations counted:
printf " %s\n" {' --fontawesome',}{' --octicons',}{' --fontlinux',}{' --pomicons',}{' --powerlineextra',}{' --fontawesomeextension',}{' --powersymbols',} | wc -l

# add mono and windows options:
printf " %s\n" {' --use-single-width-glyphs',}{' --windows',}{' --fontawesome',}{' --octicons',}{' --fontlinux',}{' --pomicons',}{' --powerlineextra',}{' --fontawesomeextension',}{' --powersymbols',}

printf " %s\n" {' --use-single-width-glyphs',}{' --windows',}{' --fontawesome',}{' --octicons',}{' --fontlinux',}{' --pomicons',}{' --powerlineextra',}{' --fontawesomeextension',}{' --powersymbols',} | wc -l

# get it ready for patcher format:
printf " %s\n" {' --use-single-width-glyphs',}{' --windows',}{' --fontawesome',}{' --octicons',}{' --fontlinux',}{' --pomicons',}{' --powerlineextra',}{' --fontawesomeextension',}{' --powersymbols',}

# this is gettin crazy :D
printf "./font-patcher %s\n" {' --powerline',}{' --use-single-width-glyphs',}{' --windows',}{' --fontawesome',}{' --octicons',}{' --fontlinux',}{' --pomicons',}{' --powerlineextra',}{' --fontawesomeextension',}{' --powersymbols',}

printf "./font-patcher %s\n" {' --powerline',}{' --use-single-width-glyphs',}{' --windows',}{' --fontawesome',}{' --octicons',}{' --fontlinux',}{' --pomicons',}{' --powerlineextra',}{' --fontawesomeextension',}{' --powersymbols',} | wc -l
cool_username="guest"
cool_host="foo.example.com"
# original source:
# http://railsdog.com/blog/2009/03/07/custom-bash-prompt-for-git-branches/

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

export PS1='\W$(__git_ps1 "[\[\e[0;32m\]%s\[\e[0m\]\[\e[0;33m\]$(parse_git_dirty)\[\e[0m\]]")$ '#!/bin/bash
# backup partitions using dd

echo "Back-up Files"

# variables
DATE=$(date +"%Y-%m-%d")
BACKUP_DIR_PARENT="/mnt/nas/msi-gp60-laptop"
DESTINATION_DIR=$BACKUP_DIR_PARENT/$DATE
# keep track of how long script takes to run
bench_start=$SECONDS
# store current path of script (help with relative paths)
MY_DIR=`dirname $0`

if [ -e $MY_DIR/unix-color-codes-not-escaped.sh ]; then
	echo -e "${On_Green}Unix color code file found, including.. ${Color_Off}"
	$MY_DIR/unix-color-codes-not-escaped.sh
else
	echo -e "${On_Red}Unix color code file not found${Color_Off}"
fi

# check if directory doesn't exist and not linked file
if [[ ! -d "${DESTINATION_DIR}" && ! -L "${DESTINATION_DIR}" ]] ; then
	echo -e "${On_Blue}Directory not found, probably first time running. creating: $DESTINATION_DIR${Color_Off}"
	# Control will enter here if $DIR doesn't exist.
	mkdir -p $DESTINATION_DIR
	# compare exit stats/code of last cmd
	if [ "$?" -ne "0" ]; then
		echo -e "${On_Red}Sorry, could not create the directory: ${DESTINATION_DIR} ${Color_Off}"
		exit 1
	fi
fi

# home backup
sudo dd if=/dev/sda7 | gzip -9  > $DESTINATION_DIR/sda7_home.img.gz
# filesystem root
sudo dd if=/dev/sda8 | gzip -9  > $DESTINATION_DIR/sda8_filesystem.img.gz

bench_end=$SECONDS

total_time=$(expr $bench_end - $bench_start)

echo "Backup finished successfully [total time in seconds: $total_time]"
#exit 0
#!/bin/bash
exec thunar ~/Dropbox
exit 0
# sources:
# http://unix.stackexchange.com/questions/34045/how-can-i-change-which-file-manager-dropbox-opens-with-by-default
#!/bin/bash
dd if=/dev/zero of=/c/filler5MB.dat bs=1M count=5
# source
# https://makandracards.com/makandra/1090-customize-your-bash-prompt

export PS1='\h \w$(__git_ps1 "(%s)") \$ '
=> mycomputer ~/apps/chess/tmp(master) $ _

export PS1='\[\e[33m\]\h\[\e[0m\]:\W\[\e[33m\]$(__git_ps1 "(%s)")\[\e[0m\] \u\$ '
=> mycomputer:tmp(master) tom$ _

# Henning's awesome TRON prompt 2.0.2 with current Git branch and success state of the last command (the syntax coloring here does not do it justice):
export PS1='`if [ $? = 0 ]; then echo "\[\033[01;32m\]✔"; else echo "\[\033[01;31m\]✘"; fi` \[\033[01;30m\]\h\[\033[01;34m\] \w\[\033[35m\]$(__git_ps1 " %s") \[\033[01;30m\]>\[\033[00m\] '
=> ✔ mycomputer ~/projects/platforms master > _

# Arne's epic timestamped prompt with return status indicator and status-colored (green or red, if unstaged) git branch:
export PS1='\[\e[01;30m\]\t `if [ $? = 0 ]; then echo "\[\e[32m\]"; else echo "\[\e[31m\]✘"; fi` \[\e[00;37m\]\u\[\e[01;37m\]:`[[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "\[\e[31m\]" || echo "\[\e[32m\]"`$(__git_ps1 "(%s)\[\e[00m\]")\[\e[01;34m\]\w\[\e[00m\]\$ '
=> 03:13:37 ✔ arne:(master)~/projects/geordi$ _

# Arne's danger prompt for root use. No git information and alarming red and yellow (which you can't see here):
export PS1='\[\e[01;30m\]\t \[\e[31m\]\u\[\e[37m\]:\[\e[33m\]\w\[\e[31m\]\$\[\033[00m\] '
=> 03:13:37 root:/tmp/foo# _

# Kim's mix of those above with small changes. TRON promt with timestamp, return status indicator, hostname, git informations and working directory (but all non-bold).
export PS1='\[\033[01;30m\]\t `if [ $? = 0 ]; then echo "\[\033[01;32m\]ツ"; else echo "\[\033[01;31m\]✗"; fi` \[\033[00;32m\]\h\[\033[00;37m\]:\[\033[31m\]$(__git_ps1 "(%s)\[\033[01m\]")\[\033[00;34m\]\w\[\033[00m\] >'
=> 03:13:37 ツ mycomputer:(master)~/code/foo >

# Kim's root promt (the same as above without git and the hostname is red)
export PS1='\[\033[01;30m\]\t `if [ $? = 0 ]; then echo "\[\033[01;32m\]ツ"; else echo "\[\033[01;31m\]✗"; fi` \[\033[00;31m\]\h\[\033[00;37m\]:\[\033[00;34m\]\w\[\033[00m\] >'
=> 03:13:37 ツ mycomputer:~/code/foo >#!/usr/bin/awk -f
#
# (c) 2011 Brian C. Milco
#
# This script parses the output of several git commands and presents the
# information in one line that can be added to a command prompt (PS1).
#
# If you use -v separator="|" separator2="/" when calling this script you can use other field separators.
#
# Sample output:
#
# | master | ▲ 1 ▼ 1 | 1/2/3/4 |1
#
# What the output means:
#
# | - field separator
# master - the branch name or (no branch) or (bare repository)
# ▲ 1 - how many commits on this branch not in the remote branch. You need to push changes to remote.
# ▼ 1 - how many commits on the remote branch not in this branch. You need to pull changes from remote.
# 1/2/3/4 - The count of changes in the repository:
# 1 - the number of staged changes. (green)
# 2 - the number of unstaged changes. (yellow)
# 3 - the number of unmerged changes. (magenta)
# 4 - the number of untracked changes. (red)
# |1 - the number of stashed changes. (yellow)
#

# original code from:
# https://gist.github.com/1266869

# old branch symbol: └├

function cmd( c )
{
    while( (c|getline foo) > 0 )
            continue;
    close( c );
    return foo;
}

BEGIN {
    #colors:
    black="\033[30m";
    dark_gray="\033[01;30m";
    red="\033[31m";
    bright_red="\033[1;31m";
    green="\033[32m";
    bright_green="\033[1;32m";
    yellow="\033[33m";
    bright_yellow="\033[1;33m";
    blue="\033[34m";
    bright_blue="\033[1;34m";
    violet="\033[35m";
    bright_violet="\033[1;35m";
    cyan="\033[036m";
    bright_cyan="\033[1;36m";
    white="\033[37m";
    light_gray="\033[00;37m";
    end_color="\033[0m";

    if(separator == "") {
        separator = "|";
    }

    if(separator2 == "") {
        separator2 = "-";
    }

    separator = dark_gray separator end_color;
    separator2 = dark_gray separator2 end_color;

    isRepo = 0;

    output = cmd("git rev-parse --git-dir 2> /dev/null");

    if(output) {

        bareTest = cmd("cat " output "/config | grep \"bare\" 2> /dev/null");
        if(bareTest ~ "true")
            bareRepo = 1;
        
        stashCount = cmd("git stash list | wc -l 2> /dev/null"); 
        gsub(/ /,"",stashCount);
        
        isRepo = 1;
    }

    changes["staged"] = 0;
    changes["unstaged"] = 0;
    changes["untracked"] = 0;
    changes["unmerged"] = 0;

}
{
    #only process lines that have data.
    if(skip > 0) {
        skip--;
        next;
    }

    test=$1 " " $2 " " $3;

    if(test == "# On branch") {
        branch = $4;
        next;
    } else if(test == "# Changes to") { #staged
        skip = 1;
        staged = 1;
        tracked = 1;
        merged = 1;
        next;
    } else if(test == "# Changes not") { #unstaged
        skip = 3;
        staged = 0;
        tracked = 1;
        merged = 1;
        next;
    } else if(test == "# Untracked files:") {#untracked
        skip = 2;
        staged = 0;
        tracked = 0;
        merged = 1;
        next;
    } else if(test == "# Unmerged paths:") {#unmerged
        skip = 2;
        staged = 0;
        tracked = 1;
        merged = 0;
        next;
    } else if($1 != "#") {
        next;
    } else if(test == "# Initial commit") {
        next;
    } else if(test == "# Your branch") { #branch is ahead/behind

        if($5 == "ahead") {
            ahead = $9;
        } else if($5 == "behind") {
            behind = $8;
        }         
        next;
    } else if(test == "# and have") { #branches have diverged
        ahead = $4;
        behind = $6;
        next;
    } else if(test == "# Not currently") {#detached HEAD
        branch = "(no branch)";
    }

    #Don't count blank lines
    if($0 == "#")
        next;

    if(staged == 1)
        changes["staged"] += 1;
    else if(staged == 0 && tracked == 1 && merged == 1)
        changes["unstaged"] += 1;
    else if(tracked == 0)
        changes["untracked"] += 1;
    else if(merged == 0)
        changes["unmerged"] += 1;

}
END {

    output = "";
    if(isRepo == 1) {

        branchOutput = separator " ";

        if(bareRepo == 1) {
            branchOutput = branchOutput bright_cyan "(bare repository)";
        } else {
            branchOutput = branchOutput bright_cyan "  " branch;
        }

        output = output branchOutput " " separator " ";

        if(bareRepo != 1) {

            if(ahead > 0 || behind > 0) {
                if(ahead > 0) {
                    output = output bright_yellow "▲ " end_color ahead;
                }
                if (behind > 0) {
                    output = output bright_yellow "▼ " end_color behind;
                }

                output = output " " separator " ";
            }

            #if there are changes show the output.
            if(changes["staged"] > 0 || changes["unstaged"] > 0 || changes["untracked"] > 0 || changes["unmerged"] > 0) {

                output = output bright_green changes["staged"] end_color;
                output = output separator2;

                output = output bright_yellow changes["unstaged"] end_color;
                output = output separator2;

                output = output violet changes["unmerged"] end_color;
                output = output separator2;

                output = output bright_red changes["untracked"] end_color;
                output = output " ";

            } else {
                output = output bright_green "√ ☺ " end_color;
            }

            if(stashCount > 0) {
                output = output separator bright_yellow " {≡" stashCount  "} " end_color;
            }
        } else {
            output = output  "no branch ";
        }

        printf output end_color;
    }
}
#    1) Copy this file to somewhere (e.g. ~/.git-prompt.sh).
#    2) Add the following line to your .bashrc/.zshrc:
#        source ~/.git-prompt.sh
#    3a) In ~/.bashrc set PROMPT_COMMAND=__git_ps1
#        To customize the prompt, provide start/end arguments
#        PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'
#    3b) Alternatively change your PS1 to call __git_ps1 as
#        command-substitution:
#        Bash: PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
#        ZSH:  PS1='[%n@%m %c$(__git_ps1 " (%s)")]\$ '
#        the optional argument will be used as format string

# GIT_PS1_SHOWDIRTYSTATE is enabled.

# If you would like to see if there're untracked files, then you can set
# GIT_PS1_SHOWUNTRACKEDFILES to a nonempty value. If there're untracked
# files, then a '%' will be shown next to the branch name.
#
# If you would like to see the difference between HEAD and its upstream,
# set GIT_PS1_SHOWUPSTREAM="auto".  A "<" indicates you are behind, ">"

#     verbose       show number of commits ahead/behind (+/-) upstream
#     legacy        don't use the '--count' option available in recent
#                   versions of git-rev-list
#     git           always compare HEAD to @{upstream}
#     svn           always compare HEAD to your SVN upstream

# __gitdir accepts 0 or 1 arguments (i.e., location)
# returns location of .git repo
__gitdir ()
{
	# Note: this function is duplicated in git-completion.bash
	# When updating it, make sure you update the other one to match.
	if [ -z "${1-}" ]; then
		if [ -n "${__git_dir-}" ]; then
			echo "$__git_dir"
		elif [ -n "${GIT_DIR-}" ]; then
			test -d "${GIT_DIR-}" || return 1
			echo "$GIT_DIR"
		elif [ -d .git ]; then
			echo .git
		else
			git rev-parse --git-dir 2>/dev/null
		fi
	elif [ -d "$1/.git" ]; then
		echo "$1/.git"
	else
		echo "$1"
	fi
}

# stores the divergence from upstream in $p
# used by GIT_PS1_SHOWUPSTREAM
__git_ps1_show_upstream ()
{
	local key value
	local svn_remote svn_url_pattern count n
	local upstream=git legacy="" verbose=""

	svn_remote=()
	# get some config options from git-config
	local output="$(git config -z --get-regexp '^(svn-remote\..*\.url|bash\.showupstream)$' 2>/dev/null | tr '\0\n' '\n ')"
	while read -r key value; do
		case "$key" in
		bash.showupstream)
			GIT_PS1_SHOWUPSTREAM="$value"
			if [[ -z "${GIT_PS1_SHOWUPSTREAM}" ]]; then
				p=""
				return
			fi
			;;
		svn-remote.*.url)
			svn_remote[ $((${#svn_remote[@]} + 1)) ]="$value"
			svn_url_pattern+="\\|$value"
			upstream=svn+git # default upstream is SVN if available, else git
			;;
		esac
	done <<< "$output"

	# parse configuration values
	for option in ${GIT_PS1_SHOWUPSTREAM}; do
		case "$option" in
		git|svn) upstream="$option" ;;
		verbose) verbose=1 ;;
		legacy)  legacy=1  ;;
		esac
	done

	# Find our upstream
	case "$upstream" in
	git)    upstream="@{upstream}" ;;
	svn*)
		# get the upstream from the "git-svn-id: ..." in a commit message
		# (git-svn uses essentially the same procedure internally)
		local svn_upstream=($(git log --first-parent -1 \
					--grep="^git-svn-id: \(${svn_url_pattern#??}\)" 2>/dev/null))
		if [[ 0 -ne ${#svn_upstream[@]} ]]; then
			svn_upstream=${svn_upstream[ ${#svn_upstream[@]} - 2 ]}
			svn_upstream=${svn_upstream%@*}
			local n_stop="${#svn_remote[@]}"
			for ((n=1; n <= n_stop; n++)); do
				svn_upstream=${svn_upstream#${svn_remote[$n]}}
			done

			if [[ -z "$svn_upstream" ]]; then
				# default branch name for checkouts with no layout:
				upstream=${GIT_SVN_ID:-git-svn}
			else
				upstream=${svn_upstream#/}
			fi
		elif [[ "svn+git" = "$upstream" ]]; then
			upstream="@{upstream}"
		fi
		;;
	esac

	# Find how many commits we are ahead/behind our upstream
	if [[ -z "$legacy" ]]; then
		count="$(git rev-list --count --left-right \
				"$upstream"...HEAD 2>/dev/null)"
	else
		# produce equivalent output to --count for older versions of git
		local commits
		if commits="$(git rev-list --left-right "$upstream"...HEAD 2>/dev/null)"
		then
			local commit behind=0 ahead=0
			for commit in $commits
			do
				case "$commit" in
				"<"*) ((behind++)) ;;
				*)    ((ahead++))  ;;
				esac
			done
			count="$behind	$ahead"
		else
			count=""
		fi
	fi

	# calculate the result
	if [[ -z "$verbose" ]]; then
		case "$count" in
		"") # no upstream
			p="" ;;
		"0	0") # equal to upstream
			p="=" ;;
		"0	"*) # ahead of upstream
			p=">" ;;
		*"	0") # behind upstream
			p="<" ;;
		*)	    # diverged from upstream
			p="<>" ;;
		esac
	else
		case "$count" in
		"") # no upstream
			p="" ;;
		"0	0") # equal to upstream
			p=" u=" ;;
		"0	"*) # ahead of upstream
			p=" u+${count#0	}" ;;
		*"	0") # behind upstream
			p=" u-${count%	0}" ;;
		*)	    # diverged from upstream
			p=" u+${count#*	}-${count%	*}" ;;
		esac
	fi

}


# __git_ps1 accepts 0 or 1 arguments (i.e., format string)
# when called from PS1 using command substitution
# in this mode it prints text to add to bash PS1 prompt (includes branch name)
#
# __git_ps1 requires 2 arguments when called from PROMPT_COMMAND (pc)
# in that case it _sets_ PS1. The arguments are parts of a PS1 string.
# when both arguments are given, the first is prepended and the second appended
# to the state string when assigned to PS1.
# In this mode you can request colored hints using GIT_PS1_SHOWCOLORHINTS=true
__git_ps1 ()
{
	local pcmode=no
	local detached=no
	local ps1pc_start='\u@\h:\w '
	local ps1pc_end='\$ '
	local printf_format=' (%s)'

	case "$#" in
		2)	pcmode=yes
			ps1pc_start="$1"
			ps1pc_end="$2"
		;;
		0|1)	printf_format="${1:-$printf_format}"
		;;
		*)	return
		;;
	esac

	local g="$(__gitdir)"
	if [ -z "$g" ]; then
		if [ $pcmode = yes ]; then
			#In PC mode PS1 always needs to be set
			PS1="$ps1pc_start$ps1pc_end"
		fi
	else
		local r=""
		local b=""
		if [ -f "$g/rebase-merge/interactive" ]; then
			r="|REBASE-i"
			b="$(cat "$g/rebase-merge/head-name")"
		elif [ -d "$g/rebase-merge" ]; then
			r="|REBASE-m"
			b="$(cat "$g/rebase-merge/head-name")"
		else
			if [ -d "$g/rebase-apply" ]; then
				if [ -f "$g/rebase-apply/rebasing" ]; then
					r="|REBASE"
				elif [ -f "$g/rebase-apply/applying" ]; then
					r="|AM"
				else
					r="|AM/REBASE"
				fi
			elif [ -f "$g/MERGE_HEAD" ]; then
				r="|MERGING"
			elif [ -f "$g/CHERRY_PICK_HEAD" ]; then
				r="|CHERRY-PICKING"
			elif [ -f "$g/BISECT_LOG" ]; then
				r="|BISECTING"
			fi

			b="$(git symbolic-ref HEAD 2>/dev/null)" || {
				detached=yes
				b="$(
				case "${GIT_PS1_DESCRIBE_STYLE-}" in
				(contains)
					git describe --contains HEAD ;;
				(branch)
					git describe --contains --all HEAD ;;
				(describe)
					git describe HEAD ;;
				(* | default)
					git describe --tags --exact-match HEAD ;;
				esac 2>/dev/null)" ||

				b="$(cut -c1-7 "$g/HEAD" 2>/dev/null)..." ||
				b="unknown"
				b="($b)"
			}
		fi

		local w=""
		local i=""
		local s=""
		local u=""
		local c=""
		local p=""

		if [ "true" = "$(git rev-parse --is-inside-git-dir 2>/dev/null)" ]; then
			if [ "true" = "$(git rev-parse --is-bare-repository 2>/dev/null)" ]; then
				c="BARE:"
			else
				b="GIT_DIR!"
			fi
		elif [ "true" = "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
			if [ -n "${GIT_PS1_SHOWDIRTYSTATE-}" ]; then
				if [ "$(git config --bool bash.showDirtyState)" != "false" ]; then
					git diff --no-ext-diff --quiet --exit-code || w="*"
					if git rev-parse --quiet --verify HEAD >/dev/null; then
						git diff-index --cached --quiet HEAD -- || i="+"
					else
						i="#"
					fi
				fi
			fi
			if [ -n "${GIT_PS1_SHOWSTASHSTATE-}" ]; then
				git rev-parse --verify refs/stash >/dev/null 2>&1 && s="$"
			fi

			if [ -n "${GIT_PS1_SHOWUNTRACKEDFILES-}" ]; then
				if [ -n "$(git ls-files --others --exclude-standard)" ]; then
					u="%"
				fi
			fi

			if [ -n "${GIT_PS1_SHOWUPSTREAM-}" ]; then
				__git_ps1_show_upstream
			fi
		fi

		local f="$w$i$s$u"
		if [ $pcmode = yes ]; then
			if [ -n "${GIT_PS1_SHOWCOLORHINTS-}" ]; then
				local c_red='\e[31m'
				local c_green='\e[32m'
				local c_lblue='\e[1;34m'
				local c_clear='\e[0m'
				local bad_color=$c_red
				local ok_color=$c_green
				local branch_color="$c_clear"
				local flags_color="$c_lblue"
				local branchstring="$c${b##refs/heads/}"

				if [ $detached = no ]; then
					branch_color="$ok_color"
				else
					branch_color="$bad_color"
				fi

				# Setting PS1 directly with \[ and \] around colors
				# is necessary to prevent wrapping issues!
				PS1="$ps1pc_start (\[$branch_color\]$branchstring\[$c_clear\]"

				if [ -n "$w$i$s$u$r$p" ]; then
					PS1="$PS1 "
				fi
				if [ "$w" = "*" ]; then
					PS1="$PS1\[$bad_color\]$w"
				fi
				if [ -n "$i" ]; then
					PS1="$PS1\[$ok_color\]$i"
				fi
				if [ -n "$s" ]; then
					PS1="$PS1\[$flags_color\]$s"
				fi
				if [ -n "$u" ]; then
					PS1="$PS1\[$bad_color\]$u"
				fi
				PS1="$PS1\[$c_clear\]$r$p)$ps1pc_end"
			else
				PS1="$ps1pc_start ($c${b##refs/heads/}${f:+ $f}$r$p)$ps1pc_end"
			fi
		else
			# NO color option unless in PROMPT_COMMAND mode
			printf -- "$printf_format" "$c${b##refs/heads/}${f:+ $f}$r$p"
		fi
	fi
}# search for 'audience' AND 'segment'
# http://stackoverflow.com/questions/4795323/grep-for-multiple-strings-in-file-on-different-lines-ie-whole-file-not-line-b
grep -iIrnl audience * | xargs grep -iIrnl segment
#!/bin/sh

# first attempt

# grep -rin -e 'console\.log\|debugger' ./web/js/ # to dependent on file structure

# second attempt

# http://www.daniweb.com/community-center/it-professionals-lounge/threads/85626

# Which translates in english to.. search (find) in this folder (.) for files matching the filter ( -name ) *.php [ recursiveness should be default ]; when each file is found, execute grep, look for 'some_string', and pass in the found filename ( where the {} placeholder is ). Because that effectively executes grep once per file ( rather than once for many files ), you need the -H option to force grep to turn on the output of the filename; it wouldn't bother otherwise for a single file grep.

find . -name "*.js" -exec grep -rinH -e 'console\.log\|debugger' {} \;#The following lines should be added to your .bashrc file to use the git-output.awk file

# ⚫ ❨ ❩ ▲ ⬇ ⑈ ⑉ ǁ» ║ ⑆ ⑇ ⟅ ⟆ ⬅ ➤ ➥ ➦ ➡
SEPARATOR="‡"
SEPARATOR2="|"


function parse_git_output {

    output=$(git status 2> /dev/null | ~/Bash-Scripts/git-output.awk -v separator=$SEPARATOR separator2=$SEPARATOR2 2> /dev/null) || return
    echo -e "$output";
}

BLACK="\[\e[00;30m\]"
DARY_GRAY="\[\e[01;30m\]"
RED="\[\e[00;31m\]"
BRIGHT_RED="\[\e[01;31m\]"
GREEN="\[\e[00;32m\]"
BRIGHT_GREEN="\[\e[01;32m\]"
BROWN="\[\e[00;33m\]"
YELLOW="\[\e[01;33m\]"
BLUE="\[\e[00;34m\]"
BRIGHT_BLUE="\[\e[01;34m\]"
PURPLE="\[\e[00;35m\]"
LIGHT_PURPLE="\[\e[01;35m\]"
CYAN="\[\e[00;36m\]"
BRIGHT_CYAN="\[\e[01;36m\]"
LIGHT_GRAY="\[\e[00;37m\]"
WHITE="\[\e[01;37m\]"
ENDCOLOR="\e[m"

if [ "$SSH_CONNECTION" == "" ]; then
    PS1="${BRIGHT_RED}#--[ ${GREEN}\h ${DARY_GRAY}${SEPARATOR} ${BRIGHT_BLUE}\w \$(parse_git_output)${BRIGHT_RED}]\\$ -->${ENDCOLOR}\n"
else
    PS1="${BRIGHT_RED}#--[ ${YELLOW}\h ${DARY_GRAY}${SEPARATOR} ${BRIGHT_BLUE}\w \$(parse_git_output)${BRIGHT_RED}]\\$ -->${ENDCOLOR}\n"
fi
#The following lines should be added to your .bashrc file to use the git-output.awk file

# ⚫ ❨ ❩ ▲ ⬇ ⑈ ⑉ ǁ ║ ⑆ ⑇ ⟅ ⟆ ⬅ ➤ ➥ ➦ ➡
SEPARATOR="ǁ"
SEPARATOR2="║"

function parse_git_output {

    output=$(git status 2> /dev/null | git.awk -v separator=$SEPARATOR separator2=$SEPARATOR2 2> /dev/null) || return
    echo -e "$output";
}

BLACK="\[\e[00;30m\]"
DARY_GRAY="\[\e[01;30m\]"
RED="\[\e[00;31m\]"
BRIGHT_RED="\[\e[01;31m\]"
GREEN="\[\e[00;32m\]"
BRIGHT_GREEN="\[\e[01;32m\]"
BROWN="\[\e[00;33m\]"
YELLOW="\[\e[01;33m\]"
BLUE="\[\e[00;34m\]"
BRIGHT_BLUE="\[\e[01;34m\]"
PURPLE="\[\e[00;35m\]"
LIGHT_PURPLE="\[\e[01;35m\]"
CYAN="\[\e[00;36m\]"
BRIGHT_CYAN="\[\e[01;36m\]"
LIGHT_GRAY="\[\e[00;37m\]"
WHITE="\[\e[01;37m\]"
ENDCOLOR="\e[m"

if [ "$SSH_CONNECTION" == "" ]; then
    PS1="${BRIGHT_RED}#--[ ${GREEN}\h ${DARY_GRAY}${SEPARATOR} ${BRIGHT_BLUE}\w \$(parse_git_output)${BRIGHT_RED}]\\$ --≻${ENDCOLOR}\n"
else
    PS1="${BRIGHT_RED}#--[ ${YELLOW}\h ${DARY_GRAY}${SEPARATOR} ${BRIGHT_BLUE}\w \$(parse_git_output)${BRIGHT_RED}]\\$ --≻${ENDCOLOR}\n"
fi#!/bin/bash

# make folders a through z

for i in {A..Z};do mkdir $i;done#!/bin/bash

# move files beginning w/ A..Z to A..Z folders

# wont work for filetypes (does all):
#for f in *
# do dangerous and complicated:
#for f in 'ls'
for f in *; do
	if [ -f "$f" ]
	then 
		#echo "$f file";
		FIRST_CHAR=${f:0:1};
		#echo "first char = $FIRST_CHAR";
		#FIRST_CHAR_UPPER=$FIRST_CHAR | tr [:lower:] [:upper:];
		FIRST_CHAR_UPPER=$(echo "$FIRST_CHAR" | tr [:lower:] [:upper:]);
		#echo "mv \"$f\" \"$FIRST_CHAR_UPPER/$f\"";
		mv "$f" "$FIRST_CHAR_UPPER/$f";
	else
		echo "skipping $f not a file";
	fi
done#!/bin/sh
#
# Move the current window to the next monitor.
#
# Only works on a horizontal monitor setup.
# Also works only on one X screen (which is the most common case).
#
# Props to
# http://icyrock.com/blog/2012/05/xubuntu-moving-windows-between-monitors/
#
# Unfortunately, both "xdotool getwindowgeometry --shell $window_id" and
# checking "-geometry" of "xwininfo -id $window_id" are not sufficient, as
# the first command does not respect panel/decoration offsets and the second
# will sometimes give a "-0-0" geometry. This is why we resort to "xwininfo".

screen_width=`xdpyinfo | awk '/dimensions:/ { print $2; exit }' | cut -d"x" -f1`
display_width=`xdotool getdisplaygeometry | cut -d" " -f1`
window_id=`xdotool getactivewindow`

# Remember if it was maximized.
window_state=`xprop -id $window_id _NET_WM_STATE | awk '{ print $3 }'`

# Un-maximize current window so that we can move it
wmctrl -ir $window_id -b remove,maximized_vert,maximized_horz

# Read window position
x=`xwininfo -id $window_id | awk '/Absolute upper-left X:/ { print $4 }'`
y=`xwininfo -id $window_id | awk '/Absolute upper-left Y:/ { print $4 }'`

# Subtract any offsets caused by panels or window decorations
x_offset=`xwininfo -id $window_id | awk '/Relative upper-left X:/ { print $4 }'`
y_offset=`xwininfo -id $window_id | awk '/Relative upper-left Y:/ { print $4 }'`
x=`expr $x - $x_offset`
y=`expr $y - $y_offset`

# Compute new X position
new_x=`expr $x + $display_width`

# If we would move off the right-most monitor, we set it to the left one.
# We also respect the window's width here: moving a window off more than half its width won't happen.
width=`xdotool getwindowgeometry $window_id | awk '/Geometry:/ { print $2 }'|cut -d"x" -f1`
if [ `expr $new_x + $width / 2` -gt $screen_width ]; then
  new_x=`expr $new_x - $screen_width`
fi

# Don't move off the left side.
if [ $new_x -lt 0 ]; then
  new_x=0
fi

# Move the window
xdotool windowmove $window_id $new_x $y

# Maximize window again, if it was before
if [ -n "${window_state}" ]; then
  wmctrl -ir $window_id -b add,maximized_vert,maximized_horz
fi
#!/bin/bash
# disable dropbox start at boot (in dropbox gui)
# requires package: cpulimit (sudo apt-get install cpulimit)
# add this script to startup
# xfce session and startup original description:
# Name: Dropbox
# Description: Sync your files across computers and to the web
# Command: dropbox start -i

# no icon? or missing fix:
# http://askubuntu.com/questions/732967/dropbox-icon-is-not-working-xubuntu-14-04-lts-64

# just in case?
dropbox stop

DBUS_SESSION_BUS_ADDRESS="" && ionice -c 3 dropbox start -i && cpulimit -b -e dropbox -l 20
# this is working adhoc:
#dropbox stop && DBUS_SESSION_BUS_ADDRESS="" dropbox start

exit 0
# sources:
# http://askubuntu.com/questions/252484/how-do-i-limit-dropboxs-activity-on-the-hard-disk
#!/bin/bash

echo "Reading config...." >&2
source config.cfg
echo "Config for the username: $cool_username" >&2
echo "Config for the target host: $cool_host" >&2

# sources
# http://wiki.bash-hackers.org/howto/conffile
#!/bin/sh

# http://stackoverflow.com/questions/6595429/using-sed-to-remove-all-console-log-from-javascript-file
# http://tille.garrels.be/training/bash/ch07s02.html (bash help)

# sed usage example:
# sed -e 's/SEARCH_STRING/REPLACE_STRING/g' file > file.out
# have to escape all / (forward slashes) because has special meaning in sed
SEARCH_STRING="(\/\/)*console.(log|debug|info|warn|error|assert|dir|dirxml|trace|group|groupEnd|time|timeEnd|profile|profileEnd|count)\((.*)\);?"
REPLACE_STRING="void 0"

function removeLogFromFile {
  echo "Modifying file $1!"
	sed -E "s/$SEARCH_STRING/$REPLACE_STRING/g" $1 > "$1.tmp"
	# sed -E "s/$SEARCH_STRING/ d" $1 > "$1.tmp"
	cp "$1.tmp" $1
	rm "$1.tmp"
}

if [ ! $# == 1 ]; then
  echo "You Must provide 1 argument (the file to modify)"
  exit 1
elif [ ! -f $1 ] && [ ! -d $1 ]; then
  echo "This thing you passed is not a file or directory"
  exit 1
elif [ -f $1 ]; then
  echo "You passed a file!"
  removeLogFromFile $1
elif [ -d $1 ]; then
  echo "You passed a directory $1!"
  for i in $(find $1 -name "*.js")
  do
    removeLogFromFile $i
  done
else echo "Not sure what to do with $i";
fi
echo "Complete"
# source: http://www.electricmonk.nl/log/2012/04/24/re-use-existing-ssh-agent-cygwin-et-al/


# If no SSH agent is already running, start one now. Re-use sockets so we never
# have to start more than one session.

export SSH_AUTH_SOCK=/home/Ryan/.ssh-socket

ssh-add -l >/dev/null 2>&1
if [ $? = 2 ]; then
   # No ssh-agent running
   rm -rf $SSH_AUTH_SOCK
   ssh-agent -a $SSH_AUTH_SOCK >/tmp/.ssh-script
   source /tmp/.ssh-script
   echo $SSH_AGENT_PID > ~/.ssh-agent-pid
   rm /tmp/.ssh-script
fi
#!/bin/bash

# https://www.google.com/search?ix=iea&sourceid=chrome&ie=UTF-8&q=cygwin+cron
# http://stackoverflow.com/questions/707184/how-do-you-run-a-crontab-in-cygwin-on-windows


#cd /cygdrive/c/Development/Bash-Scripts/

#./backup.sh

./cygdrive/c/Users/Ryan/Bash-Scripts/backup.sh

exit 0SSH_ENV="$HOME/.ssh/environment"

# start the ssh-agent
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
    echo succeeded
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" > /dev/null
    ssh-add
}

# test for identities
function test_identities {
    # test whether standard identities have been added to the agent already
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $? -eq 0 ]; then
        ssh-add
        # $SSH_AUTH_SOCK broken so we start a new proper agent
        if [ $? -eq 2 ];then
            start_agent
        fi
    fi
}

# check for running ssh-agent with proper $SSH_AGENT_PID
if [ -n "$SSH_AGENT_PID" ]; then
    ps -ef | grep "$SSH_AGENT_PID" | grep ssh-agent > /dev/null
    if [ $? -eq 0 ]; then
  test_identities
    fi
# if $SSH_AGENT_PID is not properly set, we might be able to load one from
# $SSH_ENV
else
    if [ -f "$SSH_ENV" ]; then
  . "$SSH_ENV" > /dev/null
    fi
    ps -ef | grep "$SSH_AGENT_PID" | grep ssh-agent > /dev/null
    if [ $? -eq 0 ]; then
        test_identities
    else
        start_agent
    fi
fi#!/bin/bash
# https://gist.github.com/gmmorris/796400
sudo pkill -9 apache
# might need this too...:
sudo service mysql stop
# now start it
sudo /opt/lampp/lampp start
#!/bin/bash
# @author Ryan McIntyre

# log like: /c/wamp/www/proto/portal/log/frontend_local.log

ME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
MY_DIR=`dirname $0`

if [ -e $MY_DIR/unix-color-codes-not-escaped.sh ]; then
	. $MY_DIR/unix-color-codes-not-escaped.sh
fi

if [ $# == 0 ]; then
	echo -e "${On_Red}No log file given, usage: $ME <FILE_NAME>${Color_Off}"
	exit 1
else
	LOG_FILE=$1
	echo "Showing tail of: $LOG_FILE"
fi

tail -f $LOG_FILE | awk '
  /200 OK/ {print "\033[32m" $0 "\033[39m"; next}
  /View "Success"/ {print "\033[33m" $0 "\033[39m"; next}
  /sfPatternRouting/ {print "\033[35m" $0 "\033[39m"; next}
  /Doctrine_Connection/ {print "\033[36m" $0 "\033[39m"; next}
  /err/ {print "\033[31m" $0 "\033[39m"; next}
  /severe/ {print "\033[31m" $0 "\033[39m"; next}
  /debug/ {print "\033[34m" $0 "\033[39m"; next}
  1 {print}
'

# sources:

## http://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts
#!/bin/bash

echo "test"

echo "test params"

POSTFIX_NAME="_"$1

if [ $# != 0 ]; then
	echo 'postfix name given:' $POSTFIX_NAME
else
	echo 'no input'
fi

exit 0

#!/bin/bash
# thank you: http://www.linuxquestions.org/questions/debian-26/shmconfig-in-debian-645503/#post3838794
# script to turn off touchpad if mouse present at login
# synclient is the synaptic utility to manage the touchpad
# grep the "lsusb" output and do a wordcount on number of lines with "Logitech" which should = 1 if a Logitech mouse is present
#
# Obviously the "Logitech" should be replaced with your brand of mouse, and perhaps be more exact in case you have other USB devices that have similar names

# I found on: http://crunchbang.org/forums/viewtopic.php?id=15992

/usr/bin/synclient touchpadoff=`lsusb | grep Logitech | wc -l`
# original source:
# http://mediadoneright.com/content/ultimate-git-ps1-bash-prompt

#  Customize BASH PS1 prompt to show current GIT repository and branch.
#  by Mike Stewart - http://MediaDoneRight.com

#  SETUP CONSTANTS
#  Bunch-o-predefined colors.  Makes reading code easier than escape sequences.
#  I don't remember where I found this.  o_O

# Reset
Color_Off="\[\033[0m\]"       # Text Reset

# Regular Colors
Black="\[\033[0;30m\]"        # Black
Red="\[\033[0;31m\]"          # Red
Green="\[\033[0;32m\]"        # Green
Yellow="\[\033[0;33m\]"       # Yellow
Blue="\[\033[0;34m\]"         # Blue
Purple="\[\033[0;35m\]"       # Purple
Cyan="\[\033[0;36m\]"         # Cyan
White="\[\033[0;37m\]"        # White

# Bold
BBlack="\[\033[1;30m\]"       # Black
BRed="\[\033[1;31m\]"         # Red
BGreen="\[\033[1;32m\]"       # Green
BYellow="\[\033[1;33m\]"      # Yellow
BBlue="\[\033[1;34m\]"        # Blue
BPurple="\[\033[1;35m\]"      # Purple
BCyan="\[\033[1;36m\]"        # Cyan
BWhite="\[\033[1;37m\]"       # White

# Underline
UBlack="\[\033[4;30m\]"       # Black
URed="\[\033[4;31m\]"         # Red
UGreen="\[\033[4;32m\]"       # Green
UYellow="\[\033[4;33m\]"      # Yellow
UBlue="\[\033[4;34m\]"        # Blue
UPurple="\[\033[4;35m\]"      # Purple
UCyan="\[\033[4;36m\]"        # Cyan
UWhite="\[\033[4;37m\]"       # White

# Background
On_Black="\[\033[40m\]"       # Black
On_Red="\[\033[41m\]"         # Red
On_Green="\[\033[42m\]"       # Green
On_Yellow="\[\033[43m\]"      # Yellow
On_Blue="\[\033[44m\]"        # Blue
On_Purple="\[\033[45m\]"      # Purple
On_Cyan="\[\033[46m\]"        # Cyan
On_White="\[\033[47m\]"       # White

# High Intensty
IBlack="\[\033[0;90m\]"       # Black
IRed="\[\033[0;91m\]"         # Red
IGreen="\[\033[0;92m\]"       # Green
IYellow="\[\033[0;93m\]"      # Yellow
IBlue="\[\033[0;94m\]"        # Blue
IPurple="\[\033[0;95m\]"      # Purple
ICyan="\[\033[0;96m\]"        # Cyan
IWhite="\[\033[0;97m\]"       # White

# Bold High Intensty
BIBlack="\[\033[1;90m\]"      # Black
BIRed="\[\033[1;91m\]"        # Red
BIGreen="\[\033[1;92m\]"      # Green
BIYellow="\[\033[1;93m\]"     # Yellow
BIBlue="\[\033[1;94m\]"       # Blue
BIPurple="\[\033[1;95m\]"     # Purple
BICyan="\[\033[1;96m\]"       # Cyan
BIWhite="\[\033[1;97m\]"      # White

# High Intensty backgrounds
On_IBlack="\[\033[0;100m\]"   # Black
On_IRed="\[\033[0;101m\]"     # Red
On_IGreen="\[\033[0;102m\]"   # Green
On_IYellow="\[\033[0;103m\]"  # Yellow
On_IBlue="\[\033[0;104m\]"    # Blue
On_IPurple="\[\033[10;95m\]"  # Purple
On_ICyan="\[\033[0;106m\]"    # Cyan
On_IWhite="\[\033[0;107m\]"   # White

# Various variables you might want for your PS1 prompt instead
Time12h="\T"
Time12a="\@"
PathShort="\w"
PathFull="\W"
NewLine="\n"
Jobs="\j"


# This PS1 snippet was adopted from code for MAC/BSD I saw from: http://allancraig.net/index.php?option=com_content&view=article&id=108:ps1-export-command-for-git&catid=45:general&Itemid=96
# I tweaked it to work on UBUNTU 11.04 & 11.10 plus made it mo' better

export PS1=$Green$Time12h$Color_Off'$(git branch &>/dev/null;\
if [ $? -eq 0 ]; then \
  echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
  if [ "$?" -eq "0" ]; then \
    # @4 - Clean repository - nothing to commit
    echo "'$Green'"$(__git_ps1 " (%s)"); \
  else \
    # @5 - Changes to working tree
    echo "'$BRed$On_Red'"$(__git_ps1 " {%s}*"); \
  fi) '$Color_Off$BYellow$PathShort$Color_Off'\$ "; \
else \
  # @2 - Prompt when not in GIT repo
  echo " '$BYellow$PathShort$Color_Off'\$ "; \
fi)'
#!/bin/bash
# http://stackoverflow.com/questions/26176481/generate-combinations-of-elements-with-echo

POWER=$((2**$#))
#BITS=`seq -f '0' -s '' 1 $#`
BITS=`eval echo {1..$#} | sed -E 's/[0-9]+[ ]*/0/g'`

while [ $POWER -gt 1 ];do
  POWER=$(($POWER-1))
  BIN=`bc <<< "obase=2; $POWER"`
  MASK=`echo $BITS | sed -e "s/0\{${#BIN}\}$/$BIN/" | grep -o .`
  POS=1; AWK=`for M in $MASK;do
    [ $M -eq 1 ] && echo -n "print \\$\${POS};"
    POS=$(($POS+1))
    done;echo`
  awk -v ORS=" " "{$AWK}" <<< "$@" | sed 's/ $//'
done


# Reset
Color_Off="\033[0m"       # Text Reset

# Regular Colors
Black="\033[0;30m"        # Black
Red="\033[0;31m"          # Red
Green="\033[0;32m"        # Green
Yellow="\033[0;33m"       # Yellow
Blue="\033[0;34m"         # Blue
Purple="\033[0;35m"       # Purple
Cyan="\033[0;36m"         # Cyan
White="\033[0;37m"        # White

# Bold
BBlack="\033[1;30m"       # Black
BRed="\033[1;31m"         # Red
BGreen="\033[1;32m"       # Green
BYellow="\033[1;33m"      # Yellow
BBlue="\033[1;34m"        # Blue
BPurple="\033[1;35m"      # Purple
BCyan="\033[1;36m"        # Cyan
BWhite="\033[1;37m"       # White

# Underline
UBlack="\033[4;30m"       # Black
URed="\033[4;31m"         # Red
UGreen="\033[4;32m"       # Green
UYellow="\033[4;33m"      # Yellow
UBlue="\033[4;34m"        # Blue
UPurple="\033[4;35m"      # Purple
UCyan="\033[4;36m"        # Cyan
UWhite="\033[4;37m"       # White

# Background
On_Black="\033[40m"       # Black
On_Red="\033[41m"         # Red
On_Green="\033[42m"       # Green
On_Yellow="\033[43m"      # Yellow
On_Blue="\033[44m"        # Blue
On_Purple="\033[45m"      # Purple
On_Cyan="\033[46m"        # Cyan
On_White="\033[47m"       # White

# High Intensty
IBlack="\033[0;90m"       # Black
IRed="\033[0;91m"         # Red
IGreen="\033[0;92m"       # Green
IYellow="\033[0;93m"      # Yellow
IBlue="\033[0;94m"        # Blue
IPurple="\033[0;95m"      # Purple
ICyan="\033[0;96m"        # Cyan
IWhite="\033[0;97m"       # White

# Bold High Intensty
BIBlack="\033[1;90m"      # Black
BIRed="\033[1;91m"        # Red
BIGreen="\033[1;92m"      # Green
BIYellow="\033[1;93m"     # Yellow
BIBlue="\033[1;94m"       # Blue
BIPurple="\033[1;95m"     # Purple
BICyan="\033[1;96m"       # Cyan
BIWhite="\033[1;97m"      # White

# High Intensty backgrounds
On_IBlack="\033[0;100m"   # Black
On_IRed="\033[0;101m"     # Red
On_IGreen="\033[0;102m"   # Green
On_IYellow="\033[0;103m"  # Yellow
On_IBlue="\033[0;104m"    # Blue
On_IPurple="\033[10;95m"  # Purple
On_ICyan="\033[0;106m"    # Cyan
On_IWhite="\033[0;107m"   # White



BLACK="\e[00;30m"
DARY_GRAY="\e[01;30m"
RED="\e[00;31m"
BRIGHT_RED="\e[01;31m"
GREEN="\e[00;32m"
BRIGHT_GREEN="\e[01;32m"
BROWN="\e[00;33m"
YELLOW="\e[01;33m"
BLUE="\e[00;34m"
BRIGHT_BLUE="\e[01;34m"
PURPLE="\e[00;35m"
LIGHT_PURPLE="\e[01;35m"
CYAN="\e[00;36m"
BRIGHT_CYAN="\e[01;36m"
LIGHT_GRAY="\e[00;37m"
WHITE="\e[01;37m"
ENDCOLOR="\e[m"

# sample FOO="${GREEN}bar${ENDCOLOR}"
# OR
# echo echo -e "\e[00;32mfoo\e[mbar"
# OR
# echo -e "\033[0;42m hi \033[0m"
# OR
# echo -e "${On_Green} hi${Color_Off} man"

# Reset
Color_Off="\[\033[0m\]"       # Text Reset

# Regular Colors
Black="\[\033[0;30m\]"        # Black
Red="\[\033[0;31m\]"          # Red
Green="\[\033[0;32m\]"        # Green
Yellow="\[\033[0;33m\]"       # Yellow
Blue="\[\033[0;34m\]"         # Blue
Purple="\[\033[0;35m\]"       # Purple
Cyan="\[\033[0;36m\]"         # Cyan
White="\[\033[0;37m\]"        # White

# Bold
BBlack="\[\033[1;30m\]"       # Black
BRed="\[\033[1;31m\]"         # Red
BGreen="\[\033[1;32m\]"       # Green
BYellow="\[\033[1;33m\]"      # Yellow
BBlue="\[\033[1;34m\]"        # Blue
BPurple="\[\033[1;35m\]"      # Purple
BCyan="\[\033[1;36m\]"        # Cyan
BWhite="\[\033[1;37m\]"       # White

# Underline
UBlack="\[\033[4;30m\]"       # Black
URed="\[\033[4;31m\]"         # Red
UGreen="\[\033[4;32m\]"       # Green
UYellow="\[\033[4;33m\]"      # Yellow
UBlue="\[\033[4;34m\]"        # Blue
UPurple="\[\033[4;35m\]"      # Purple
UCyan="\[\033[4;36m\]"        # Cyan
UWhite="\[\033[4;37m\]"       # White

# Background
On_Black="\[\033[40m\]"       # Black
On_Red="\[\033[41m\]"         # Red
On_Green="\[\033[42m\]"       # Green
On_Yellow="\[\033[43m\]"      # Yellow
On_Blue="\[\033[44m\]"        # Blue
On_Purple="\[\033[45m\]"      # Purple
On_Cyan="\[\033[46m\]"        # Cyan
On_White="\[\033[47m\]"       # White

# High Intensty
IBlack="\[\033[0;90m\]"       # Black
IRed="\[\033[0;91m\]"         # Red
IGreen="\[\033[0;92m\]"       # Green
IYellow="\[\033[0;93m\]"      # Yellow
IBlue="\[\033[0;94m\]"        # Blue
IPurple="\[\033[0;95m\]"      # Purple
ICyan="\[\033[0;96m\]"        # Cyan
IWhite="\[\033[0;97m\]"       # White

# Bold High Intensty
BIBlack="\[\033[1;90m\]"      # Black
BIRed="\[\033[1;91m\]"        # Red
BIGreen="\[\033[1;92m\]"      # Green
BIYellow="\[\033[1;93m\]"     # Yellow
BIBlue="\[\033[1;94m\]"       # Blue
BIPurple="\[\033[1;95m\]"     # Purple
BICyan="\[\033[1;96m\]"       # Cyan
BIWhite="\[\033[1;97m\]"      # White

# High Intensty backgrounds
On_IBlack="\[\033[0;100m\]"   # Black
On_IRed="\[\033[0;101m\]"     # Red
On_IGreen="\[\033[0;102m\]"   # Green
On_IYellow="\[\033[0;103m\]"  # Yellow
On_IBlue="\[\033[0;104m\]"    # Blue
On_IPurple="\[\033[10;95m\]"  # Purple
On_ICyan="\[\033[0;106m\]"    # Cyan
On_IWhite="\[\033[0;107m\]"   # White



BLACK="\[\e[00;30m\]"
DARY_GRAY="\[\e[01;30m\]"
RED="\[\e[00;31m\]"
BRIGHT_RED="\[\e[01;31m\]"
GREEN="\[\e[00;32m\]"
BRIGHT_GREEN="\[\e[01;32m\]"
BROWN="\[\e[00;33m\]"
YELLOW="\[\e[01;33m\]"
BLUE="\[\e[00;34m\]"
BRIGHT_BLUE="\[\e[01;34m\]"
PURPLE="\[\e[00;35m\]"
LIGHT_PURPLE="\[\e[01;35m\]"
CYAN="\[\e[00;36m\]"
BRIGHT_CYAN="\[\e[01;36m\]"
LIGHT_GRAY="\[\e[00;37m\]"
WHITE="\[\e[01;37m\]"
ENDCOLOR="\e[m"

# sample FOO="${GREEN}bar${ENDCOLOR}"
# OR
# echo echo -e "\e[00;32mfoo\e[mbar"
# OR
# echo -e "\033[0;42m hi \033[0m"
# OR
# echo -e "${On_Green} hi${Color_Off} man"#!/bin/bash

echo 'tasklist, show high memory usage tasks'

# this could be useful in use with Samurize

tasklist /FI "MEMUSAGE gt 100000"#!/bin/sh
# http://stackoverflow.com/questions/1881594/use-winmerge-inside-of-git-to-file-diff
echo Launching WinMergeU.exe: $1 $2
#"$PROGRAMFILES/WinMerge/WinMergeU.exe" -e -ub -dl "Base" -dr "Mine" "$1" "$2"
"C:\Development/WinMerge/WinMergeU.exe" -e -ub -dl "Base" -dr "Mine" "$1" "$2"#!/bin/bash

while [ $# -gt 0 ]; do
    case "$1" in
        -h | --help)
            echo -e "${yellow}OpenVPN automatic server and client certificate(s) setup script, v0.01 :: Author: niemal"
            echo -e "      ${white}For a client certificate/package only refer to the create_client.sh script.\n"
            echo -e "Parameters:"
            echo -e "  $lightred--clients $white[integer]$nocolour            - Specifies the amount of client certificates to be automatically created. Default is 1."
            echo -e "  $lightred--servername $white[string(text)]$nocolour    - Defines the server's name. Default is 'server'."
            echo -e "  $lightred--sslconf $white[absolute(path)]$nocolour     - Path for the openssl.cnf creation. It is created by default at '/etc/openvpn/openssl.cnf'."
            echo -e "  $lightred--certs $white[absolute(path)]$nocolour       - Path to the certificates directory. If it doesn't exist, it gets created. Default is '/etc/openvpn/certs'."
            echo -e "  $lightred--certmodulus $white[integer(bit)]$nocolour   - The RSA modulus bit setting. Default is 2048."
            echo -e "  $lightred--expires $white[integer(days)]$nocolour      - The certificate expiration in days. Default is 31337."
            echo -e "  $lightred--duplicate-cn$nocolour                 - Allow duplicate certificates in the network. Default is to not."
            echo -e "  $lightred--cipher $white[string(cipher)]$nocolour      - The server's encryption cipher. Default is AES-256-CBC."
            echo -e "  $lightred--port $white[integer(port)]$nocolour         - The server's port. Default is 1194."
            echo -e "  $lightred--vpnsubnet $white[string(subnet)]$nocolour   - The network's subnet, CIDR 24. Default is '10.8.0.0'."
            echo -e "  $lightred--dns1 $white[string(ip)]$nocolour            - Defines DNS #1 for the server.conf. Default is OpenDNS, 208.67.222.222."
            echo -e "  $lightred--dns2 $white[string(ip)]$nocolour            - Defines DNS #2 for server.conf. Default is OpenDNS, 208.67.220.220."
            echo -e "  $lightred--exitnode$nocolour                     - Configures iptables so the client can access the internet through the VPN. Requires --iface."
            echo -e "  $lightred--iface $white[string(interface)]$nocolour    - Declares the interface for --exitnode. Default is eth0."
            exit 0;;
        -c | --clients)
            shift
            clients=$1;;
        -s | --servername)
            shift
            servername=$1;;
        -ssl | --sslconf)
            shift
            sslconf=$1;;
        -ce | --certs)
            shift
            certs=$1;;
        -cm | --certmodulus)
            shift
            certmodulus=$1;;
        -e | --expires)
            shift
            expiration=$1;;
        -dcn | --duplicate-cn)
            shift
            duplicatecn="duplicate-cn";;
        -ci | --cipher)
            shift
            cipher=$1;;
        -p | --port)
            shift
            port=$1;;
        -pro | --proto)
            shift
            proto=$1;;
        -sub | --vpnsubnet)
            shift
            vpnsubnet=$1;;
        -d1 | --dns1)
            shift
            dns1=$1;;
        -d2 | --dns2)
            shift
            dns2=$1;;
        -en | --exitnode)
            shift
            exitnode=true;;
        -if | --iface)
            shift
            iface=$1;;
    esac
    shift
done
#!/bin/bash

mkdir /etc/dnsmasq;
URL=https://data.iana.org/TLD/tlds-alpha-by-domain.txt
test -f /etc/dnsmasq/block.wpad.txt && rm /etc/dnsmasq/block.wpad.txt
for DOM in `wget -q $URL -O- |grep -v "#"`; do
echo "server=/wpad.${DOM}/" >> /etc/dnsmasq/block.wpad.txt
done

# add to dnsmasq.conf:
servers-file=/etc/dnsmasq/block.wpad.txt
#!/bin/bash

if [ -n "$(command -v apt-get | wc -l)" != "1" ]
then
	echo "Please use Debian based system"
	exit 1
fi
#!/bin/bash

if readlink /proc/$$/exe | grep -qs "dash"; then
	echo "This script needs to be run with bash, not sh"
	exit 1
fi
#!/bin/bash

echo "Checking bash version."
version=$(bash --version | grep 'GNU bash' | sed 's/.*version \([0-9]*\)\..*/\1/')
if [ "$version" = "4" ]; then
    echo "Bash version compatible."
  else
    echo "Bash version incompatible. Must be at least 4, yours is $version. You can enter this command in the terminal: apt-get install --only-upgrade bash"
    exit 1
fi
#!/bin/bash

if [ ! -f /etc/redhat-release ]; then
  echo "Only supports Centos"
  exit 1
fi
#!/bin/bash

if [ "$os_type" = "Debian" ]; then
  os_ver="$(sed 's/\..*//' /etc/debian_version 2>/dev/null)"
  if [ "$os_ver" != "8" ]; then
    echoerr "Only supports Debian 8 (Jessie)"
    exit 1
  fi
fi
#!/bin/bash

os_type="$(lsb_release -si 2>/dev/null)"
if [ "$os_type" != "Ubuntu" ] && [ "$os_type" != "Debian" ] && [ "$os_type" != "Raspbian" ]; then
  exiterr "This script only supports Ubuntu/Debian."
fi
#!/bin/bash

echo "Please enter valid hostname:"
echo ""
read HOSTNAME

FQDN_REGEX='^(([a-zA-Z](-?[a-zA-Z0-9])*)\.)*[a-zA-Z](-?[a-zA-Z0-9])+\.[a-zA-Z]{2,}$'
if ! printf %s "$HOSTNAME" | grep -Eq "$FQDN_REGEX"; then
  echoerr "Invalid parameter. You must enter a FQDN domain name... exp: blog.mertcangokgoz.com"
  exit 1
fi
#!/bin/bash

MY_IP_ADDR=$(curl -s http://myip.enix.org/REMOTE_ADDR)
[ "$MY_IP_ADDR" ] || {
  echo "Sorry, I could not figure out my public IP address."
  echo "(I use http://myip.enix.org/REMOTE_ADDR/ for that purpose.)"
  exit 1
}
#!/bin/bash

phymem="$(free | awk '/^Mem:/{print $2}')"
[ -z "$phymem" ] && phymem=0
if [ "$phymem" -lt 1000000 ]; then
  echoerr "A minimum of 1024 MB RAM is required."
  exit 1
fi
#!/bin/sh

dpkg -l openvpn > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    die "❯❯❯ OpenVPN is already installed."
fi
#!/bin/bash

if [ -f /proc/user_beancounters ]; then
  echo "Error: This script does not support OpenVZ VPS." >&2
  exit 1
fi
#!/bin/bash

if [ "$(id -u)" != 0 ]; then
  echoerr "This script must be run as root. 'sudo bash $0'"
  exit 1
fi
#!/bin/bash

if [[ ! -e /dev/net/tun ]]; then
	echo "TUN is not available"
	exit 3
fi
#!/bin/bash

os_type="$(lsb_release -si 2>/dev/null)"
if [ "$os_type" != "Ubuntu" ] && [ "$os_type" != "Debian" ]; then
  echoerr "Only supports Ubuntu/Debian"
  exit 1
fi

if [ "$os_type" = "Ubuntu" ]; then
  os_ver="$(lsb_release -sr)"
  if [ "$os_ver" != "16.04" ] && [ "$os_ver" != "14.04" ] && [ "$os_ver" != "12.04" ]; then
    echoerr "Only supports Ubuntu 12.04/14.04/16.04"
    exit 1
  fi
fi
#!/bin/bash

ok() {
    echo -e '\e[32m'$1'\e[m';
}

#exp
ok "❯❯❯ apt-get update"

die() {
    echo -e '\e[1;31m'$1'\e[m'; exit 1;
}

die "❯❯❯ apt-get update"
#!/bin/bash

set -e

YAZICILAR=`lpstat -p | grep printer | grep -v enable | awk '{print $2}' | sed '/^$/d'`
if [ "x$YAZICILAR" !=  "x" ]; then
  for yaziciadi in $YAZICILAR; do
    echo "Lutfen Bekleyin $yaziciadi Yazici Etkinlestiriliyor"
    cupsenable -h 127.0.0.1:631 $yaziciadi && logger "$yaziciadi Yazici Etkinlestirildi"
  done
fi
sleep 2
#!/bin/bash

echo "Welcome To Server DNS Creator"
echo "Enter the following configuration parameters of the DNS"
echo -n "Domain name: "; read -r domain
echo -n "Ip address for dns (127.0.0.1): "; read -r ip
echo -n "Ip address reverse zone (0.0.127) : "; read -r ipinv
echo -n "Address network (127.0.0.1/32): "; read -r addred
echo "Configuring DNS Please Wait..."
echo "

acl goodclients {
    $addred;
    localhost;
    localnets;
};

options {
	listen-on port 53 { 127.0.0.1; $ip;};
	listen-on-v6 port 53 { any; };
	directory 	\"/var/named\";
	dump-file 	\"/var/named/data/cache_dump.db\";
	statistics-file \"/var/named/data/named_stats.txt\";
	memstatistics-file \"/var/named/data/named_mem_stats.txt\";

	recursion yes;
	allow-query     { goodclients; };

	auth-nxdomain no;
	dnssec-enable yes;
	dnssec-validation yes;

	/* Path to ISC DLV key */
	bindkeys-file \"/etc/named.iscdlv.key\";

	managed-keys-directory \"/var/named/dynamic\";

	pid-file \"/run/named/named.pid\";
	session-keyfile \"/run/named/session.key\";
};

logging {
        channel default_debug {
                file \"data/named.run\";
                severity dynamic;
        };
};

zone \".\" IN {
	type hint;
	file \"named.ca\";
};

zone \"$domain\" IN {
	type master;
	file \"direct.${domain%.*}\";
	allow-update {none;};
};

zone \"$ipinv.in-addr.arpa\" IN {
	type master;
	file \"reverse.${domain%.*}\";
	allow-update {none;};
};

include \"/etc/named.rfc1912.zones\";
include \"/etc/named.root.key\";
" > /etc/named.conf
echo "[PASS]"
echo "Configuring zones"
echo -n "IP for pgsql.$domain: "; read -r ip1
echo -n "IP for aulavirtual.$domain: "; read -r ip2
echo -n "IP for mariadb.$domain: "; read -r ip3
echo -n "IP for system.$domain: "; read -r ip4
echo "\$TTL 86400
@ IN SOA www.$domain. root.$domain. (
 2009091001
 28800
 7200
 604800
 86400
 )
@ IN NS www.$domain.
@ IN A $ip
@ IN A $ip1
@ IN A $ip2
@ IN A $ip3
@ IN A $ip4
www IN A $ip
pgsql IN A $ip1
aulavirtual IN A $ip2
mariadb IN A $ip3
system IN A $ip4
" >  "/var/named/direct.${domain%.*}"
echo "\$TTL 86400
@ IN SOA www.$domain. root.$domain. (
 2009091001
 28800
 7200
 604800
 86400
 )
@ IN NS www.$domain.
@ IN PTR $domain.
www IN A $ip
pgsql IN A $ip1
aulavirtual IN A $ip2
mariadb IN A $ip3
system IN A $ip4

${ip##*.} IN PTR www.$domain.
${ip1##*.} IN PTR pgsql.$domain.
${ip2##*.} IN PTR aulavitual.$domain.com.
${ip3##*.} IN PTR mariadb.$domain.
${ip4##*.} IN PTR system.$domain.
" > "/var/named/reverse.${domain%.*}"
echo "[PASS]"
echo "Restarting named"
systemctl restart named
named-checkconf /etc/named.conf
named-checkzone "$domain" /var/named/direct."${domain%.*}"
named-checkzone "$domain" /var/named/reverse."${domain%.*}"
echo -e "\n nameserver $ip" >> /etc/resolve.conf
echo "Restarting httpd"
systemctl restart httpd
echo "[PASS]"
echo "DNS Configuration finished"
echo "to add a new one, run the script again"
echo "sh dnsbuild.sh"
echo "Thanks"
#!/bin/bash

echo "Change DNS"
echo
#sh -c "echo nameserver 77.88.8.88 > /etc/resolv.conf"
#sh -c "echo nameserver 77.88.8.2 >> /etc/resolv.conf"
echo
echo
#echo "Done! Your resolv.conf file should look like this:"
echo
echo
cat /etc/resolv.conf
echo "Update and Upgrade"
echo
sh -c "apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade"
echo
echo "Done!"
# !/bin/bash
#
# Credit goes to this article for the instructions in this shell script:
#   http://blog.zwiegnet.com/linux-server/disable-selinux-centos-7/
#
# Script by: Michael Dichirico (https://github.com/mdichirico/public-shell-scripts)
#
# PLEASE READ:
#
# This script will completely disable SELinux.
#
# In order for the changes to take effect, you'll need to reboot your CentOS 7 server
# afterwards.
#
# INSTRUCTIONS:
# 1. Copy this shell script to your home directory
# 2. Make it executable by using the following command:
#    chmod a+x disable-selinux-on-cent-os-7.sh
# 3. Execute the script with the following command:
#    sudo ./disable-selinux-on-cent-os-7.sh
# 4. After the script finishes, reboot your server.
#
#

sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config
sudo sestatus

echo ""
echo "Finished with script execution!"
echo "In the above output, you'll see that the value of 'SELinux status' is 'enabled'."
echo "That is normal. Do the following two steps:"
echo " 1. reboot your environment: "
echo ""
echo "      sudo shutdown -r now"
echo ""
echo " 2. When you server comes back online, run this command:"
echo ""
echo "      sudo sestatus"
echo ""
echo "    You should then see 'SELinux status: disabled' to confirm that SELinux is in fact disabled"
echo ""#!/bin/bash

if [ "$?" = "1" ]
then
  echo "An unexpected error occured!"
  exit 0
fi
#!/bin/bash

clear

set -e

echo ""

echoerr() { echo "ERROR: ${1}" >&2; }

if [ "$(id -u)" != 0 ]; then
  echoerr "This script must be run as root. 'sudo bash $0'"
  exit 1
fi

os_type="$(lsb_release -si 2>/dev/null)"
if [ "$os_type" != "Ubuntu" ] && [ "$os_type" != "Debian" ]; then
  echoerr "Only supports Ubuntu/Debian"
  exit 1
fi

if [ "$os_type" = "Ubuntu" ]; then
  os_ver="$(lsb_release -sr)"
  if [ "$os_ver" != "16.04" ] && [ "$os_ver" != "14.04" ] && [ "$os_ver" != "12.04" ]; then
    echoerr "Only supports Ubuntu 12.04/14.04/16.04"
    exit 1
  fi
fi

if [ "$os_type" = "Debian" ]; then
  os_ver="$(sed 's/\..*//' /etc/debian_version 2>/dev/null)"
  if [ "$os_ver" != "8" ]; then
    echoerr "Only supports Debian 8 (Jessie)"
    exit 1
  fi
fi

phymem="$(free | awk '/^Mem:/{print $2}')"
[ -z "$phymem" ] && phymem=0
if [ "$phymem" -lt 1000000 ]; then
  echoerr "A minimum of 1024 MB RAM is required."
  exit 1
fi

echo "Please enter valid hostname:"
echo ""
read HOSTNAME

FQDN_REGEX='^(([a-zA-Z](-?[a-zA-Z0-9])*)\.)*[a-zA-Z](-?[a-zA-Z0-9])+\.[a-zA-Z]{2,}$'
if ! printf %s "$HOSTNAME" | grep -Eq "$FQDN_REGEX"; then
  echoerr "Invalid parameter. You must enter a FQDN domain name... exp: blog.mertcangokgoz.com"
  exit 1
fi

echo "System upgrade and install dependencies"
apt-get -y update
apt-get -y upgrade
apt-get install -y npm nodejs nodejs-legacy zip nginx
curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -

echo "Ghost download and configuring"
mkdir -p /var/www
cd /var/www/
curl -L -O https://ghost.org/zip/ghost-latest.zip
unzip -d ghost ghost-latest.zip
rm ghost-latest.zip
cd ghost/
sed -e "s/my-ghost-blog.com/$HOSTNAME/" <config.example.js > config.js
npm install -g grunt-cli
npm install --production

echo "configuring ghost user"
adduser --shell /bin/bash --gecos 'Ghost application' ghost --disabled-password
echo ghost:ghost | chpasswd
chown -R ghost:ghost /var/www/ghost/

echo "configuring nginx"
touch /etc/nginx/sites-available/ghost
echo "server {" >> /etc/nginx/sites-available/ghost
echo "    listen 80;" >> /etc/nginx/sites-available/ghost
echo "    server_name $HOSTNAME;" >> /etc/nginx/sites-available/ghost
echo "    location / {" >> /etc/nginx/sites-available/ghost
echo "        proxy_set_header   X-Real-IP \$remote_addr;" >> /etc/nginx/sites-available/ghost
echo "        proxy_set_header   Host      \$http_host;" >> /etc/nginx/sites-available/ghost
echo "        proxy_pass         http://127.0.0.1:2368;" >> /etc/nginx/sites-available/ghost
echo "        }" >> /etc/nginx/sites-available/ghost
echo "    }" >> /etc/nginx/sites-available/ghost

ln -s /etc/nginx/sites-available/ghost /etc/nginx/sites-enabled/ghost

echo "remove default profile and restart nginx"
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default
service nginx restart

echo "install PM2"
echo "#!/bin/bash" >> /home/ghost/start.sh
echo "export NODE_ENV=production" >> /home/ghost/start.sh
echo "cd /var/www/ghost/" >> /home/ghost/start.sh
echo "npm start --production" >> /home/ghost/start.sh
chmod +x /home/ghost/start.sh
npm install pm2 -g

echo "configuring PM2"
su -c "echo 'export NODE_ENV=production' >> ~/.profile" -s /bin/bash ghost
su -c "source ~/.profile" -s /bin/bash ghost
su -c "/usr/local/bin/pm2 kill" -s /bin/bash ghost
su -c "env /usr/local/bin/pm2 start /home/ghost/start.sh --interpreter=bash --name ghost" -s /bin/bash ghost
env PATH=$PATH:/usr/bin pm2 startup ubuntu -u ghost --hp /home/ghost
su -c "pm2 save" -s /bin/bash ghost

echo "Ghost CMS Started"
#!/bin/bash

convert "$1" -trim \( +clone -background grey45 -shadow 80x40+5+10 \) +swap -background transparent -layers merge +repage "$1-s.png"
#! /bin/bash

#Check root
if [ $(id -u) != "0" ];
then
	echo "Needs to be run by a user with root privilege."
	exit 1
fi

# Check debian packages manager
if [ -n "$(command -v apt-get | wc -l)" != "1" ]
then
	echo "Please use Debian based system"
	exit 1
fi

# Check to see if Spotify repository
echo "  Checking /etc/apt/sources.list for repository."
ssource=`grep -o -E "deb http://repository.spotify.com stable non-free" /etc/apt/sources.list | wc -l`
if [ $ssource -eq 0 ]; then
	echo '' | sudo tee -a /etc/apt/sources.list.d/spotify.list
	echo '## SPOTIFY-CLIENT' | sudo tee -a /etc/apt/sources.list.d/spotify.list
	echo 'deb http://repository.spotify.com stable non-free' | sudo tee -a /etc/apt/sources.list.d/spotify.list
else
	echo "  Skipping addition to /etc/apt/sources.list.d/sources.list."
fi

# Verify downloaded packages
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886

# Run apt-get update
sudo apt-get update

# Install spotify!
sudo apt-get install spotify-client

echo "  Done. Add Spotify to your system"
echo "  Press any key to continue."
read
#!/bin/bash
#
# PALI : The Perfect Automatic Lamp Installer
# Version : 2.3 (stable for use in Production)
# Author : Christophe Casalegno / Brain 0verride
# Website : http://www.christophe-casalegno.com
# Twitter : https://twitter.com/Brain0verride
# Email : brain@christophe-casalegno.com
# Note : Only tested on Debian 9


# Vars
RED='\033[38;5;160m' #ex echo -e "${RED} ALERT"
NC='\033[0m'	 	 #ex echo -e "${NC} Normal"
GREEN='\033[0;32m' 	 #ex echo -e "${GREEN} OK"
YELLOW='\033[38;5;226m' #ex echo -e "${YELLOW} Warning"
admin_mail='pali@christophe-casalegno.com' 	# Put your admin email here
installer='apt' 			# installer (apt-get, yum, urpmi, zypper, etc.)
installer_options='-y -f install' 	# options for the installer1
replacer='sed' 				# command used for replacement 
replacer_options='-i' 			# options for the replacer
sources_list='/etc/apt/sources.list'
myhost=$(hostname -f |cut -d " " -f1)
export HOSTNAME2=$myhost
ip=$(hostname -I |cut -d " " -f1)
auto='debconf-set-selections'
iptablesfix='/etc/network/if-pre-up.d/iptables'
firewall_conf='/etc/iptables.rules'
sshd_conf='/etc/ssh/sshd_config'
vhosts_conf='/etc/apache2/sites-available'
event_conf='/etc/apache2/mods-available/mpm_event.conf'
apache_conf='/etc/apache2/apache2.conf'
fpm_conf='/etc/php/7.0/fpm/pool.d'
php_conf='/etc/php/7.0/fpm/php.ini'
phpcli_conf='/etc/php/7.0/cli/php.ini'
phpmyadmin_conf='/etc/phpmyadmin/apache.conf'
mysql_conf='/etc/mysql/my.cnf'
munin_conf='/etc/munin/apache24.conf'
munin_master_conf='/etc/munin/munin.conf'
munin_node_conf='/etc/munin/munin-node.conf'
munin_orig='/usr/share/munin/plugins'
munin_dest='/etc/munin/plugins'
rkhunter_conf='/etc/default/rkhunter'
fail2ban_conf='/etc/fail2ban/jail.conf'
webmin_conf='/etc/webmin/miniserv.conf'
webmin_port='10000'
ssh_port='22'
nodejs_version='7'
tmpcron='/root/tmpcron.txt'
need_packages='pwgen'
conf_locale=$(set |grep LANG |cut -d "=" -f2)
options_found=0
letsencrypt=0
memory=$(free | awk 'FNR == 3 {print $4}' |awk '{ byte = $1 /1024/1024 ; byte =$1 /1024/2 ; print byte}' |cut -d "." -f1)

# UID verification

if [ "$UID" -ne "0" ]

then
        echo -e "${RED} [ ERROR ]" "${NC} you must be root to install the server"
        exit 0

else
        echo -e "${GREEN} [ OK ]" "${NC} UID ok, install in progress..."

fi



while getopts ":a:n:s:w:j:l:h" opt 
do

		options_found=1

		case $opt in
 
			a) 
				admin_mail="$OPTARG"  
				;;
			n) 
				myhost="$OPTARG"
				;;
			s) 
				ssh_port="$OPTARG"
				;;
			w) 
				webmin_port="$OPTARG"
				;;
			j)	
				nodejs_version="$OPTARG"
				;;
      l)
        letsencrypt="$OPTARG"
        ;;
			h) 
				echo './pali.sh -a your@email -n yourhostname (xxx.domain.tld) -s newssh_port -w newwebmin_port -j nodejs_version (6, 7 or 8) -l (1 for letsencrypt)'
				exit 1
				;;
			\?) 
				echo -e "${RED} [ ERROR ]" "${NC} Invalid option: -$OPTARG" >&2
				exit 1
				;;
			:) 
				echo -e "${YELLOW} [ WARNING ]" "Option -$OPTARG requires an argument." >&2
				exit 1
				;;

		esac
done



if [ "$options_found" -ne '1' ]

then

	echo -e "${YELLOW} [ WARNING ]" "${NC} no options found, defaults parameters will be used"

fi

#Verification if server was already installed

if [ -r "/root/$myhost.installed" ]

then

        echo -e "${RED} [ ERROR ]" "${NC} server $myhost was already installed !!!"
        exit 0

else
        echo -e "${GREEN} [ OK ]" "${NC} server has not been installed before, install in progress..."

fi


# Emails verifications

if [ "$admin_mail" = 'pali@christophe-casalegno.com' ]

then
	echo -e "${RED} [ ERROR ]" "${NC} admin email address has not been setuped, please setup it or use -a option"
	exit 0

else 
	echo -e "${GREEN} [ OK ]" "${NC} admin email ok, install in progress..."

fi

# Hostname verification

if [ "$myhost" != "$HOSTNAME2" ]

then
	echo -e "${YELLOW} [WARNING]" "${NC} Hostname doesn't match the actual server host, changing server hostname in progress..."
	oldhost=$(grep "$ip" /etc/hosts)
	cuthost=$(echo "$myhost" |cut -d "." -f1)
	newhost="$ip $myhost $cuthost"
  $replacer $replacer_options "s#$oldhost#$newhost#" /etc/hosts
	$replacer $replacer_options "s#$HOSTNAME#$cuthost#" /etc/hostname
	$replacer $replacer_options "s#root@$HOSTNAME#root@$cuthost#" /etc/ssh/*.pub
	hostname "$cuthost"
	hostnamectl set-hostname "$cuthost"
else

echo -e "${GREEN} [ OK ]" "${NC} hostname ok, install in progress..."

fi

# Fix warning: Falling back to a fallback locale issue
echo LC_ALL="$conf_locale" > /etc/environment
export_locale=$(grep LC_ALL /etc/environment)
export $export_locale

# Added sources
{
  echo '# Added by PALI' 
  echo '' 
  echo 'deb http://mirrors.linode.com/debian/ stretch main contrib non-free'
  echo 'deb-src http://mirrors.linode.com/debian/ stretch main contrib non-free'
  echo ''
  echo 'deb http://security.debian.org/ stretch/updates contrib non-free' 
  echo 'deb-src http://security.debian.org/ stretch/updates non-free' 
  echo ''
  echo 'deb http://mirrors.linode.com/debian/ stretch-updates main contrib non-free'
  echo 'deb-src http://mirrors.linode.com/debian/ stretch-updates main contrib non-free'
} >> $sources_list 

echo 'deb http://ftp.debian.org/debian stretch-backports main' | tee /etc/apt/sources.list.d/backports.list

$installer update
$installer -y upgrade

$installer $installer_options $need_packages

tld=$(pwgen -A -B 2 1)
usr=$(echo "$myhost" |sed 's/\.//g'|cut -b 1-14)
sysuser="$usr$tld"
genroot_pass=$(pwgen -A -B 12 1)
root_pass="$genroot_pass"

gensysuser_pass=$(pwgen -A -B 12 1)
sysuser_pass="$gensysuser_pass"

genmysqlroot_pass=$(pwgen -A -B 12 1)
mysqlroot_pass="$genmysqlroot_pass"

genmysql_pass=$(pwgen -A -B 12 1)
mysql_pass="$genmysql_pass"

genphpmyadmin_pass=$(pwgen -A -B 8 1)
phpmyadmin_pass="$genphpmyadmin_pass"

packages='libwww-perl ntpdate apt-transport-https python-certbot-apache man vim emacs iotop htop mc libapache2-mod-fcgid apache2 apache2-doc imagemagick php7.0 php7.0-zip php7.0-ssh2 php7.0-common php7.0-cli php7.0-mysqlnd php7.0-pgsql  php-apcu php7.0-curl php7.0-gd php7.0-intl php-imagick php7.0-imap php7.0-mcrypt php-memcache php-memcached php7.0-pspell php7.0-recode php7.0-sqlite3 php7.0-tidy php7.0-xmlrpc php7.0-xsl php-soap php7.0-mbstring php7.0-common php7.0-fpm mysql-server mysql-client phpmyadmin munin munin-node postfix libapache2-mod-php7.0 mailutils memcached git rsync pure-ftpd ftp curl strace python-setuptools python-dev gcc librsync-dev librsync1 python-cffi python-crypto python-cryptography python-ecdsa python-jwt python-lockfile python-ndg-httpsclient python-oauthlib python-openssl python-paramiko python-pkg-resources python-ply python-pyasn1 python-pycparser python-six python-urllib3 rkhunter chkrootkit fail2ban screen' # packages to be installed (you can modify for your needs) 

backport_packages=''

# Automation

# Mysql Server
$auto <<< "mysql-server mysql-server/root_password password $mysqlroot_pass"
$auto <<< "mysql-server mysql-server/root_password_again password $mysqlroot_pass"

# Postfix
$auto <<< "postfix postfix/mailname string $myhost"
$auto <<< "postfix postfix/main_mailer_type string 'Internet Site'"

# Phpmyadmin
$auto <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
$auto <<< "phpmyadmin phpmyadmin/app-password-confirm password $phpmyadmin_pass"
$auto <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $mysqlroot_pass"
$auto <<< "phpmyadmin phpmyadmin/mysql/app-pass password $phpmyadmin_pass"
$auto <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"


# Content for file or other stuff 

content_firewall="
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT DROP [0:0]
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -p tcp -m tcp --dport $ssh_port -j ACCEPT
-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
-A INPUT -p tcp -m tcp --dport $webmin_port -j ACCEPT
-A INPUT -p tcp --dport 20 -j ACCEPT
-A INPUT -p tcp --dport 21 -j ACCEPT
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A OUTPUT -o lo -j ACCEPT
-A OUTPUT -p icmp -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 53 -j ACCEPT
-A OUTPUT -p udp -m udp --dport 53 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 22 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 123 -j ACCEPT
-A OUTPUT -p udp -m udp --sport 123 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 443 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 25 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 22 -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 65022 -j ACCEPT
COMMIT
"

content_munin='
Alias /munin /var/cache/munin/www
<Directory /var/cache/munin/www>
AuthUserfile /etc/munin/munin-htpasswd
AuthName "Munin Access"
AuthType Basic
Require valid-user
Options None
</Directory>

ScriptAlias /munin-cgi/munin-cgi-graph /usr/lib/munin/cgi/munin-cgi-graph
<Location /munin-cgi/munin-cgi-graph>
AuthUserfile /etc/munin/munin-htpasswd
AuthName "Munin Access"
AuthType Basic
Require valid-user

<IfModule mod_fcgid.c>
            SetHandler fcgid-script
        </IfModule>
        <IfModule !mod_fcgid.c>
            SetHandler cgi-script
        </IfModule>
</Location>
'


content_fail2ban="
[INCLUDES]
before = paths-debian.conf

[DEFAULT]

ignoreip = 127.0.0.1/8
ignorecommand =
bantime  = 600
findtime = 600
maxretry = 3
backend = auto
enabled = false
usedns = warn
logencoding = auto
filter = %(__name__)s
destemail = $admin_mail
sendername = Fail2Ban $myhost
sender = fail2ban@$myhost
mta = sendmail
protocol = tcp
chain = INPUT
port = 1:65535
fail2ban_agent = Fail2Ban/%(fail2ban_version)s
banaction = iptables-multiport
banaction_allports = iptables-allports
action_ = %(banaction)s[name=%(__name__)s, port=\"%(port)s\", protocol=\"%(protocol)s\", chain=\"%(chain)s\"]
action_mw = %(banaction)s[name=%(__name__)s, port=\"%(port)s\", protocol=\"%(protocol)s\", chain=\"%(chain)s\"]
              %(mta)s-whois[name=%(__name__)s, dest=\"%(destemail)s\", protocol=\"%(protocol)s\", chain=\"%(chain)s\", sendername=\"%(sendername)s\"]
action_mwl = %(banaction)s[name=%(__name__)s, port=\"%(port)s\", protocol=\"%(protocol)s\", chain=\"%(chain)s\"]
               %(mta)s-whois-lines[name=%(__name__)s, dest=\"%(destemail)s\", logpath=%(logpath)s, chain=\"%(chain)s\", sendername=\"%(sendername)s\"]
action = %(action_)s

[ssh]

enabled  = true
port     = $ssh_port
filter   = sshd
logpath  = /var/log/auth.log
maxretry = 6

[ssh-ddos]

enabled  = false
port     = $ssh_port
filter   = sshd-ddos
logpath  = /var/log/auth.log
maxretry = 6

[apache]

enabled  = true
port     = http,https
filter   = apache-auth
logpath  = /var/log/apache2/*error.log
maxretry = 6

[apache-multiport]

enabled   = true
port      = http,https
filter    = apache-auth
logpath   = /var/log/apache2/*error.log
maxretry  = 6

[apache-noscript]

enabled  = true
port     = http,https
filter   = apache-noscript
logpath  = /var/log/apache2/*error.log
maxretry = 6

[apache-overflows]

enabled  = true
port     = http,https
filter   = apache-overflows
logpath  = /var/log/apache2/*error.log
maxretry = 2

[apache-modsecurity]

enabled  = false
filter   = apache-modsecurity
port     = http,https
logpath  = /var/log/apache*/*error.log
maxretry = 2

[apache-nohome]

enabled  = false
filter   = apache-nohome
port     = http,https
logpath  = /var/log/apache*/*error.log
maxretry = 2

[pure-ftpd]

enabled  = true
port     = ftp,ftp-data,ftps,ftps-data
filter   = pure-ftpd
logpath  = /var/log/syslog
maxretry = 6

[postfix]

enabled  = false
port     = smtp,ssmtp,submission
filter   = postfix
logpath  = /var/log/mail.log

[recidive]

enabled  = false
filter   = recidive
logpath  = /var/log/fail2ban.log
action   = iptables-allports[name=recidive]
           sendmail-whois-lines[name=recidive, logpath=/var/log/fail2ban.log]
bantime  = 604800  ; 1 week
findtime = 86400   ; 1 day
maxretry = 5

[ssh-blocklist]

enabled  = false
filter   = sshd
action   = iptables[name=SSH, port=ssh, protocol=tcp]
           sendmail-whois[name=SSH, dest=\"%(destemail)s\", sender=\"%(sender)s\", sendername=\"%(sendername)s\"]
           blocklist_de[email=\"%(sender)s\", apikey=\"xxxxxx\", service=\"%(filter)s\"]
logpath  = /var/log/sshd.log
maxretry = 20
"

content_cron='
0 1 * * * /usr/sbin/ntpdate fr.pool.ntp.org
'

content_event='
<IfModule mpm_event_module>
  ServerLimit         256
  StartServers        50
  MaxClients          1024
  MinSpareThreads     50
  MaxSpareThreads     150
  ThreadsPerChild     40
  MaxRequestsPerChild 0
</IfModule>
'

content_firstvhost="
<VirtualHost $ip:80>
ServerAdmin webmaster@$myhost
DocumentRoot /home/$sysuser/www
ServerName $myhost
CustomLog /var/log/apache2/$myhost.log combined
ErrorLog /var/log/apache2/$myhost-error.log
ScriptAlias /cgi-bin/ /home/$sysuser/cgi-bin/

<FilesMatch \.php$>
SetHandler \"proxy:unix:/run/php/$myhost.sock|fcgi://localhost/\"
</FilesMatch>

        <Directory /home/$sysuser>
                Options -Indexes +FollowSymLinks +MultiViews
                AllowOverride All
                Order allow,deny
                allow from all
                Require all granted
        </Directory>

</VirtualHost>
"
if [ "$letsencrypt" = "1" ]

then

content_secondvhost="
<VirtualHost $ip:443>
ServerAdmin webmaster@$myhost
DocumentRoot /home/$sysuser/www
ServerName $myhost
CustomLog /var/log/apache2/$myhost.log combined
ErrorLog /var/log/apache2/$myhost-error.log
ScriptAlias /cgi-bin/ /home/$myhost/cgi-bin/

<FilesMatch \.php$>
SetHandler \"proxy:unix:/run/php/$myhost.sock|fcgi://localhost/\"
</FilesMatch>

        <Directory /home/$sysuser>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Order allow,deny
                allow from all
                Require all granted
        </Directory>

SSLCertificateFile /etc/letsencrypt/live/$myhost/fullchain.pem
SSLCertificateKeyFile /etc/letsencrypt/live/$myhost/privkey.pem
Include /etc/letsencrypt/options-ssl-apache.conf

</VirtualHost>
"

fi

content_fpm_www="
[www]

user = www-data
group = www-data

listen = /run/php/www.sock
listen.backlog = -1
listen.allowed_clients = 127.0.0.1

listen.owner = www-data
listen.group = www-data
listen.mode = 0660

pm = dynamic
pm.max_children = 15
pm.start_servers = 6
pm.min_spare_servers = 3
pm.max_spare_servers = 9
pm.max_requests = 0

request_terminate_timeout = 0
request_slowlog_timeout = 0
 
slowlog = /var/log/php-fpm/www-slow.log
chdir = /
catch_workers_output = no
"

content_fpm="
[$myhost]

listen = /run/php/$myhost.sock

listen.backlog = -1
 
listen.allowed_clients = 127.0.0.1

listen.owner = $sysuser
listen.group = www-data
listen.mode = 0660

user = $sysuser
group = users

pm = dynamic
pm.max_children = 150
pm.start_servers = 25
pm.min_spare_servers = 25
pm.max_spare_servers = 75
pm.max_requests = 0

pm.status_path = /phpfpm-status-$myhost
ping.path = /phpfpm-ping-$myhost
ping.response = pong
 
request_terminate_timeout = 0
request_slowlog_timeout = 0
 
slowlog = /var/log/php-fpm/$myhost-slow.log
chdir = /
catch_workers_output = no
"

content_mycnf='
[client]
port            = 3306
socket          = /var/run/mysqld/mysqld.sock

[mysqld_safe]
socket          = /var/run/mysqld/mysqld.sock
nice            = 0

[mysqld]
user            = mysql
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
port            = 3306
basedir         = /usr
datadir         = /var/lib/mysql
tmpdir          = /tmp
lc-messages-dir = /usr/share/mysql
skip-external-locking
bind-address            = *
key_buffer_size         = 256M
max_allowed_packet      = 64M
thread_stack            = 192K
thread_cache_size       = 256
myisam-recover         = BACKUP
query_cache_limit       = 1M
query_cache_size        = 128M
max_connections         = 128
connect_timeout         = 10
wait_timeout            = 600
table_cache = 4096
table_open_cache = 4096
table_definition_cache = 4096
max_heap_table_size = 512M
sort_buffer_size        = 32M
bulk_insert_buffer_size = 16M
tmp_table_size          = 512M


log_error = /var/log/mysql/error.log
expire_logs_days        = 10
max_binlog_size         = 100M

innodb_buffer_pool_size = 2048M
innodb_log_buffer_size  = 16M
innodb_file_per_table   = 1
innodb_open_files       = 400
innodb_io_capacity      = 400
innodb_read_io_threads=64
innodb_write_io_threads=64
innodb_thread_concurrency=16
innodb_flush_method     = O_DIRECT
innodb_flush_log_at_trx_commit=2

[mysqldump]
quick
quote-names
max_allowed_packet      = 16M

[mysql]

[isamchk]
key_buffer_size         = 16M

!includedir /etc/mysql/conf.d/
'

content_genmysql="
CREATE USER '$sysuser'@'localhost' IDENTIFIED BY '$mysql_pass';
CREATE DATABASE IF NOT EXISTS \`"$sysuser"\` ;
GRANT ALL PRIVILEGES ON \`"$sysuser"\`.* TO '$sysuser'@'localhost';
FLUSH PRIVILEGES;
"

content_rootmysql="
UPDATE user set password=PASSWORD('$mysqlroot_pass') where User='root';
FLUSH PRIVILEGES;
"

echo "Making skel..."

mkdir /etc/skel/www
mkdir /etc/skel/cgi-bin
mkdir /etc/skel/protected
mkdir /root/mails
mkdir /root/sites
useradd "$sysuser" --shell /bin/bash -g users -m -d /home/"$sysuser" 
echo -e "$sysuser_pass\n$sysuser_pass" |passwd "$sysuser"


# SSH Configuration

echo "sshd configuration"
mkdir /root/.ssh
chmod 700 /root/.ssh
cd /root/.ssh

$replacer $replacer_options "s/#Port 22/Port 22/" $sshd_conf
$replacer $replacer_options "s#Port 22#Port $ssh_port#" $sshd_conf
$replacer $replacer_options "s/#PermitRootLogin/PermitRootLogin/" $sshd_conf 
$replacer $replacer_options "s#PermitRootLogin prohibit-password#PermitRootLogin yes#" $sshd_conf
cd /root

# Packages installation
echo "Installing packages : $packages..."
$installer $installer_options $packages
$installer $installer_options $backport_packages -t stretch-backports

# Composer Installation
echo "Installing composer..."
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# NodeJs Installation
echo "Installing NodeJS..."
curl -sL https://deb.nodesource.com/setup_"$nodejs_version".x | bash -
$installer $installer_options nodejs
$installer $installer_options build-essential

# Grunt installation
echo "Installing grunt..."
npm install -g grunt-cli

# Drush 8.x installation
echo "Installing drush..."
php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > /usr/bin/drush
chmod +x /usr/bin/drush

# Wp-cli installation
echo "Installing wp-cli"
curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -L -o /usr/bin/wp
chmod +x /usr/bin/wp

# Drupal console installation
curl https://drupalconsole.com/installer -L -o drupal.phar
mv drupal.phar /usr/bin/drupal
chmod +x /usr/bin/drupal 

# Fix mandb bug
mandb

# Rkhunter configuration

$replacer $replacer_options "s#root#$admin_mail#" $rkhunter_conf
$replacer $replacer_options "s#APT_AUTOGEN=\"false\"#APT_AUTOGEN=\"true\"#g" $rkhunter_conf


# Fail2ban configuration

cat >$fail2ban_conf <<EOF
$content_fail2ban
EOF

# Modules activation
echo "Activating modules"
a2enmod userdir 
a2enmod rewrite
a2enmod ssl
a2enmod expires
a2enmod deflate
a2enmod headers
a2enmod actions
a2enmod proxy_fcgi setenvif
a2enconf php7.0-fpm

# Apache configuration

$replacer $replacer_options "s#Timeout 300#Timeout 30#" $apache_conf
$replacer $replacer_options "s#KeepAlive On#KeepAlive Off#" $apache_conf


cat >$event_conf <<EOF
$content_event
EOF

# Vhost configuration

cat >$vhosts_conf/"$myhost".conf <<EOF
$content_firstvhost
EOF

cat >$vhosts_conf/"$myhost".ssl.conf <<EOF
$content_secondvhost
EOF

# Vhost activation
a2ensite "$myhost.conf"

if [ "$letsencrypt" = "1" ]

  then
      a2ensite default-ssl.conf
      certbot -n --agree-tos --email "$admin_mail" --apache certonly --domains "$myhost"
      a2ensite "$myhost".ssl.conf 

  else
      echo "no SSL"
      
fi

# FPM pool configuration
cat  >$fpm_conf/"$myhost".conf <<EOF
$content_fpm
EOF

cat >$fpm_conf/www.conf <<EOF
$content_fpm_www
EOF


# Mysql Creation
echo >/root/root.sql
cat >/root/root.sql <<EOF
$content_rootmysql
EOF

mysql -u root --database=mysql < /root/root.sql

echo >/root/sql.sql
cat >/root/sql.sql <<EOF
$content_genmysql
EOF

mysql -u root -p"$mysqlroot_pass" < /root/sql.sql

# Php configuration

#fpm

$replacer $replacer_options "s#memory_limit = 128M#memory_limit = 512M#" $php_conf
$replacer $replacer_options "s#;upload_tmp_dir =#upload_tmp_dir =/tmp#" $php_conf
$replacer $replacer_options "s#upload_max_filesize = 2M#upload_max_filesize = 128M#" $php_conf
$replacer $replacer_options "s#post_max_size = 8M#post_max_size = 128M#" $php_conf
$replacer $replacer_options "s#max_file_uploads = 20#max_file_uploads = 128#" $php_conf
$replacer $replacer_options "s#max_execution_time = 30#max_execution_time = 600#" $php_conf
$replacer $replacer_options "s#max_input_time = 60#max_input_time = 600#" $php_conf
$replacer $replacer_options "s#; max_input_vars = 100#max_input_vars = 100000#" $php_conf

#cli

$replacer $replacer_options "s#memory_limit = 128M#memory_limit = 512M#" $phpcli_conf
$replacer $replacer_options "s#;upload_tmp_dir =#upload_tmp_dir =/tmp#" $phpcli_conf
$replacer $replacer_options "s#upload_max_filesize = 2M#upload_max_filesize = 128M#" $phpcli_conf
$replacer $replacer_options "s#post_max_size = 8M#post_max_size = 128M#" $phpcli_conf
$replacer $replacer_options "s#max_file_uploads = 20#max_file_uploads = 128#" $phpcli_conf
$replacer $replacer_options "s#max_execution_time = 30#max_execution_time = 600#" $phpcli_conf
$replacer $replacer_options "s#max_input_time = 60#max_input_time = 600#" $phpcli_conf
$replacer $replacer_options "s#; max_input_vars = 100#max_input_vars = 100000#" $phpcli_conf
$replacer $replacer_options "s#session.save_handler = files#session.save_handler = memcached#" $phpcli_conf
$replacer $replacer_options "s#;session.save_path = \"/var/lib/php7.0/sessions\"#session.save_path = \"localhost:11211\"#" $phpcli_conf

# Pure-ftpd configuration
$replacer $replacer_options "s#no#yes#" /etc/pure-ftpd/auth/65unix
$replacer $replacer_options "s#yes#no#" /etc/pure-ftpd/auth/70pam
$replacer $replacer_options "s#no#yes#" /etc/pure-ftpd/conf/UnixAuthentication
$replacer $replacer_options "s#yes#no#" /etc/pure-ftpd/conf/PAMAuthentication
$replacer $replacer_options "s#1000#33#" /etc/pure-ftpd/conf/MinUID

# Pure-ftpd : no TLS for the moment (firewall issue)
echo 0 > /etc/pure-ftpd/conf/TLS 
openssl req -x509 -nodes -days 3650 -newkey rsa:4096 -sha256 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem -subj "/C=IE/ST=Co. Mayo/L=PALI/O=PALI/CN=$myhost"

touch /etc/pure-ftpd/conf/ChrootEveryone
echo "yes" > /etc/pure-ftpd/conf/ChrootEveryone
echo "ip_conntrack_ftp" >> /etc/modules
modprobe ip_conntrack_ftp

#Munin configuration 

cat >$munin_conf <<EOF
$content_munin
EOF

$replacer $replacer_options "s/#host_name localhost.localdomain/host_name $myhost/" $munin_node_conf
$replacer $replacer_options "s#localhost.localdomain#$myhost#" $munin_master_conf

ln -s $munin_orig/mysql_ $munin_dest/mysql_
ln -s $munin_orig/mysql_bytes $munin_dest/mysql_bytes
ln -s $munin_orig/mysql_innodb $munin_dest/mysql_innodb
ln -s $munin_orig/mysql_isam_space_ $munin_dest/mysql_isam_space_
ln -s $munin_orig/mysql_queries $munin_dest/mysql_queries
ln -s $munin_orig/mysql_slowqueries $munin_dest/mysql_slowqueries
ln -s $munin_orig/mysql_threads $munin_dest/mysql_threads
ln -s $munin_orig/postfix_mailstats $munin_dest/postfix_mailstats

htpasswd -b -c /etc/munin/munin-htpasswd "$sysuser" "$sysuser_pass" 

# Mysql configuration
cat >$mysql_conf <<EOF
$content_mycnf
EOF

# Phpmyadmin configuration
echo "
<FilesMatch \.php$>
SetHandler \"proxy:unix:/run/php/www.sock|fcgi://localhost/\"
</FilesMatch>
" >> $phpmyadmin_conf

cat /var/lib/phpmyadmin/blowfish_secret.inc.php  |grep cfg >> /etc/phpmyadmin/config.inc.php

$replacer $replacer_options "s#innodb_buffer_pool_size = 2048M#innodb_buffer_pool_size="$memory"M#" $mysql_conf

echo '<?php echo "test ok";?>' > /home/"$sysuser"/www/index.php
echo '<?php phpinfo();?>' > /home/"$sysuser"/www/phpinfo.php

# Fix perms
chown -R "$sysuser":users /home/"$sysuser"
chmod 705 /home/"$sysuser"

# Webmin installation

wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc
{
  echo '# Added by PALI' 
  echo ''
  echo 'deb http://download.webmin.com/download/repository sarge contrib'
  echo 'deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib' 
} >> $sources_list

$installer update
$installer $installer_options webmin
$replacer $replacer_options "s#10000#$webmin_port#" $webmin_conf

# Restart and activate everything needed

service apache2 restart
systemctl restart php7.0-fpm.service
service mysql restart
service ssh restart
service pure-ftpd restart
service webmin restart
service fail2ban restart

# Installation des cron

crontab -l > $tmpcron
cat>>$tmpcron <<EOF
$content_cron
EOF

crontab $tmpcron
rm -f $tmpcron

touch /root/"$myhost".installed

echo -e "$root_pass\n$root_pass" |passwd root

echo "$mysqlroot_pass" > /root/.mysqlpasswd

content_mail="
Your server has been correclty installed

Hostname : $myhost
IP address : $ip

ssh port : $ssh_port
Webmin : https://$myhost:$webmin_port

Phpmyadmin : http://$myhost/phpmyadmin

Munin : http://$myhost/munin

Credentials :
---------------------------------------
SSH : root : $root_pass
SSH/FTP : $sysuser : $sysuser_pass
MysqlRoot : $mysqlroot_pass

Mysql : 
login : $sysuser 
database : $sysuser 
password : $mysql_pass 
"

cat >/root/mails/installed.txt <<EOF
$content_mail
EOF

cat >/root/.p <<EOF
$content_mail
EOF

mail -s "[ $myhost ] installed" "$admin_mail" < /root/mails/installed.txt
cat /root/mails/installed.txt > /root/.p 

echo > /root/mails/installed.txt

cat >/root/sites/"$myhost".installed <<EOF
$content_mail
EOF

# Firewall configuration

cat >$firewall_conf <<EOF
$content_firewall
EOF

iptables-restore <$firewall_conf
iptables-save > /etc/iptables.up.rules

touch $iptablesfix
echo "#!/bin/sh" > $iptablesfix
echo "/sbin/iptables-restore < /etc/iptables.up.rules" >> $iptablesfix
chmod +x $iptablesfix 

iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT

exit 0

#!/bin/bash

latest=2.3.14
aptitude update && aptitude full-upgrade && aptitude install openvpn ca-certificates build-essential liblzo2-dev libssl-dev libpam0g-dev -y
wget https://swupdate.openvpn.net/community/releases/openvpn-$latest.tar.gz -O /usr/src/openvpn-$latest.tar.gz
cd /usr/src; tar xfvz openvpn-$latest.tar.gz && cd openvpn-$latest && ./configure && make && make install
sed -i 's/DAEMON=\/usr\/sbin\/openvpn/DAEMON=\/usr\/local\/sbin\/openvpn/g' /etc/init.d/openvpn
aptitude remove openvpn -y
which openvpn && openvpn --version | head -1

/etc/init.d/openvpn restart || /etc/init.d/openvpn start
#!/bin/bash

while true
do
  ./ph.py
  echo ">ph exited... restarting...";
  sleep 5;
done
#!/bin/bash

generateKey () {
  P1=`cat /dev/urandom | tr -cd abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789 | head -c 3`
  P2=`cat /dev/urandom | tr -cd abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789 | head -c 3`
  P3=`cat /dev/urandom | tr -cd abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789 | head -c 3`
  P4=`cat /dev/urandom | tr -cd abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789 | head -c 3`
  PSK="$P1$P2$P3$P4"
}
#!/bin/bash

for file in $(find -iname '*.CHK'); do C_EXT=$(file --mime-type $file | cut -d' ' -f2 | xargs -I {} grep {} /etc/mime.types | awk '{ print $2; }'); if [ -n "$C_EXT" ]; then rename -v "s/.CHK$/.$C_EXT/i" $file; fi; done
# !/bin/bash
# Samba Installer

if [ "$EUID" -ne 0 ]
  then echo "Please this app run as root. 'sudo $0'"
  exit
fi

apt install samba -y

hostname=`hostname`

cat > /etc/samba/smb.conf <<EOF
[global]
    workgroup = WORKGROUP
    #usershare allow guests = yes security=share security=user
    security = user
    guest account = nobody
    follow symlinks = yes
    wide links = no
    unix extensions = no
    lock directory = /var/cache/samba
    netbios name = $hostname
    follow symlinks = yes
    wide links = yes
    unix extensions = no
    log file = /dev/null
bind interfaces only = yes
#interfaces = eth0
#interfaces = 212.154.12.48 10.0.0.5
#encrypt passwords = no
#obey pam restrictions = yes
#pam password change = yes
#client plaintext auth = yes
#client ntlmv2 auth = no

[Root]
        comment = Root
        path = /
        read only = No
        #access based share enum = Yes
        browsable = yes
        valid user = root
EOF

pass=`< /dev/urandom tr -dc a-z | head -c${1:-5}`

echo "$pass
$pass" | smbpasswd -a root

service smbd restart
service nmbd restart

echo "Username : root
Password: $pass
"
#! /bin/bash

set -e

if [[ -z "$1" ]];
then
  echo "Please enter a website url"
  exit 1
else
  if [[ -z "$2" ]];
  then
    echo "Please enter a custom code"
    exit 1
  else
    echo "Please Wait..."
    curl -s -i https://git.io -F "url=$1" -F "code=$2" | awk '/Location/ {print $2}'
    fi
fi
#!/bin/bash

IPPFX=$1
for i in `seq 1 255` ; do LIST="$LIST ${IPPFX}.$i" ; done
for i in $LIST ; do
    ENTRY="`host $i`"
    [ $? -ne 0 ] && continue
    ENTRY=`echo "$ENTRY" l sed -e 's/.* //' -e 's/\.$//'`
    echo -e "$i\t$ENTRY"
done
#!/bin/sh

# Taken from http://samba.anu.edu.au/rsync/examples.html

# This script does personal backups.  You will end up with a 7 day 
# rotating incremental backup.  The incrementals will go into 
# subdirectories named after the day of the week, and the
# current full backup goes into a directory called "current".

# directory to backup
BDIR=$HOME

# excludes file - this contains a wildcard pattern per line of files
# to exclude
EXCLUDES=$HOME/local/etc/backup_exclude

# the backup location
BLOCATION=/Volumes/Storage/Backups

# set to the location of directory containing additional
# backup scripts to be run prior to backing up
SCRIPTS_DIR=$HOME/local/etc/backup.d

#######################################################

# run the backup scripts located in SCRIPTS_DIR
if [[ -d $SCRIPTS_DIR ]]
then
   for file in `ls $SCRIPTS_DIR`
   do
      $SCRIPTS_DIR/$file $BDIR 2> /dev/null > /dev/null
      if (( $? != 0 )) 
      then
         ERRCODE=$?
         echo execution of script $SCRIPTS_DIR/$file failed
         exit $?
      fi
   done
fi

# set some options for rsync
BACKUPDIR=`date +%A`
OPTS="--extended-attributes --force --ignore-errors --delete-excluded --exclude-from=$EXCLUDES
      --delete --times --backup --backup-dir=../$BACKUPDIR -a"

# the following line clears the last weeks incremental directory
[ -d $HOME/emptydir ] || mkdir $HOME/emptydir
rsync --delete -a $HOME/emptydir/ $BLOCATION/$USER/$BACKUPDIR/
rmdir $HOME/emptydir

# now the actual transfer
rsync $OPTS $BDIR $BLOCATION/$USER/current
#!/bin/bash

echo "A very simple utility to update a firewall with a dynamic IP address."
echo "Espcially useful when using a cron job."
echo -n "Hostname is $HOSTNAME";
HOSTNAME=mertcangokgoz.com
FIREWALL=iptables
IFACE=eth0
PROTO=tcp
PORT=22

LOGFILE=/var/dyn_firewall_${HOSTNAME}.ip

Current_IP=$(host $HOSTNAME | cut -f4 -d' ')

if [ ! -f $LOGFILE ] ; then
	case ${FIREWALL} in
	*)
	iptables*)
		iptables -I INPUT -i ${IFACE} -p ${PROTO} -s ${Current_IP} --dport ${PORT} -j ACCEPT
		;;

	ufw*)
		ufw allow in on ${IFACE} proto ${PROTO} from $Current_IP to any port ${PORT}
		;;
	esac

	echo ${Current_IP} > $LOGFILE
	echo "Firewall has been updated"
else
	Old_IP=$(cat $LOGFILE)

	if [ "$Current_IP" = "$Old_IP" ] ; then
		echo "IP address has not changed"
	else
		case ${FIREWALL} in
		*)
		iptables*)
			iptables -D INPUT -i ${IFACE} -p ${PROTO} -s ${Old_IP} --dport ${PORT} -j ACCEPT
			iptables -I INPUT -i ${IFACE} -p ${PROTO} -s ${Current_IP} --dport ${PORT} -j ACCEPT
			;;

		ufw*)
			ufw delete allow in on ${IFACE} proto ${PROTO} from ${Old_IP} to any port ${PORT}
			ufw allow in on ${IFACE} proto ${PROTO} from ${Current_IP} to any port ${PORT}
			;;
		esac

		echo $Current_IP > $LOGFILE
		echo "Firewall has been updated"
	fi
fi
#!/bin/sh
## You should also create a file from the directory where you run this script
## called torrc with inside the details of the torrc to use.

TMP_INSTALL_DIR=`mktemp -d`

yum_installs() {
  sudo yum -y groupinstall "Development tools" &&
  sudo yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel libffi-devel screen libeven-devel unzip tor
}

install_python() {
  cd $TMP_INSTALL_DIR;
  # Install Python 2.7.6
  curl -L -o Python-2.7.6.tgz https://www.python.org/ftp/python/2.7.6/Python-2.7.6.tgz &&
  tar xzf Python-2.7.6.tgz &&
  cd Python-2.7.6 &&
  ./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" &&
  make &&
  sudo make altinstall &&
  sudo ln -sf /usr/local/bin/python2.7 /usr/bin/python
}

install_libtool() {
  # Install the latest version of libtool
  curl -L -o libtool-2.4.2.tar.gz http://ftpmirror.gnu.org/libtool/libtool-2.4.2.tar.gz &&
  tar xzf libtool-2.4.2.tar.gz &&
  cd libtool-2.4.2 &&
  ./configure &&
  make &&
  sudo make install &&
  sudo mv /usr/bin/libtool /usr/bin/libtool.old &&
  sudo ln -s /usr/local/bin/libtool /usr/bin/libtool
}

install_autoconf() {
  # Install the latest version of autoconf
  curl -L -o autoconf-2.69.tar.gz http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz &&
  tar xzf autoconf-2.69.tar.gz &&
  cd autoconf-2.69 &&
  ./configure &&
  make && 
  sudo make install &&
  sudo mv /usr/bin/autoconf /usr/bin/autoconf.old &&
  sudo ln -s /usr/local/bin/autoconf /usr/bin/autoconf
}

install_automake(){
  # Install the latest version of automake
  curl -L -o automake-1.14.1.tar.gz http://ftp.gnu.org/gnu/automake/automake-1.14.1.tar.gz &&
  tar xzf automake-1.14.1.tar.gz &&
  cd automake-1.14.1 &&
  ./configure &&
  make &&
  sudo make install &&
  sudo mv /usr/bin/automake /usr/bin/automake.old &&
  sudo ln -s /usr/local/bin/automake /usr/bin/automake
}

install_libevent(){
  # Install latest version of libevent
  curl -L -o libevent-2.0.21-stable.tar.gz https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz &&
  tar xvzf libevent-2.0.21-stable.tar.gz &&
  cd libevent-2.0.21-stable &&
  ./autogen.sh &&
  ./configure &&
  cp /usr/bin/libtool libtool &&
  make &&
  sudo make install
}

install_gmp() {
  # Install GMP
  curl -L -o gmp-6.0.0a.tar.bz2 https://gmplib.org/download/gmp/gmp-6.0.0a.tar.bz2 &&
  tar xjpf gmp-6.0.0a.tar.bz2 &&
  cd gmp-6.0.0 &&
  export ABI=32 &&
  ./configure --enable-cxx &&
  make &&
  sudo make install
}

install_tor() {
  # Install the latest version of Tor
  curl -L -o tor.zip https://github.com/hellais/tor/archive/fix/fedora8.zip &&
  unzip tor.zip &&
  cd tor-fix-fedora8 &&
  ./autogen.sh &&
  ./configure --disable-asciidoc --with-libevent-dir=/usr/local/lib/ &&
  make &&
  sudo make install &&
  sudo mv /usr/bin/tor /usr/bin/tor.old &&
  sudo ln -s /usr/local/bin/tor /usr/bin/tor &&
  echo "SocksPort 9050" > torrc &&
  sudo mv torrc /usr/local/etc/tor/torrc &&
  cat <<EOF > tor.init
  RETVAL=0
  prog="tor"

  # Source function library.
  . /etc/init.d/functions


  start() {
    echo -n $"Starting \$prog: "
    daemon \$prog --runasdaemon 1 && success || failure
    RETVAL=\$?
    echo
    return \$RETVAL
  }

  stop() {
    echo -n $"Stopping \$prog: "
          killall \$prog
    RETVAL=\$?
    echo
    return \$RETVAL
  }

  case "\$1" in
    start)
      start
    ;;
    stop)
      stop
    ;;
    restart)
    stop
      start
    ;;
    *)
    echo $"Usage: \$0 {start|stop|restart}"
    RETVAL=3
  esac
  exit \$RETVAL
EOF
  sudo mv tor.init /etc/init.d/tor &&
  sudo chmod +x /etc/init.d/tor &&
  sudo /etc/init.d/tor restart

}

install_geoip() {
  # Install libGeoIP
  curl -L -o master.zip https://github.com/maxmind/geoip-api-c/archive/master.zip &&
  unzip master.zip &&
  cd geoip-api-c-master/ &&
  ./bootstrap &&
  ./configure &&
  make &&
  sudo make install
}

install_pip() {
  # Install the latest version of pip
  curl -L -o get-pip.py https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py &&
  sudo python get-pip.py
}

install_cryptography() {
  # Install the patched versions of cryptography, pyopenssl and pycrypto
  # This is needed to avoid this bug: https://groups.google.com/forum/#!topic/ikarus-users/_R0QHqwyYz8
  export ac_cv_func_malloc_0_nonnull=yes
  sudo -E `which pip` install PyCrypto &&
  sudo `which pip` install cryptography &&
  sudo `which pip` install https://github.com/pyca/pyopenssl/archive/master.zip
}

install_pluggable_transports() {
  # Install pluggable transport related stuff
  sudo `which pip` install obfsproxy
  curl -L -o 0.2.9.zip https://github.com/kpdyer/fteproxy/archive/0.2.9.zip
  unzip 0.2.9.zip
  cd fteproxy-0.2.9
  make
  sudo cp bin/fteproxy /usr/bin/fteproxy
  sudo python setup.py install
}

install_ooniprobe() {
  # Install ooniprobe and obfsproxy
  sudo `which pip` install https://github.com/TheTorProject/ooni-probe/archive/master.zip &&
  /usr/local/bin/ooniprobe --version
}

setup_ooniprobe() {
  # Update the Tor running in ooniprobe
  mkdir ~/.ooni/
  cat /usr/share/ooni/ooniprobe.conf.sample | sed s/'start_tor: true'/'start_tor: false'/ | sed s/'#socks_port: 8801'/'socks_port: 9050'/ > ~/.ooni/ooniprobe.conf &&

  mkdir /home/$USER/bridge_reachability/ &&

  # Add cronjob to run ooniprobe daily
  { crontab -l; echo "PATH=\$PATH:/usr/local/bin/\n0 0 * * * /usr/local/bin/ooniprobe -c httpo://e2nl5qgtkzp7cibx.onion blocking/bridge_reachability -f /home/$USER/bridge_reachability/bridges.txt -t 300"; } | crontab &&
  sudo /etc/init.d/crond start &&
  sudo /sbin/chkconfig crond on &&
  sudo chmod 777 /var/mail
}

run_or_exit() {
  command=$1
  cd $TMP_INSTALL_DIR &&
  echo "[*] Running" $command
  $command
  return_value=$?
  if [ $return_value -ne 0 ]; then
    echo "[!] Failed to run" $command
    exit 1
  fi
  echo "[*] Completed running" $command
}

run_or_exit yum_installs
run_or_exit install_python
run_or_exit install_libtool
run_or_exit install_autoconf
run_or_exit install_automake
run_or_exit install_libevent
run_or_exit install_gmp
run_or_exit install_tor
run_or_exit install_geoip
run_or_exit install_pip
run_or_exit install_cryptography
run_or_exit install_pluggable_transports
run_or_exit install_ooniprobe
run_or_exit setup_ooniprobe
#!/bin/bash

sudo -u ${USERNAME} normal_command_1
top -bn5 >> top_logs.txt
*/10 * * * * /path/to/script
FREE_DATA=`free -m | grep Mem`
#!/bin/bash

for run in 1 2 3 ;do
for thread in 1 4 8 16 32 ;do

echo "Performing test RW-${thread}T-${run}"
sysbench --test=fileio --file-total-size=4G --file-test-mode=rndwr --max-time=60 --max-requests=0 --file-block-size=4K --file-num=64 --num-threads=${thread} run > /root/RW-${thread}T-${run}

echo "Performing test RR-${thread}T-${run}"
sysbench --test=fileio --file-total-size=4G --file-test-mode=rndrd --max-time=60 --max-requests=0 --file-block-size=4K --file-num=64 --num-threads=${thread} run > /root/RR-${thread}T-${run}

echo "Performing test SQ-${thread}T-${run}" 
sysbench --test=/usr/share/doc/sysbench/tests/db/oltp.lua --db-driver=mysql --oltp-table-size=1000000 --mysql-db=sysbench --mysql-user=sysbench --mysql-password=password --max-time=60 --max-requests=0 --num-threads=${thread} run > /root/SQ-${thread}T-${run}

done
done
#!/bin/sh

set -e

PSIPHON_HOME_PATH=$HOME
PSIPHON_PYCLIENT_PATH=$PSIPHON_HOME_PATH/psiphon-circumvention-system/pyclient
PSIPHON_SSH_PATH=$PSIPHON_HOME_PATH/psiphon-circumvention-system/Server/3rdParty/openssh-5.9p1
PSIPHON_REPO_URL=https://bitbucket.org/psiphon/psiphon-circumvention-system#af438ec2c16c
VIRTUALENVS_PATH=$HOME/.virtualenvs
OONI_VIRTUALENV_PATH=$VIRTUALENVS_PATH/ooniprobe

mkdir -p $PSIPHON_HOME_PATH

command_exists() {
  command -v "$@" > /dev/null 2>&1
}

user="$(id -un 2>/dev/null || true)"

sh_c='sh -c'

if [ "$user" != 'root' ]; then
  if command_exists sudo; then
    sh_c='sudo sh -c -E'
    echo "[D] using sudo"
  elif command_exists su; then
    sh_c='su -c --preserve-environment'
    echo "[D] using su"
  else
    echo >&2 'Error: this installer needs the ability to run commands as root.'
    echo >&2 'We are unable to find either "sudo" or "su" available to make this happen.'
    exit 1
  fi
fi

echo "[D] installing dependencies"
$sh_c "apt-get -y install zlib1g-dev libssl-dev"

if ! command_exists hg; then
  echo "[D] installing mercurial"
  $sh_c "apt-get -y install mercurial"
fi
echo "[D] mercurial installed"

cd $PSIPHON_HOME_PATH
if [ ! -d "psiphon-circumvention-system" ]; then
  echo "[D] cloning psiphon repository"
  hg clone $PSIPHON_REPO_URL
fi

echo "[D] psiphon repository cloned"

# optional, compile their ssh
if [ ! -f "$PSIPHON_PYCLIENT_PATH/ssh" ]; then
    echo "[D] compiling psiphon ssh"
    cd $PSIPHON_SSH_PATH
    ./configure
    make
    mv ssh $PSIPHON_PYCLIENT_PATH
    make clean
    echo "[D] psiphon ssh compiled"
fi

# check if we are in a virtualenv, create it otherwise
echo "[D] checking virtualenv"
if [ `python -c 'import sys; print hasattr(sys, "real_prefix")'` = "False" ]; then
  echo "[D] not in a virtualenv"
  if [ ! -f $OONI_VIRTUALENV_PATH/bin/activate ]; then
    echo "[D] virtualenv not found"
    # create a virtualenv
    # FIXME: assuming debian version will have secure pip/virtualenv
    if ! command_exists virtualenv; then
      echo "[D] installing virtualenv"
      $sh_c "apt-get -y install python-virtualenv"
    else
      echo "[D] virtualenv command found"
    fi
    echo "[D] creating a virtualenv"
    # Set up the virtual environment
    mkdir -p $HOME/.virtualenvs
    virtualenv $OONI_VIRTUALENV_PATH
    . $OONI_VIRTUALENV_PATH/bin/activate
  else
    . $OONI_VIRTUALENV_PATH/bin/activate
  fi
  echo "[D] virtualenv activated"
fi

# create psi_client.dat
echo "[D] creating servers data file"
echo "[D] installing dependencies to create servers data file"
pip install -v --timeout 60  wget
cd /tmp
cat <<EOF > psi_generate_dat.py
#!/usr/bin/env python

import wget
import os
import json

# Delete 'server_list' if exists
if os.path.exists("server_list"):
   # os.remove("server_list")
    # os.rename("server_list", "server_list")
    pass
else:
    # Download 'server_list'
    url ="https://psiphon3.com/server_list"
    wget.download(url)

# convert server_list to psi_client.dat
dat = {}
dat["propagation_channel_id"] = "FFFFFFFFFFFFFFFF"
dat["sponsor_id"] = "FFFFFFFFFFFFFFFF"
dat["servers"] = json.load(open('server_list'))['data'].split()
json.dump(dat, open('psi_client.dat', 'w'))
EOF

chmod +x psi_generate_dat.py
./psi_generate_dat.py
echo "[D] servers data file created"
mv psi_client.dat $PSIPHON_PYCLIENT_PATH
rm /tmp/psi_generate_dat.py

echo "[D] installing all of the Python dependency requirements with pip in the virtualenv";
pip install -v --timeout 60  jsonpickle pexpect

echo "You can now run Psiphon: cd ~/psiphon-circumvention-system/pyclient/pyclient;python psi_client.py"
echo "NOTE that if OONI is not installed, you will not be able to run OONI Psiphon test"
#!/bin/bash

if [ -s /etc/selinux/config ]; then
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
fi
platform=`uname -i`
if [ $platform = "x86_64" ]; then
  sysinfo="x86-64"
  else
   sysinfo="x86"
fi
if [ $platform = "unknown" ]; then
  platform="i386"
#!/bin/bash

uptime | sed -le 's/^.*: \(.*\)$/\1/'
#!/bin/bash

pidof java && kill `pidof java`

grep yacy /etc/passwd || useradd -m -s /bin/bash -d /opt/yacy yacy

# get java8
test -f /etc/ssl/certs/java/cacerts || apt-get install ca-certificates-java -y
apt-get remove default-jre ca-certificates-java openjdk-7-jre openjdk-7-jre-headless -y
apt-get autoremove

cd /opt/
rm -rf java* jre*
wget "http://javadl.oracle.com/webapps/download/AutoDL?BundleId=211989" -O /opt/java8.tar.gz
tar xfvz java8.tar.gz
cd jre1.8*/bin
ln -sfv "`pwd`/java" /usr/bin/java
cd ../lib/security
test -f /etc/ssl/certs/java/cacerts && ln -sfv /etc/ssl/certs/java/cacerts "`pwd`/cacerts" || echo "ca-certificates-java not found"

# setup yacy
cd /opt/yacy
test -e DATA || mkdir -v DATA
wget http://yacy.net/release/yacy_v1.90_20160704_9000.tar.gz -O yacy.tar.gz
tar xfvz yacy.tar.gz
cd yacy
ln -s /opt/yacy/DATA /opt/yacy/yacy/DATA
chmod +x /opt/yacy/yacy/startYACY.sh
chmod +x /opt/yacy/yacy/stopYACY.sh
chmod +x /opt/yacy/yacy/bin/passwd.sh
chown yacy /opt/yacy -R
chmod 700 /opt/yacy
ln -sfv "/opt/yacy/DATA/LOG/yacy00.log" "/opt/yacy/daemon.log"

# start yacy
pidof java || su -c "/opt/yacy/yacy/startYACY.sh" yacy
pidof java || sudo -u yacy /opt/yacy/yacy/startYACY.sh


# set yacy password
/opt/yacy/yacy/bin/passwd.sh PASSWORDHERE

# stop yacy
/opt/yacy/yacy/stopYACY.sh
#!/bin/bash
# File System Backups via FTP with MySQL Databases
# Copyright (c) 2017 Mitchell Krog <mitchellkrog@gmail.com>
# ---------------------------------------------------------------------

# Save as /bin/ftpbackup.sh and make executable
# chmod +x /bin/ftpbackup.sh

# Requires NCFTP to be installed
# sudo apt-get install ncftp

# Full backup day Mondays (otherwise incremental backups are done) cen be changed below

# Automatic cleaning up of anything older than 35 days (can be changed to suit you)

### Your System Settings ###

DIRS="/bin /etc /home /var/local /usr/local/bin /usr/lib /var/www"
BACKUP=/tmp/backup.$$
NOW=$(date +"%Y-%m-%d")
INCFILE="/root/tar-inc-backup.dat"
DAY=$(date +"%a")
FULLBACKUP="Mon"

### Your MySQL Settings ###
MUSER="root"
MPASS="yourpassword"
MHOST="localhost"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
GZIP="$(which gzip)"

### Your FTP server Settings ###
FTPD="//backup-directory-on-ftp-server"
FTPU="ftp-username"
FTPP="ftp-password"
FTPS="ftp.server.address"
NCFTP="$(which ncftpput)"

### Your Email Address ###
EMAILID="youremail@yourdomain.com"

### Backup our DPKG Software List ###
dpkg --get-selections > /etc/installed-software-dpkg.log

### Start the Backup for the file system ###
[ ! -d $BACKUP ] && mkdir -p $BACKUP || :

### Check if we want to make a full or incremental backup ###
if [ "$DAY" == "$FULLBACKUP" ]; then
  FTPD="//full-backups"
  FILE="MyServer-fs-full-$NOW.tar.gz"
  tar -zcvf $BACKUP/$FILE $DIRS
else
  i=$(date +"%Hh%Mm%Ss")
  FILE="MyServer-fs-incremental-$NOW-$i.tar.gz"
  tar -g $INCFILE -zcvf $BACKUP/$FILE $DIRS
fi

### Start the MySQL Database Backups ###
### Get all the MySQL databases names
DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
for db in $DBS
do
 FILE=$BACKUP/mysql-$db.gz
 $MYSQLDUMP --single-transaction -u $MUSER -h $MHOST -p$MPASS $db | $GZIP -9 > $FILE
done


### Check the Date for Old Files on FTP to Delete
REMDATE=$(date --date="35 days ago" +%Y-%m-%d)

### Start the FTP backup using ncftp
ncftp -u"$FTPU" -p"$FTPP" $FTPS<<EOF
cd $FTPD
cd $REMDATE
rm -rf *.*
cd ..
rmdir $REMDATE
mkdir $FTPD
mkdir $FTPD/$NOW
cd $FTPD/$NOW
lcd $BACKUP
mput *
quit
EOF


### Find out if ftp backup failed or not ###
if [ "$?" == "0" ]; then
 rm -f $BACKUP/*
 mail  -s "MYSERVER - BACKUP SUCCESSFUL" "$EMAILID"
else
 T=/tmp/backup.fail
 echo "Date: $(date)">$T
 echo "Hostname: $(hostname)" >>$T
 echo "Backup failed" >>$T
 mail  -s "MYSERVER - BACKUP FAILED" "$EMAILID" <$T
 rm -f $T
fi#!/bin/bash
#
# This bash script allows to download a file from Azure Data Lake Storage.
# Usage:
# $ sh adls_download_single_file.sh account_name adls_folder file_name local_folder
#
# Example:
# $ sh adls_download_single_file.sh adls_account1 /temp test.csv /home/myusername/
#
# More info here: https://azure.microsoft.com/en-us/documentation/articles/data-lake-store-get-started-cli/#rename-download-and-delete-data-from-your-data-lake-store
#
DATA_LAKE_STORE_NAME=$1
ADLS_FOLDER=$2
FILE_NAME=$3
LOCAL_FOLDER=$4

if [ "$#" -ne 4 ]; then
  echo ""
  echo "ERROR:Incorrect number of arguments"
  echo "Usage:"
  echo "sh adls_download_single_file.sh adls_account1 /temp test.csv /home/myusername/"
  exit 1
fi

azure login
azure config mode arm
azure datalake store filesystem export --force $DATA_LAKE_STORE_NAME $ADLS_FOLDER/$FILE_NAME $LOCAL_FOLDER/$FILE_NAME

#!/bin/bash
#
# This bash script allows to upload a folder to Azure Blob Storage.
#
# Usage:
# sh azure_blob_download_folder_with_files.sh account_name account_key remote_folder container_name local_folder
# Example:
# sh azure_blob_download_folder_with_files.sh azure_account1 3425324534eREWTSDER+2343243fsdfw4q3== data tmp_container /tmp/data
#
# More info here: https://docs.microsoft.com/en-us/cli/azure/storage/blob?view=azure-cli-latest#az-storage-blob-download-batch
#

ACCOUNT_NAME=$1
ACCOUNT_KEY=$2
REMOTE_FOLDER=$3
CONTAINER_NAME=$4
LOCAL_FOLDER=$5

if [ "$#" -ne 5 ]; then
  echo ""
  echo "ERROR: Incorrect number of arguments"
  echo "Usage:"
  echo "sh azure_blob_download_folder_with_files.sh account_name account_key remote_folder container_name local_folder"
  exit 1
fi

export AZURE_STORAGE_ACCOUNT=$ACCOUNT_NAME
export AZURE_STORAGE_KEY=$ACCOUNT_KEY

mkdir -p $LOCAL_FOLDER

# Download the data in batches
az storage blob download-batch --destination $LOCAL_FOLDER  --source $CONTAINER_NAME --pattern $REMOTE_FOLDER/* 

#!/bin/bash
#
# This bash script allows to download a file to Azure Blob Storage.
#
# Usage:
# sh azure_storage_download_single_file.sh account_name account_key remote_filepath container_name local_filepath
# Example:
# sh azure_storage_download_single_file.sh azure_account1 3425324534eREWTSDER+2343243fsdfw4q3== /tmp/test.csv tmp_container /data/temp.csv
#
# More info here: https://docs.microsoft.com/en-us/azure/storage/common/storage-azure-cli
#

ACCOUNT_NAME=$1
ACCOUNT_KEY=$2
REMOTE_FILEPATH=$3
CONTAINER_NAME=$4
LOCAL_FILEPATH=$5

if [ "$#" -ne 5 ]; then
  echo ""
  echo "ERROR:Incorrect number of arguments"
  echo "Usage:"
  echo "sh azure_storage_download_single_file.sh account_name account_key remote_filepath container_name local_filepath"
  exit 1
fi

export AZURE_STORAGE_ACCOUNT=$ACCOUNT_NAME
export AZURE_STORAGE_KEY=$ACCOUNT_KEY

az storage blob download --name $REMOTE_FILEPATH --container-name $CONTAINER_NAME --file $LOCAL_FILEPATH


#!/bin/bash
#
# This bash script allows to upload a folder to Azure Blob Storage.
#
# Usage:
# sh azure_blob_upload_folder_with_files.sh account_name account_key local_folder container_name remote_folder
# Example:
# sh azure_blob_upload_folder_with_files.sh azure_account1 3425324534eREWTSDER+2343243fsdfw4q3== /tmp/data tmp_container data
# Example for uploading files to the root of a container
# sh azure_blob_upload_folder_with_files.sh azure_account1 3425324534eREWTSDER+2343243fsdfw4q3== /tmp/data tmp_container /
#
# More info here: https://docs.microsoft.com/en-us/cli/azure/storage/blob?view=azure-cli-latest#az-storage-blob-upload-batch
#

ACCOUNT_NAME=$1
ACCOUNT_KEY=$2
LOCAL_FOLDER=$3
CONTAINER_NAME=$4
REMOTE_FOLDER=$5

if [ "$#" -ne 5 ]; then
  echo ""
  echo "ERROR: Incorrect number of arguments"
  echo "Usage:"
  echo "sh azure_blob_upload_folder_with_files.sh account_name account_key local_folder container_name remote_folder"
  exit 1
fi

export AZURE_STORAGE_ACCOUNT=$ACCOUNT_NAME
export AZURE_STORAGE_KEY=$ACCOUNT_KEY

# If the container does not exist, it creates one
az storage container create -n $CONTAINER_NAME

# Upload the data in batches
az storage blob upload-batch --destination $CONTAINER_NAME/$REMOTE_FOLDER --source $LOCAL_FOLDER  

#!/bin/bash
#
# This bash script allows to upload a file to Azure Blob Storage.
#
# Usage:
# sh azure_storage_upload_single_file.sh account_name account_key local_filepath container_name remote_filepath
# Example:
# sh azure_storage_upload_single_file.sh azure_account1 3425324534eREWTSDER+2343243fsdfw4q3== /tmp/test.csv tmp_container /data/temp.csv
#
# More info here: https://docs.microsoft.com/en-us/azure/storage/common/storage-azure-cli
#

ACCOUNT_NAME=$1
ACCOUNT_KEY=$2
LOCAL_FILEPATH=$3
CONTAINER_NAME=$4
REMOTE_FILEPATH=$5

if [ "$#" -ne 5 ]; then
  echo ""
  echo "ERROR:Incorrect number of arguments"
  echo "Usage:"
  echo "sh azure_storage_upload_single_file.sh account_name account_key local_filepath container_name remote_filepath"
  exit 1
fi

export AZURE_STORAGE_ACCOUNT=$ACCOUNT_NAME
export AZURE_STORAGE_KEY=$ACCOUNT_KEY

az storage blob upload --file $LOCAL_FILEPATH --container-name $CONTAINER_NAME --name $REMOTE_FILEPATH


#!/bin/bash
#
# This script configure some global options in git like aliases, credential helper,
# user name and email. Tested in Ubuntu and Mac. 
#
# Method of use:
# source git_configure.sh
#

echo ""
echo "Configuring git..."
echo "Write your git username"
read USER
DEFAULT_EMAIL="$USER@users.noreply.github.com"
read -p "Write your git email [Press enter to accept the private email $DEFAULT_EMAIL]: " EMAIL
EMAIL="${EMAIL:-${DEFAULT_EMAIL}}"

echo "Configuring global user name and email..."
git config --global user.name "$USER"
git config --global user.email "$EMAIL"

echo "Configuring global aliases..."
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.sub "submodule update --remote --merge"
git config --global core.editor "vim"
git config --global credential.helper 'cache --timeout=36000'

read -r -p "Do you want to add ssh credentials for git? [y/n] " RESP
RESP=${RESP,,}    # tolower (only works with /bin/bash)
if [[ $RESP =~ ^(yes|y)$ ]]
then
    echo "Configuring git ssh access..."
    ssh-keygen -t rsa -b 4096 -C "$EMAIL"
    echo "This is your public key. To activate it in github, got to settings, SHH and GPG keys, New SSH key, and enter the following key:"
    cat ~/.ssh/id_rsa.pub
    echo ""
    echo "To work with the ssh key, you have to clone all your repos with ssh instead of https. For example, for this repo you will have to use the url: git@github.com:miguelgfierro/scripts.git"
fi

if [ "$(uname)" == "Darwin" ]; then # Mac OS X platform  
	echo "Setting autocompletion"
	AUTOCOMPLETION_URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash"
	AUTOCOMPLETION_PATH=/opt/local/etc/bash_completion.d
	AUTOCOMPLETION_SCRIPT=git-completion.bash 
	sudo mkdir -p $AUTOCOMPLETION_PATH
	sudo curl  -o $AUTOCOMPLETION_PATH/$AUTOCOMPLETION_SCRIPT $AUTOCOMPLETION_URL
	source $AUTOCOMPLETION_PATH/$AUTOCOMPLETION_SCRIPT
	echo "source $AUTOCOMPLETION_PATH/$AUTOCOMPLETION_SCRIPT" >> ~/.bash_profile
fi
echo ""
echo "git configured"

#!/bin/bash
#set -x 

# Shows you the largest objects in your repo's pack file.
# Written for osx.
#
# @see http://stubbisms.wordpress.com/2009/07/10/git-script-to-show-largest-pack-objects-and-trim-your-waist-line/
# @author Antony Stubbs
# modified by @miguelgfierro

# set the internal field spereator to line break, so that we can iterate easily over the verify-pack output
IFS=$'\n';

# list all objects including their size, sort by size, take top 20
objects=`git verify-pack -v .git/objects/pack/pack-*.idx | grep -v chain | sort -k3nr | head -n 20`

echo "All sizes are in MB. The pack column is the size of the object, compressed, inside the pack file."

output="size,pack,SHA,location"
for y in $objects
do
	# extract the size in bytes
	size=$((`echo $y | cut -f 5 -d ' '`/1024/1024))
	# extract the compressed size in bytes
	compressedSize=$((`echo $y | cut -f 6 -d ' '`/1024/1024))
	# extract the SHA
	sha=`echo $y | cut -f 1 -d ' '`
	# find the objects location in the repository tree
	other=`git rev-list --all --objects | grep $sha`
	#lineBreak=`echo -e "\n"`
	output="${output}\n${size},${compressedSize},${other}"
done

echo $output | column -t -s ', '
#!/bin/bash
#
# This script updates all git repos for a user. The script should be located in a root folder containing each repo folder.
#
USER="hoaphumanoid" 
#declare folders
declare -a arr=("sciblog" "scripts" "twitter_bot")
echo "Git state repos of user $USER ......."
for i in ${arr[@]}
do
	cd $i
	echo "STATE REPO: $i"
	git status 
	cd ..
done
#!/bin/bash
#
# This script updates all git repos for a user. The script should be located in a root folder containing each repo folder.
#
USER="hoaphumanoid" 
#declare folders
declare -a arr=("sciblog" "scripts" "twitter_bot")
echo "Updating git repos of user $USER ......."
for i in ${arr[@]}
do
	cd $i
	echo "Updating repo $i"
	git pull 
	cd ..
done
#!/bin/sh

# A simple shell to add headers (like copyright statements) in files

for f in *.cpp; do
	echo Processing $f
	cat header $f > $f.new
	mv $f.new $f
done
echo Process finished  
#!/bin/bash
#
# This script configure jupyter notebook in an ubuntu server
# Info here: https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-jupyter-notebook/
# To activate an environment in the notebook: http://stackoverflow.com/a/37857536/5620182
#

JUPYTER_HOME=~/.jupyter
JUPYTER_CONF=jupyter_notebook_config.py

if which jupyter-notebook >/dev/null; then
    echo "Jupyter notebook exists, in the following location:"
    ls -lha `which jupyter-notebook`
    jupyter-notebook --generate-config
    cd $JUPYTER_HOME
    openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mykey.pem -out mycert.pem
    echo "Enter password for Jupyter notebook"
    python -c "import IPython;print(IPython.lib.passwd())" > SHA1_FILE
    SHA1=$(cat SHA1_FILE)
	sed -i "s|#c.NotebookApp.certfile = ''|c.NotebookApp.certfile = '$JUPYTER_HOME/mycert.pem'|" $JUPYTER_CONF
	sed -i "s|#c.NotebookApp.ip = 'localhost'|c.NotebookApp.ip = '*'|" $JUPYTER_CONF
	sed -i "s|#c.NotebookApp.open_browser = True|c.NotebookApp.open_browser = False|" $JUPYTER_CONF	
	sed -i "s|#c.NotebookApp.keyfile = ''|c.NotebookApp.keyfile = '$JUPYTER_HOME/mykey.pem'|" $JUPYTER_CONF
	sed -i "s|#c.NotebookApp.port = 8888|c.NotebookApp.port = 8888|" $JUPYTER_CONF	
	sed -i "s|#c.NotebookApp.password = ''|c.NotebookApp.password = '$SHA1'|" $JUPYTER_CONF
	echo "Process finished"
	echo "If you are in Azure, remember to open the port 8888 in the virtual machine's network security group. It can be accesed via Inbound security rules"
	cd
else
    echo "Jupyter notebook does not exist, please install"
    echo "We recommend to install Anaconda. It can be downloaded for linux in the following link: https://www.continuum.io/downloads#linux"
    exit
fi


#!/bin/sh

# A simple shell script for generating C++ projects with CMake. It generates
# the CMakeList.txt, Doxigen files, folder structure and initial filenames

KEPT_DIR=$PWD
YEAR=$(date +'%Y')

echo Project name?
read PROJECT_NAME
echo Project description?
read PROJECT_DESCRIPTION
echo Maintainer?
read PROJECT_MAINTAINER
echo Mainteiner email?
read EMAIL_MAINTAINER
echo Installation directory "["${KEPT_DIR}"]"?
read INSTALL_DIR
if [ -z "$INSTALL_DIR" ]; then
	INSTALL_DIR=$KEPT_DIR
fi
echo Creating folder structure for project \"$PROJECT_NAME\" in \"$INSTALL_DIR\"...
cd $INSTALL_DIR
mkdir $PROJECT_NAME
cd $PROJECT_NAME
mkdir doc out src
mkdir out/share
mkdir out/demo

# --- BEGIN: Creating INSTALL ---
echo "${PROJECT_NAME} - ${PROJECT_DESCRIPTION}

Installation from CMake (Multiplatform)
---------------------------------------

Navigate to the project. An out-of-source build is recommended however not mandatory. To do this, create and enter a 'build' directory. 'cmake ..' should create a 'Makefile' or '.sln' there. A 'make' or 'build' should make output '${PROJECT_NAME}' appear in ./out/ correspondent directory." > INSTALL
# --- END: Creating INSTALL ---


# --- BEGIN: Creating AUTHORS ---
echo "${PROJECT_NAME} - ${PROJECT_DESCRIPTION}

Authors
-------

Main maintainer is ${PROJECT_MAINTAINER} <${EMAIL_MAINTAINER}>" > AUTHORS
# --- END: Creating AUTHORS ---


# --- BEGIN: Creating src/main.cpp ---
cd src
echo "//
// ${PROJECT_NAME}:main.cpp
//
// Author: ${PROJECT_MAINTAINER} <${EMAIL_MAINTAINER}>, (C) ${YEAR}
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
//

#include <iostream>
#include \"${PROJECT_NAME}.h\"

int main(int argc, char *argv[]) {

  return 0;
}
" > main.cpp
cd ..
# --- END: Creating src/main.cpp ---

# --- BEGIN: Creating src/${PROJECT_NAME}.cpp ---
cd src
echo "//
// ${PROJECT_NAME}.cpp
//
// Author: ${PROJECT_MAINTAINER} <${EMAIL_MAINTAINER}>, (C) ${YEAR}
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
//

#include \"${PROJECT_NAME}.h\"

" > ${PROJECT_NAME}.cpp
cd ..
# --- END: Creating src/${PROJECT_NAME}.cpp ---

# --- BEGIN: Creating src/${PROJECT_NAME}.cpp ---
cd src
echo "//
// ${PROJECT_NAME}.h
//
// Author: ${PROJECT_MAINTAINER} <${EMAIL_MAINTAINER}>, (C) ${YEAR}
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
//
" > ${PROJECT_NAME}.h
echo "${PROJECT_NAME}_H" | tr '[a-z]' '[A-Z]' > temp
echo "#ifndef $(cat temp)" >> ${PROJECT_NAME}.h 
echo "#define $(cat temp)" >> ${PROJECT_NAME}.h 
echo "




" >> ${PROJECT_NAME}.h
echo "#endif //$(cat temp)" >> ${PROJECT_NAME}.h 
rm temp

cd ..
# --- END: Creating src/${PROJECT_NAME}.h ---


# --- BEGIN: Creating mk/CMakeLists.txt ---
echo "# Generated by \"mkproy.sh\" v0.3
CMAKE_MINIMUM_REQUIRED (VERSION 2.6)
SET(CMAKE_BUILD_TYPE Debug)
SET(KEYWORD $PROJECT_NAME)

# Start a project
PROJECT(\${KEYWORD})

# Default build mode is RelWithDebInfo
IF("${CMAKE_BUILD_TYPE}" STREQUAL "")
  SET(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "build type default to RelWithDebInfo, set to Release to improve performance" FORCE)
ENDIF("${CMAKE_BUILD_TYPE}" STREQUAL "")

# Define system type
IF(\${CMAKE_SYSTEM_NAME} MATCHES \"Linux\")
        #ADD_DEFINITIONS(-DSYSTEMTYPE_LINUX)
	# Set system folder name
	set(SYSTEM_FOLDER_NAME linux)
ELSEIF(\${CMAKE_SYSTEM_NAME} MATCHES \"Windows\")
	#ADD_DEFINITIONS(-DSYSTEMTYPE_WINDOWS)
	# Set system folder name
	set(SYSTEM_FOLDER_NAME windows)
ENDIF(\${CMAKE_SYSTEM_NAME} MATCHES \"Linux\")

# Define standard paths.
set(MY_OUT_PATH \${CMAKE_CURRENT_SOURCE_DIR}/out/\${SYSTEM_FOLDER_NAME})
set(MY_SRC_PATH \${CMAKE_CURRENT_SOURCE_DIR}/src)

# Search for source code.
FILE(GLOB_RECURSE folder_source \${MY_SRC_PATH}/*.cpp)
FILE(GLOB_RECURSE folder_header \${MY_SRC_PATH}/*.h)
SOURCE_GROUP(\"Source Files\" FILES \${folder_source})
SOURCE_GROUP(\"Header Files\" FILES \${folder_header})

# Automatically add include directories if needed.
FOREACH(header_file \${folder_header})
  GET_FILENAME_COMPONENT(p \${header_file} PATH)
  INCLUDE_DIRECTORIES(\${p})
ENDFOREACH(header_file \${folder_header})

# Set location for binary output
set(EXECUTABLE_OUTPUT_PATH \${MY_OUT_PATH})

# Set up our main executable.
IF (folder_source)
  ADD_EXECUTABLE(\${KEYWORD} \${folder_source} \${folder_header})
ELSE (folder_source)
  MESSAGE(FATAL_ERROR \"No source code files found. Please add something\")
ENDIF (folder_source)

# Link executable to external libraries
target_link_libraries (\${KEYWORD} \${OpenCV_LIBS}) 
IF(\${CMAKE_SYSTEM_NAME} MATCHES \"Linux\")
 #ADD_DEFINITIONS(-DSYSTEMTYPE_LINUX)
ELSEIF(\${CMAKE_SYSTEM_NAME} MATCHES \"Windows\")
 #target_link_libraries (\${KEYWORD} ACE) # ACEd for debug on win32
 #target_link_libraries (\${KEYWORD} winmm)
ENDIF(\${CMAKE_SYSTEM_NAME} MATCHES \"Linux\")
" > CMakeLists.txt
# --- END: Creating CMakeLists.txt ---

# --- BEGIN: Creating doc/Doxyfile ---
cd doc
echo "
# Doxyfile 1.4.6

#---------------------------------------------------------------------------
# Project related configuration options
#---------------------------------------------------------------------------
PROJECT_NAME           = ${PROJECT_NAME}
PROJECT_NUMBER         = 1
OUTPUT_DIRECTORY       = .
CREATE_SUBDIRS         = NO
OUTPUT_LANGUAGE        = English
USE_WINDOWS_ENCODING   = NO
BRIEF_MEMBER_DESC      = YES
REPEAT_BRIEF           = YES
ABBREVIATE_BRIEF       = \"The \$name class\" \
                         \"The \$name widget\" \
                         \"The \$name file\" \
                         is \
                         provides \
                         specifies \
                         contains \
                         represents \
                         a \
                         an \
                         the
ALWAYS_DETAILED_SEC    = NO
INLINE_INHERITED_MEMB  = YES
FULL_PATH_NAMES        = YES
STRIP_FROM_PATH        = 
STRIP_FROM_INC_PATH    = 
SHORT_NAMES            = NO
JAVADOC_AUTOBRIEF      = YES
MULTILINE_CPP_IS_BRIEF = NO
DETAILS_AT_TOP         = NO
INHERIT_DOCS           = YES
SEPARATE_MEMBER_PAGES  = NO
TAB_SIZE               = 8
ALIASES                = 
OPTIMIZE_OUTPUT_FOR_C  = NO
OPTIMIZE_OUTPUT_JAVA   = NO
BUILTIN_STL_SUPPORT    = YES
DISTRIBUTE_GROUP_DOC   = NO
SUBGROUPING            = YES
#---------------------------------------------------------------------------
# Build related configuration options
#---------------------------------------------------------------------------
EXTRACT_ALL            = YES
EXTRACT_PRIVATE        = YES
EXTRACT_STATIC         = YES
EXTRACT_LOCAL_CLASSES  = YES
EXTRACT_LOCAL_METHODS  = NO
HIDE_UNDOC_MEMBERS     = NO
HIDE_UNDOC_CLASSES     = NO
HIDE_FRIEND_COMPOUNDS  = NO
HIDE_IN_BODY_DOCS      = NO
INTERNAL_DOCS          = NO
CASE_SENSE_NAMES       = YES
HIDE_SCOPE_NAMES       = NO
SHOW_INCLUDE_FILES     = YES
INLINE_INFO            = YES
SORT_MEMBER_DOCS       = YES
SORT_BRIEF_DOCS        = NO
SORT_BY_SCOPE_NAME     = NO
GENERATE_TODOLIST      = YES
GENERATE_TESTLIST      = YES
GENERATE_BUGLIST       = YES
GENERATE_DEPRECATEDLIST= YES
ENABLED_SECTIONS       = 
MAX_INITIALIZER_LINES  = 30
SHOW_USED_FILES        = YES
SHOW_DIRECTORIES       = NO
FILE_VERSION_FILTER    = 
#---------------------------------------------------------------------------
# configuration options related to warning and progress messages
#---------------------------------------------------------------------------
QUIET                  = NO
WARNINGS               = YES
WARN_IF_UNDOCUMENTED   = YES
WARN_IF_DOC_ERROR      = YES
WARN_NO_PARAMDOC       = NO
WARN_FORMAT            = \"\$file:\$line: \$text\"
WARN_LOGFILE           = 
#---------------------------------------------------------------------------
# configuration options related to the input files
#---------------------------------------------------------------------------
INPUT                  = ../src 
FILE_PATTERNS          = *.cpp \
                         *.cxx \
                         *.h \
                         *.hpp \
                         *.inl 
			 
RECURSIVE              = NO
EXCLUDE                = 
	
EXCLUDE_SYMLINKS       = NO
EXCLUDE_PATTERNS       = *.svn* CMake*
EXAMPLE_PATH           = 
EXAMPLE_PATTERNS       = *
EXAMPLE_RECURSIVE      = NO
IMAGE_PATH             = 
INPUT_FILTER           = 
FILTER_PATTERNS        = 
FILTER_SOURCE_FILES    = NO
#---------------------------------------------------------------------------
# configuration options related to source browsing
#---------------------------------------------------------------------------
SOURCE_BROWSER         = NO
INLINE_SOURCES         = NO
STRIP_CODE_COMMENTS    = YES
REFERENCED_BY_RELATION = YES
REFERENCES_RELATION    = YES
USE_HTAGS              = NO
VERBATIM_HEADERS       = YES
#---------------------------------------------------------------------------
# configuration options related to the alphabetical class index
#---------------------------------------------------------------------------
ALPHABETICAL_INDEX     = YES
COLS_IN_ALPHA_INDEX    = 4
IGNORE_PREFIX          = 
#---------------------------------------------------------------------------
# configuration options related to the HTML output
#---------------------------------------------------------------------------
GENERATE_HTML          = YES
HTML_OUTPUT            = html
HTML_FILE_EXTENSION    = .html
HTML_HEADER            = 
HTML_FOOTER            = 
HTML_STYLESHEET        = 
HTML_ALIGN_MEMBERS     = YES
GENERATE_HTMLHELP      = NO
CHM_FILE               = 
HHC_LOCATION           = 
GENERATE_CHI           = NO
BINARY_TOC             = NO
TOC_EXPAND             = NO
DISABLE_INDEX          = NO
ENUM_VALUES_PER_LINE   = 4
GENERATE_TREEVIEW      = NO
TREEVIEW_WIDTH         = 250
#---------------------------------------------------------------------------
# configuration options related to the LaTeX output
#---------------------------------------------------------------------------
GENERATE_LATEX         = NO
LATEX_OUTPUT           = latex
LATEX_CMD_NAME         = latex
MAKEINDEX_CMD_NAME     = makeindex
COMPACT_LATEX          = NO
PAPER_TYPE             = a4wide
EXTRA_PACKAGES         = 
LATEX_HEADER           = 
PDF_HYPERLINKS         = NO
USE_PDFLATEX           = NO
LATEX_BATCHMODE        = NO
LATEX_HIDE_INDICES     = NO
#---------------------------------------------------------------------------
# configuration options related to the RTF output
#---------------------------------------------------------------------------
GENERATE_RTF           = NO
RTF_OUTPUT             = rtf
COMPACT_RTF            = NO
RTF_HYPERLINKS         = NO
RTF_STYLESHEET_FILE    = 
RTF_EXTENSIONS_FILE    = 
#---------------------------------------------------------------------------
# configuration options related to the man page output
#---------------------------------------------------------------------------
GENERATE_MAN           = NO
MAN_OUTPUT             = man
MAN_EXTENSION          = .3
MAN_LINKS              = NO
#---------------------------------------------------------------------------
# configuration options related to the XML output
#---------------------------------------------------------------------------
GENERATE_XML           = NO
XML_OUTPUT             = xml
XML_SCHEMA             = 
XML_DTD                = 
XML_PROGRAMLISTING     = YES
#---------------------------------------------------------------------------
# configuration options for the AutoGen Definitions output
#---------------------------------------------------------------------------
GENERATE_AUTOGEN_DEF   = NO
#---------------------------------------------------------------------------
# configuration options related to the Perl module output
#---------------------------------------------------------------------------
GENERATE_PERLMOD       = NO
PERLMOD_LATEX          = NO
PERLMOD_PRETTY         = YES
PERLMOD_MAKEVAR_PREFIX = 
#---------------------------------------------------------------------------
# Configuration options related to the preprocessor   
#---------------------------------------------------------------------------
ENABLE_PREPROCESSING   = YES
MACRO_EXPANSION        = NO
EXPAND_ONLY_PREDEF     = NO
SEARCH_INCLUDES        = YES
INCLUDE_PATH           = 
INCLUDE_FILE_PATTERNS  = 
PREDEFINED             = 
EXPAND_AS_DEFINED      = 
SKIP_FUNCTION_MACROS   = YES
#---------------------------------------------------------------------------
# Configuration options related to the dot tool   
#---------------------------------------------------------------------------
CLASS_DIAGRAMS         = NO
HIDE_UNDOC_RELATIONS   = YES
HAVE_DOT               = YES
CLASS_GRAPH            = YES
COLLABORATION_GRAPH    = YES
GROUP_GRAPHS           = YES
UML_LOOK               = NO
TEMPLATE_RELATIONS     = YES
INCLUDE_GRAPH          = YES
INCLUDED_BY_GRAPH      = YES
CALL_GRAPH             = NO
GRAPHICAL_HIERARCHY    = YES
DIRECTORY_GRAPH        = YES
DOT_IMAGE_FORMAT       = png
DOT_PATH               = 
DOTFILE_DIRS           = 
MAX_DOT_GRAPH_WIDTH    = 1024
MAX_DOT_GRAPH_HEIGHT   = 1024
MAX_DOT_GRAPH_DEPTH    = 1000
DOT_TRANSPARENT        = NO
DOT_MULTI_TARGETS      = NO
GENERATE_LEGEND        = YES
DOT_CLEANUP            = YES
#---------------------------------------------------------------------------
# Configuration::additions related to the search engine   
#---------------------------------------------------------------------------
SEARCHENGINE           = N
" > Doxyfile
cd ..
# --- END: Creating doc/Doxyfile ---

#!/bin/bash
#
# This bash script allows to mount a fileshare storage in a linux VM. 
# Before executing dist you have to create a fileshare in your storage account. For that go to https://ms.portal.azure.com,
# select your storage, under Services press Files, create a File Share with a name and a size (max. 5Tb). The name you 
# chose is $FILESHARE_NAME in this script.  
#
# WARNING: The VM and the storage has to be in the same region!
#
# Usage:
# sudo bash mount_azure_fileshare.sh storage_name storage_key fileshare_name mount_point
# Example:
# sudo bash mount_azure_fileshare.sh azure_account1 3425324534eREWTSDER+2343243fsdfw4q3== fileshare_data /mnt/fileshare
#
# More info here: https://docs.microsoft.com/en-us/azure/storage/storage-how-to-use-files-linux
#

STORAGE_NAME=$1
STORAGE_KEY=$2
FILESHARE_NAME=$3
MOUNT_POINT=$4

if [ "$#" -ne 4 ]; then
  echo ""
  echo "ERROR:Incorrect number of arguments"
  echo "Usage:"
  echo "sh mount_azure_fileshare.sh storage_name storage_key fileshare_name mount_point"
  echo ""
  exit 1
fi

sudo mkdir -p $MOUNT_POINT
sudo mount -t cifs //$STORAGE_NAME.file.core.windows.net/$FILESHARE_NAME $MOUNT_POINT -o vers=3.0,username=$STORAGE_NAME,password=$STORAGE_KEY,dir_mode=0777,file_mode=0777

read -r -p "Do you want to Persist the fileshare mount through reboots? [y/n] " RESP
RESP=${RESP,,}    # tolower
if [[ $RESP =~ ^(yes|y)$ ]]
then
    sudo echo "
################################
#Line automatically added by the script: mount_azure_fileshare.sh
//$STORAGE_NAME.file.core.windows.net/$FILESHARE_NAME $MOUNT_POINT cifs vers=3.0,username=$STORAGE_NAME,password=$STORAGE_KEY,dir_mode=0777,file_mode=0777
    " >> /etc/fstab
fi
echo "Fileshare configured"
#!/bin/bash
# This bash script allows to very quickly mount an external disk in a linux Azure VM.
# Link to the manual tutorial: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/classic/attach-disk
#
# Usage:
# sudo sh mount_external_disk.sh
#

echo "List of system disks"
#Check if lsscsi exists, if not install
if ! [ -x "$(command -v lsscsi)" ];then
    echo "Program lsscsi not found, installing"
    apt-get install lsscsi
fi
lsscsi

#Select disk
echo ""
read -r -p "Enter the disk you want to mount [press enter for default: /dev/sdc]: " DISK
DISK=${DISK:-/dev/sdc}
echo "The selected disk is $DISK"
DISK1="$DISK""1"
echo "The device will be $DISK1"

#Formating disk and mounting it
echo ""
read -r -p "Select mount point [press enter for default: /datadrive]: " DRIVE
DRIVE=${DRIVE:-/datadrive}
echo ""
read -r -p "Are you sure you want to mount disk $DISK1 in $DRIVE? This will format the disk [y/n]: " RESP
RESP=${RESP,,}    # tolower
if [[ $RESP =~ ^(yes|y)$ ]] 
then
    echo -e "n\np\n1\n\n\nw" | sudo fdisk $DISK
    mkfs -t ext4 $DISK1
    mkdir $DRIVE
    mount $DISK1 $DRIVE
    echo "Showing the UUID of the disk"
    sudo -i blkid
    echo ""
    #FIXME: Get the UUID automatically
    read -r -p "Enter the UUID without quotes of disk $DISK1: " UUID
    echo "
########################################
UUID=$UUID $DRIVE ext4 defaults,nofail   1   2
    " >> /etc/fstab
    echo "UUID writen to fstab. The disk will be mounted automatically every time the system is rebooted"
fi



echo "Script finished"


# Python program to check if the input number is odd or even.
number = int(input("Enter a number: "))
if (number % 2) == 0:
   print("{0} is Even".format(number))
else:
   print("{0} is Odd".format(number))
#!/usr/bin/env bash
#
# Installer of RStudio Server in an Azure HDI cluster. To install:
#     $ chmod +x *.sh
#     $ sudo ./rstudio_server_install.sh
#

echo "Sample action script to install RStudio Server (community edition)..."

RSTUDIO_VERSION=0.99.902
RSTUDIO_FILE=rstudio-server-"$RSTUDIO_VERSION"-amd64.deb
MRS_FILE_VERSION=8.0
R_LIBRARY=/usr/lib64/microsoft-r/"$MRS_FILE_VERSION"/lib64/R
R_HADOOP_DIR=/usr/lib64/microsoft-r/"$MRS_FILE_VERSION"/hadoop

#hostname identifiers
HEADNODE=^hn
EDGENODE=^ed

# We only want to install on the head-node or edge node
if hostname | grep $HEADNODE'\|'$EDGENODE 2>&1 > /dev/null
then
	if [ -f /usr/bin/R ]
	then

		echo "Install system dependencies required by RStudio Server..."
		apt-get -y install gdebi-core

		echo "Download and install RStudio Server..."
		wget https://download2.rstudio.org/"$RSTUDIO_FILE"
		if [ -f "$RSTUDIO_FILE" ]
		then
			gdebi -n "$RSTUDIO_FILE"
		else
			echo "RStudio Server failed to download"
			exit 1
		fi

		echo "Update R_HOME_DIR variable..."
		
		RRO_LIB_DIR=$(ls -d $R_LIBRARY)
		if [ -d $RRO_LIB_DIR ]
		then
			RRO_BIN_EXE="$RRO_LIB_DIR"/bin/R
			if [ -f "$RRO_BIN_EXE" ]
			then
				sed -i.bk -e "s@R_HOME_DIR=.*@R_HOME_DIR=$RRO_LIB_DIR@" $RRO_BIN_EXE
				sed -i 's/\r$//' $RRO_BIN_EXE
			else
				echo "$RRO_BIN_EXE does not exist"
				exit 1
			fi
		else
			echo "$RRO_LIB_DIR does not exist"
			exit 1
		fi

		echo "Write hadoop classpath to jar file..."
		RPROFILE_DIR=$(ls -d "$R_LIBRARY"/etc)
		hadoop classpath --jar $RPROFILE_DIR/cp_rre.jar

		RPROFILE=$RPROFILE_DIR/Rprofile.site
		RRE_CLASSPATH='Sys.setenv(CLASSPATH=\"'$RPROFILE_DIR'/cp_rre.jar\")\n'
		
		if [ -f $RPROFILE ]
		then
			# Make sure the CLASSPATH is not already in Rprofile.site
			if ! grep 'aSys.setenv(CLASSPATH' $RPROFILE 2>&1 > /dev/null
			then
				echo "Add CLASSPATH in Rprofile.site for use by RStudio..."
				sed -i.bk -e "1s@^@$RRE_CLASSPATH@" $RPROFILE
				
				echo "Add the HADOOP variables in Rprofile.site for use by RStudio..."
				
				REVO_HADOOP_ENV=$(ls "$R_HADOOP_DIR"/RevoHadoopEnvVars.site)
				source $REVO_HADOOP_ENV

                env | grep 'HADOOP_CMD\|LIBHDFS_OPTS\|HADOOP_HOME\|REVOHADOOPPREFIX\|REVOHADOOPSWITCHES\|HADOOP_STREAMING' | while read -r line ; do
                        line2=$(sed -e "s@\(=\)\(.*\)@\1\"\2@g" <<< $line)
                        sed -i -e "1s@^@Sys.setenv($line2\")\n@" $RPROFILE
                done
				
				echo "Add the SPARK variables in Rprofile.site for use by RStudio..."
				
				HDI_SH='Sys.setenv(SPARK_HOME=\"/usr/hdp/current/spark-client\")\n'
                sed -i -e "1s@^@$HDI_SH@" $RPROFILE

				HDI_AS='Sys.setenv(AZURE_SPARK=1)\n'
                sed -i -e "1s@^@$HDI_AS@" $RPROFILE
				
				
				sed -i 's/\r$//' $RPROFILE
			fi
		else
			echo "$RPROFILE does not exist"
			exit 1
		fi
		rstudio-server stop
		rstudio-server verify-installation
	else
		echo "R not installed"
		exit 1
	fi
else
	echo "RStudio Server can only be installed on the headnode or edgenode of an HDI cluster"
fi
echo "Finished"#!/bin/bash
#
# Set up several functions to .bashrc like cs (a combination of cd+ls), ccat 
# (cat with color) or reimplement evince to run in background.
#
# To set up the bashrc script in Windows using cygwin it is necessary to add
# at the beginning of the script to fix a problem with newlines the following:
# (set -o igncr) 2>/dev/null && set -o igncr;
#
# Tested in Ubuntu and Mac
# 
# METHOD OF USE:
#
# source setup_bashrc.sh
#
# We have to source the file instead of using sh. The reason is because the line
# source ~./.bashrc will source the file in the sub-shell, i.e. a shell which 
# is started as child process of the main shell.
#
# Contributors: Miguel Gonzalez-Fierro, Gustav Henning and Frederic Dauod
#

# Exit if not sourced
if [ "$0" == "$BASH_SOURCE" ]; then
  echo >&2 "Setup script has to be sourced, not run with sh. Aborting"
  exit 1
fi

# Create save path file if it is not created
if [ ! -e ~/.sp ] ; then
    touch ~/.sp
fi

# To set up the bashrc script in Windows using cygwin it is necessary to add
# at the beginning of the script to fix a problem with newlines the following:
if [ $(uname -o) == "Cygwin" ]; then
  (set -o igncr) 2>/dev/null && set -o igncr;
fi

echo "
################################################################################
#Hide user name and host in terminal 
#export PS1="\w$ "

#Make ls every time a terminal opens
ls

#cd + ls
function cs () {
    cd \$1
    ls -a
}

#transfer path: save the current path to a hidden file
function tp () {
    pwd > ~/.sp
}

#goto transfer path: goes where the previously saved tp points
function gtp () {
    cs \`cat ~/.sp\`
}

#cat with color
function ccat () {
    source-highlight -fesc -i \$1
}

#Remove trash from terminal and runs program in background
function evince () {
    /usr/bin/evince \$* 2> /dev/null & disown
}
function gedit (){
        /usr/bin/gedit \$* 2> /dev/null & disown
}

# up N: moves N times upwards (cd ../../../{N})
function up () {
  LIMIT=\$1
  P=\$PWD
  for ((i=1; i <= LIMIT; i++))
  do
      P=\$P/..
  done
  cs \$P
  export MPWD=\$P
}

" >> ~/.bashrc

source ~/.bashrc

# if unix & dos2unix exists apply it
if [ $(uname -o) == "Cygwin" ]; then
  if [ command -v dos2unix >/dev/null 2>&1 ]; then
    dos2unix $INTENDED_BASH_PATH
  fi
fi

# Add .bash_profile if it doesn't exist
if [ ! -f ~/.bash_profile ]; then
    echo ".bash_profile not found! Creating..."
    echo "
# include .bashrc if it exists
if [ -f "\$HOME/.bashrc" ]; then
. "\$HOME/.bashrc"
fi
    " > ~/.bash_profile
fi

echo ".bashrc updated"

#!/bin/bash
#
# Set up line number in vim. Tested in Ubuntu and Mac. 
#
# Method of use:
# source setup_vim.sh
#


echo "
set number
" >> ~/.vimrc

echo ".vimrc updated"
#! /bin/bash

# Installation of several packages in an Azure GPU VM. Based on this blog:
# https://blogs.technet.microsoft.com/machinelearning/2016/09/15/building-deep-neural-networks-in-the-cloud-with-azure-gpu-vms-mxnet-and-microsoft-r-server/
#
# To attach an external distk in Azure you can follow this guide: https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-linux-add-disk
#

###################################
# Update and Upgrade
###################################
echo
echo "Updating and upgrading..."
echo
apt-get update && apt-get upgrade -y

###################################
# Add external resources 
###################################
echo
echo "Adding external resources to the environment..."
echo
CUDA_INSTALLER=cuda_8.0.27_linux.run
CUDA_PATCH=cuda_8.0.27.1_linux.run
CUDNN_INSTALLER=cudnn-8.0-linux-x64-v5.1.tgz
ANACONDA_INSTALLER=Anaconda3-4.3.0-Linux-x86_64.sh
RSERVER_INSTALLER=microsoft-r-server-mro-8.0
RSTUDIO_INSTALLER=rstudio-server-1.0.136-amd64.deb
MXNET_VERSION=450141c5293b332948e5c403c689b64f4ce22efd
CNTK_VERSION=CNTK-2-0-beta12-0-Linux-64bit-GPU-1bit-SGD.tar.gz
# Installation forlders
INSTALL_FOLDER=$PWD
#get user even if the script was called with sudo
if [ $SUDO_USER ]; then CURRENT_USER=$SUDO_USER; else CURRENT_USER=`whoami`; fi
INSTALL_HOME=/home/$CURRENT_USER

###################################
# Installations
###################################
echo
echo "Installing programs..."
echo

### compilers and IDEs
apt-get install build-essential cmake cmake-curses-gui gfortran  pkg-config -y
### libraries
apt-get install libboost-all-dev libeigen3-dev libblas-dev liblapack-dev libprotoc-dev libfftw3-dev -y
### python
apt-get install python-numpy python-tk python-matplotlib python-pip  -y
pip install jupyter jinja2 tornado pyzmq scipy scikit-image wget setuptools
### repositories and connections
apt-get install git ssh openssh-server libcurl4-openssl-dev libssl-dev -y
### tools
apt-get install p7zip-rar htop mencoder -y
### opencv
apt-get install libopencv-dev python-opencv -y
### azure client
apt-get install nodejs-legacy -y
apt-get install npm -y
npm install -g azure-cli
azure --completion >> $INSTALL_HOME/.azure.completion.sh
echo 'source ~/.azure.completion.sh' >> $INSTALL_HOME/.bashrc
azure telemetry --disable
azure config mode asm

###################################
# Cleaning
###################################
echo
echo "Cleaning..."
echo
apt-get autoclean

###################################
# GPU drivers, CUDA and CuDNN
###################################
# CUDA can be downloaded: https://developer.nvidia.com/cuda-toolkit
# CuDNN can be downloaded: https://developer.nvidia.com/cudnn
echo
echo "Installing CUDA and CuDNN..."
echo

### CUDA
chmod 755 $CUDA_INSTALLER 
sh $CUDA_INSTALLER --silent --driver --toolkit --override --verbose 
if [ -f "$CUDA_PATCH" ]; then
	echo "Adding CUDA patch"
	sh $CUDA_PATCH --silent --accept-eula 
fi
### CuDNN
if [ -f "$CUDNN_INSTALLER" ]; then
	tar xvzf $CUDNN_INSTALLER
	mv cuda /usr/local/cudnn
	ln -s /usr/local/cudnn/include/cudnn.h /usr/local/cuda/include/cudnn.h
fi
###################################
# Anaconda
###################################
echo
echo "Installing Anaconda..."
echo
wget https://repo.continuum.io/archive/$ANACONDA_INSTALLER
bash $ANACONDA_INSTALLER -b -p $INSTALL_HOME/anaconda3
chown -R $CURRENT_USER:$CURRENT_USER $INSTALL_HOME/anaconda3
echo "export PATH=$INSTALL_HOME/anaconda3/bin:\$PATH" >> $INSTALL_HOME/.bashrc

###################################
# RServer
###################################
# R Server can be downloaded: https://www.microsoft.com/en/server-cloud/products/r-server/default.aspx 

echo
echo "Installing Microsoft R Server"
echo

### R Server
sudo apt-get install libpango1.0-0 -y
wget https://mran.revolutionanalytics.com/install/mro4mrs/8.0.5/$RSERVER_INSTALLER.tar.gz
tar -xvzf $RSERVER_INSTALLER.tar.gz
dpkg -i $RSERVER_INSTALLER/$RSERVER_INSTALLER.deb
mv /usr/lib64/microsoft-r/8.0/lib64/R/deps/libstdc++.so.6 /tmp
mv /usr/lib64/microsoft-r/8.0/lib64/R/deps/libgomp.so.1 /tmp

### R Studio can be downloaded: https://www.rstudio.com/products/rstudio/download-server/
apt-get install gdebi-core
wget https://download2.rstudio.org/$RSTUDIO_INSTALLER
gdebi $RSTUDIO_INSTALLER -n

### R packages
ln -s /bin/gzip /usr/bin/gzip

Rscript -e "install.packages('devtools', repo = 'https://cran.rstudio.com')"
Rscript -e "install.packages(c('scales','knitr','mlbench','zoo','roxygen2','stringr','DiagrammeR','data.table','ggplot2','plyr','manipulate','colorspace','reshape2','digest','RColorBrewer','readbitmap','argparse','png','jpeg','readbitmap'), dependencies = TRUE)"


###################################
# Deep learning libraries
###################################
echo
echo "Installing deep learning libraries"
echo 

### MXNet
read -r -p "Do you want to install MXNet? [y/n] " RESP_MNXET
RESP_MNXET=${RESP_MNXET,,}    # tolower
if [[ $RESP_MNXET =~ ^(yes|y)$ ]]
then
	echo "Installing MXNet with checkout $MXNET_VERSION"
	git clone --recursive https://github.com/dmlc/mxnet.git
	cd mxnet
	git checkout $MXNET_VERSION
	cp make/config.mk .
	sed -i "s|USE_BLAS = atlas|USE_BLAS = mkl|" config.mk
	#TODO: set other options
	export LD_LIBRARY_PATH=/usr/local/cuda/lib64/:/usr/local/cudnn/lib64/:$LD_LIBRARY_PATH
	export LIBRARY_PATH=/usr/local/cudnn/lib64/
	make -j${nproc}
	### MXNet R package
	make rpkg
	R CMD INSTALL mxnet_0.7.tar.gz
	### MXNet python package
	cd python
	sed -i "s|'numpy',|# 'numpy',|" setup.py
	python setup.py install
	PYTHONPATH=$INSTALL_FOLDER/mxnet/python:$PYTHONPATH
	echo "export PYTHONPATH=$PYTHONPATH" >> $INSTALL_HOME/.bashrc
	cd ../..
fi

### CNTK
read -r -p "Do you want to install CNTK? [y/n] " RESP_CNTK
RESP_CNTK=${RESP_CNTK,,}    # tolower
if [[ $RESP_CNTK =~ ^(yes|y)$ ]]
then
	echo "Installing CNTK with checkout $CNTK_VERSION"
	wget https://cntk.ai/BinaryDrop/$CNTK_VERSION
	tar -zxvf $CNTK_VERSION
	sh cntk/Scripts/install/linux/install-cntk.sh --py-version 35
fi
###################################
# Finish!
###################################
echo
echo "Finish! All done!"
echo


#! /bin/bash

# Installation of many packages in a fresh Ubuntu

###################################
# Add repositories
###################################
echo
echo "Installing repositories..."
echo
sudo apt-add-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
sudo add-apt-repository ppa:webupd8team/java
sudo add-apt-repository ppa:ubuntu-x-swat/x-updates # nvidia
sudo add-apt-repository ppa:transmissionbt/ppa
sudo add-apt-repository ppa:jd-team/jdownloader

###################################
# Update and Upgrade
###################################
echo
echo "Updating and upgrading..."
echo
sudo apt-get update && sudo apt-get upgrade -y

###################################
# Remove programs not used
###################################
echo
echo "Removing programs not used..."
echo
sudo apt-get remove hexchat hexchat-common thunderbird thunderbird-gnome-support thunderbird-locale-en  thunderbird-locale-en-us  banshee tomboy pidgin pidgin-libnotify -y

###################################
# Installations
###################################
echo
echo "Installing programs..."
echo

## system
### important
sudo apt-get install tasksel gparted p7zip-rar ntfs-config usbmount -y
### desktop
sudo apt-get remove xscreensaver xscreensaver-data xscreensaver-gl  indicator-multiload -y
sudo apt-get install xdotool gnome-screensaver -y
### nautilus complements
sudo apt-get install nautilus nautilus-dropbox nautilus-open-terminal -y
### java and pdf tools
sudo apt-get install oracle-java7-installer
### pdf tools
sudo apt-get install  acroread cups-pdf -y
## audio, image and video
sudo apt-get install inkscape
### tools
sudo apt-get install mencoder vlc audacious skype brasero -y
### torrent and direct download
sudo apt-get install jdownloader -y

## developing
### compilers and IDEs
sudo apt-get install build-essential gcc-avr avr-libc doxygen doxygen-latex cmake cmake-curses-gui gfortran libgtk2.0-dev pkg-config -y
sudo apt-get install qtcreator qtcreator-plugin-cmake -y
### libraries
sudo apt-get install libboost-all-dev libeigen3-dev libblas-dev liblapack-dev ant -y
### python
sudo apt-get install python-tk python-matplotlib python-pip  -y
sudo easy_install ipython jinja2 tornado pyzmq scipy scikit-image
### repositories
sudo apt-get install git ssh openssh-server filezilla filezilla-common -y
### tools
sudo apt-get install kdiff3-qt vim source-highlight -y
### latex
sudo apt-get install texlive-latex-base texlive-base texlive-latex-extra texlive-font-utils texlive-fonts-recommended texlive-generic-recommended texlive-generic-extra texlive-omega texlive-plain-extra texlive-extra-utils texlive-lang-spanish texlive-lang-english texlive-pictures texlive-math-extra texlive-science -y
sudo apt-get install gedit-plugins/trusty gedit-latex-plugin -y
### web tools
echo "To install LAMP:"
#echo "Launch Synaptic. Edit Menu, Package by task, LAMP Server"
sudo apt-get install php5 -yy
sudo apt-get install mysql-client mysql-server mysql-workbench -y
sudo apt-get install phpmyadmin phpsysinfo -y
###################################
# Cleaning
###################################
echo
echo "Cleaning..."
sudo apt-get autoclean

###################################
# Configuring
###################################
echo
echo "Configuring..."
## java
sudo update-alternatives --config java



###################################
# Finish!
###################################
echo
echo "Finish! All done!"
echo
#!/bin/bash

# An example shell script to clone a repository, install conda environment,
# and create multiple JupyterHub users
#
# Authors:
# Jun Ki Min (https://github.com/loomlike)
# JS Tan (https://github.com/jiata)

cd ~

# clone repo and install the conda env
git clone https://www.github.com/microsoft/computervision
# change permission as we copy this into each user's folder
chmod -R ugo+rwx /root/computervision

source /data/anaconda/etc/profile.d/conda.sh
conda env create -f /root/computervision/environment.yml --name cv
conda activate cv
python -m ipykernel install --name cv

# add 5 users to jupyterhub
echo 'c.Authenticator.whitelist = {"user1", "user2", "user3", "user4", "user5"}' | sudo tee -a /etc/jupyterhub/jupyterhub_config.py

# create the users on the vm
for i in {1..5}
do
    USERNAME=user$i
    PASSWORD=password$i
    sudo adduser --quiet --disabled-password --gecos "" $USERNAME
    echo "$USERNAME:$PASSWORD" | sudo chpasswd
    rm -rf /data/home/$USERNAME/notebooks/*
    # copy repo
    cp -ar /root/computervision /data/home/$USERNAME/notebooks
done

# restart jupyterhub
sudo systemctl stop jupyterhub
sudo systemctl start jupyterhub

exit
#!/bin/bash

# Script for calling function $2 for each directory from text file $1 and 
# $1 is a file containing list of repositories (for example see list_example.txt)
# $2 - command or function name to call for each directory
# $3 - text to show for each directory

if (( $# < 3 )); then
    echo "There must be 3 arguments - file list, function or command to do and text"
    exit
fi

LISTFILE="$1"
CMD="$2"
TEXT="$3"

while read -r line || [ -n "$line" ]; do
    [[ -z "$line" ]] && continue # ignore empty lines
    pushd "$PWD" > /dev/null|| exit 
    cd "${line/#~/$HOME}" || { popd && continue; }
    echo "$TEXT $line"
    $CMD
    popd > /dev/null || exit
done < "$LISTFILE"
#!/bin/bash

# Use it for copying folder with large amount of files via ssh to current folder. It's faster than pure ssh.
# first arguments - address of remote machine (can include user, port and other info)
# last argument - path to directory to copy from remote machine

if (( $# < 2 )); then
    echo "There must be at least 2 arguments - remote address and directory"
    exit
fi

LAST_ARG="${@: -1}"
BASENAME=$(basename "$LAST_ARG")
DIRNAME=$(dirname "$LAST_ARG")
set -- "${@:1:$(($#-1))}"

ssh $* "cd $DIRNAME; tar zcf - $BASENAME" | tar zxf -
#!/bin/bash

# Script for count words and lines in files with defined types
# $1 is a directory where files are located
# other args - extensions of files to process

if (( $# < 2 )); then
    echo "There must be at least 2 arguments - directory and "
    exit
fi

DIR=$1
shift
TYPES=( -name "*.$1")
shift
for ext in "$@"; do
    TYPES+=( -or -name \*."$ext" )
done
find "$DIR" -type f \( "${TYPES[@]}" \) -exec wc {} +
#!/bin/bash
if [ $# -ne 2 ]; then
	echo "Invalid parameters."
	echo "Usage: $0 <group> <cmd> [datetime]"
	exit
fi

ip_list_file=$1
command_to_run=$2

for LINE in `cat ${ip_list_file}`
do
	echo "Searching on $LINE ..."
	ssh $LINE -p 32200 "${command_to_run}"
done
#!/bin/bash

parent_dir=$1
process_uid=$2

dirs=$(ls -l $parent_dir |awk '/^d/ {print $NF}')

printf "%-50s %s\n" "dir from $parent_dir" pid
for dir in $dirs
do
	pid=`ps -ef |grep $dir |awk '/^'''$process_uid'''/ {print $2}'`
	printf "%-50s %s\n" $dir $pid
done
#!/bin/bash
# 请切换为root执行: sudo -s

user=$1
pid=$2
dir=$3
time=`date "+%Y-%m-%d_%H:%M:%S"`
jstack_log=${dir}jstack_${pid}_${time}.log
jstat_log=${dir}jstat_${pid}_${time}.log
jmap_heap_log=${dir}jmap_heap_${pid}_${time}.log
jmap_histolive_log=${dir}jmap_histolive_${pid}_${time}.log
jmap_dump_log=/tmp/jmap_dump_${pid}_${time}.hprof

printf "===========\n"
printf "[jstack]start to log %s\n" $jstack_log
sudo -u $user jstack $pid > $jstack_log
printf "[jstack]finish   log %s\n" $jstack_log

printf "===========\n"
printf "[jstat]start to log %s\n" $jstat_log
sudo jstat -gcutil $pid 1000 10
printf "[jstat]finish   log %s\n" $jstat_log

printf "===========\n"
printf "start to log %s\n" $jmap_heap_log
sudo jmap -heap $pid > $jmap_heap_log
printf "finish   log %s\n" $jmap_heap_log

printf "===========\n"
printf "start to log %s\n" $jmap_histolive_log
sudo -u $user jmap -histo:live $pid > $jmap_histolive_log
printf "finish   log %s\n" $jmap_histolive_log

printf "===========\n"
printf "start to log %s\n" $jmap_dump_log
sudo -u $user jmap -dump:format=b,file=$jmap_dump_log $pid
printf "finish   log %s\n" $jmap_dump_log

