#!/bin/bash
echo "=================================================="
echo "=            Installing Dependencies...          ="
echo "=================================================="
echo "Please run this script as root"
echo "Make sure your etc/apt/sources.list file is populated"
if [ $(whoami) != "root" ] ; then echo "You are running as $(whoami), not root" ; echo "Aborting..." ; sleep 5 ; exit ; fi
sleep 5
chmod +x EnumDomain.sh && chmod +x Poisoner.sh
echo 'deb http://http.kali.org/kali kali-rolling main non-free contrib' >> /etc/apt/sources.list
apt install -y sublist3r
apt install -y python3-pip
if [ -d 'mitm6' ] ; then rm -r mitm6 ; fi
git clone https://github.com/fox-it/mitm6.git
cd mitm6 && pip3 install -r requirements.txt && python3 setup.py install
cd ..
if [ -d 'mitm6' ] ; then rm -r mitm6 ; fi
if [ -d 'EyeWitness' ] ; then rm -r EyeWitness ; fi
git clone https://github.com/FortyNorthSecurity/EyeWitness.git
cd EyeWitness/Python/setup && chmod +x setup.sh && ./setup.sh
cd ../../..
apt install -y responder
apt install -y nmap
apt install -y hashcat
apt install -y crackmapexec
if [ -d 'impacket' ] ; then rm -r impacket ; fi
git clone https://github.com/SecureAuthCorp/impacket.git
cd impacket && pip3 install -r requirements.txt && python3 setup.py install
cd ..
read -p "Finished! Would you like to check if all components installed correctly? [y/n]: " finished
if [ $finished == "y" ] || [ $finished == "Y" ] || [ $finished == "yes" ] || [ $finished == "Yes" ] || [ $finished == "YES" ] ;
then	
if [ $(sublist3r | grep Ahmed | wc -m) -gt 0 ] ; then ((working++)) && echo "Sublist3r is installed properly!" ; else echo "Sublist3r did not install properly." ; fi
if [ $(responder | grep Laurent | wc -m) -gt 0 ] ; then ((working++)) && echo "Responder is installed properly!" ; else echo "Responder did not install properly." ; fi
if [ $(nmap | grep FIREWALL/IDS | wc -m) -gt 0 ] ; then ((working++)) && echo "Nmap is installed properly!" ; else echo "Nmap did not install properly." ; fi
if [ $(python3 EyeWitness/Python/EyeWitness.py | grep FortyNorth | wc -m) -gt 0 ] ; then ((working++)) && echo "EyeWitness is installed properly!" ; else echo "EyeWitness did not install properly." ; fi
if [ $(hashcat | grep hccapxfile | wc -m) -gt 0 ] ; then ((working++)) && echo "Hashcat is installed properly!" ; else echo "Hashcat did not install properly." ; fi
if [ $(pip3 | grep proxy.server:port. | wc -m) -gt 0 ] ; then ((working++)) && echo "pip3 for Python3 is installed properly!" ; else echo "Sublist3r did not install properly." ; fi
if [ $(mitm6 --help | grep ignore-nofqdn | wc -m) -gt 0 ] ; then ((working++)) && echo "mitm6 is installed properly!" ; else echo "mitm6 is not installed properly" ; fi
if [ $(python3 impacket/examples/ntlmrelayx.py --help | grep delegate-access | wc -m) -gt 0 ] ; then ((working++)) && echo "impacket is installed properly!" ; else echo "impacket is not installed properly." ; fi
if [ $(crackmapexec | grep '{winrm,mssql,http,smb,ssh}' | wc -m) -gt 0 ] ; then ((working++)) && echo "crackmapexec is installed properly!" ; else echo "crackmapexec is not installed properly." ; fi
echo "$working/9 dependencies installed correctly"
fi
read -p "Press Enter to return to the main menu"
