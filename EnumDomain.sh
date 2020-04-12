#!/bin/bash
#The basic layout of this script puts the different code for different ways to run the script in separate functions.
#Because running the script with third level domains and all scans enabled is the most complex functionality included in the script,
#That will be the function that I explain fully, and all other functions other than the help function are subsets of the code in thirdlevel()
help () {
echo "Welcome to Aidan's autoenum script, in order to get things running you should have: Nmap, Sublist3r, Python3, and pip3 for python3"
echo "EyeWitness will not work unless you run the setup script in EyeWitness/Python/setup/setup.sh"
echo "Ensure that Nmap and Sublist3r are installed also."
echo "List of switches:"
echo "--help			displays the help menu"
echo "--third-level		scan down to third level domains, much longer scan time"
echo "--no-scans		disables nmap and eyewitness scanning"
exit
}
secondlevel () {
echo "Script: Sublist3r + Nmap + EyeWitness, 2nd level domains, by Aidan Rivera"
echo "Run with --help for more options and list of dependencies"
read -p "Enter the domain: " input
if [ ! -d "Scans" ] ; then mkdir Scans; fi
if [ ! -d "Scans/$input" ] ; then mkdir Scans/$input; fi
sublist3r -d $input -o Scans/$input/sublist3r.txt
echo "Scanning domain and subdomains found with Nmap..."
nmap -T4 -iL Scans/$input/sublist3r.txt -oN Scans/$input/nmapoutput.txt
clear
cat Scans/$input/nmapoutput.txt | grep -v "Failed to resolve" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | tr " " "\n" | sort -u >> Scans/$input/EWIPS.txt
python3 EyeWitness/Python/EyeWitness.py -d Scans/$input/EyeWitness --prepend-https --threads 3 -f Scans/$input/EWIPS.txt
rm geckodriver.log
clear
echo "Sorting results into a neat format..."
echo "====================================="
cat Scans/$input/nmapoutput.txt | grep -v "Failed to resolve"
echo "====================================="
cat Scans/$input/sublist3r.txt
echo "====================================="
echo "Don't forget to check out the screenshots in Scans/$input/EyeWitness/screens !"
exit
}

#Due to the many if statements at the bottom of the scripts, the thirdlevel function well be executed when the script is run with the --third-level option.

thirdlevel () {
echo "Script: Sublist3r + Nmap + EyeWitness, 3rd level domains, by Aidan Rivera"
echo "Run with --help for more options and list of dependencies"

#read is equivalent to "cin >> variable" in C++. It stores user input in a varible, and with the -p switch, it allows for prompts.

read -p "Enter the domain: " input

#if statements in bash can be written in all one line which makes organization easy. What is happening here is IF the directory (-d) does NOT (!) exist, then mkdir Scans, fi=end the if statement

if [ ! -d "Scans" ] ; then mkdir Scans; fi

#The same thing happens in the next line but the program is checking to see if the folder Scans/$input exists, and if not, the script makes it. This allows for easy organization of scripts by domain name.

if [ ! -d "Scans/$input" ] ; then mkdir Scans/$input; fi

#This next line runs sublist3r, with the -d switch to specify the domain, which is the user $input. The -o is a sublist3r switch that allows us to save the output to a file, so sublist3r.txt is specified in Scans/$input/sublist3r.txt

sublist3r -d $input -o Scans/$input/sublist3r.txt

#Here the script deviates from some of the others and makes a new folder called thirdlevels under the Scans/$input directory.

mkdir Scans/$input/thirdlevels

#Next the script cats out the contents of the output of sublist3r, which scanns first and second level domains, into final .txt. > makes a new file in bash, and >> will make a new file if one does not exist, but will append information to the end of the file if it already exists instead of overwriting the file like >.

cat Scans/$input/sublist3r.txt >> Scans/$input/final.txt

#Here we go, so this is a for loop in bash. So this is basically saying, for domain, or for every line of text in the output of the command cat sublist3r.txt, for every line in it, do something.
#The thing that is done is it takes the line of output, and it feeds it into sublist3r as the domain after the -d switch. The -o switch in the command ensures that if there is output it will go in the thirdlevels folder created earlier.
#After each time it does this, it will cat out the contents of the thirdlevels output and append them to the end of final.txt. Essentially we scan every domain in sublist3r.txt and add the unique results of that scan to the end of final.txt, which started out originally as a copy of sublist3r.txt
#After the for loop has ran through every domain in sublist3r.txt, the loop will be finished.

for domain in $(cat Scans/$input/sublist3r.txt) ; do sublist3r -d $domain -o Scans/$input/thirdlevels/$domain; cat Scans/$input/thirdlevels/$domain >> Scans/$input/final.txt; done

#Now that we have second level domains and third level domains in final.txt, it's time to scan them with nmap.
#The nmap -iL switch allows us to import a list, and scan from it.
#While nmap scans every domain in the list many will not resolve to dns, and that is because many are not up anymore.
#They are old websites or old domains found with search engines or ssl certs that just don't exist anymore.

echo "Scanning domain and subdomains found with Nmap..."
nmap -T4 -iL Scans/$input/final.txt -oN Scans/$input/nmapoutput.txt
clear

#Because many hosts will fail to resolve, when we look for useful information inside of the nmapoutput.txt we are not interested in hosts that failed to resolve.
#We can cat out the nmapoutput.txt then pipe it into a reverse grep to remove all lines with "Failed to resolve".
#This effectively purges hosts that are not alive from our nmap output and keeps only useful hosts inside of it.
#Next this output is actually piped back into grep and this time we grep for a regular expression.
#Regular expressions for certain things can be easily found on google, and this regular expression will only return ip addresses.
#Next we pipe the ip addresses into a tr or transform command in order to remove the spaces between IP address and turn them into new lines. This is just formatting the output into a list format so that eyewitness can use it.
#Sometimes different domains or dns entries will resolve to the same IP address, in that case we don't want duplicate IP addresses for eyewitness.
#The sort -u, or sort unique command will ensure that there are no duplicate ip addresses in the output.
#Finally the output is moved into a text file named EWIPS.txt

cat Scans/$input/nmapoutput.txt | grep -v "Failed to resolve" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | tr " " "\n" | sort -u >> Scans/$input/EWIPS.txt

#here we run eyewitness and set a directory for eyewitness to dump the scan report into. We use 3 threads so it goes faster and use -f to import the IP addresses we just put into EWIPS.txt as targets.

python3 EyeWitness/Python/EyeWitness.py -d Scans/$input/EyeWitness --prepend-https --threads 3 -f Scans/$input/EWIPS.txt

#When eyewitness runs it makes this annoying log file in the directory the script was run in so this isn't good for organization. Here I just use the rm command to delete it since it appears trivial and I want it out of the way

rm geckodriver.log
clear

#Finally we just have some simple formatting with echo, the equivalent of print in bash more or less.
#The outputs of the thirdlevel domains found and the output of nmap are shown to the user in a neat format at the end.
#The script reminds the user to check out the screenshots taken by eyewitness of alive hosts and give the path to them.

echo "Sorting results into a neat format..."
echo "====================================="
cat Scans/$input/nmapoutput.txt | grep -v "Failed to resolve"
echo "====================================="
cat Scans/$input/final.txt
echo "====================================="
echo "Don't forget to check out the screenshots in Scans/$input/EyeWitness/screens !"
exit
}
secondlevelnoscans () {
echo "Script: Sublist3r, 2nd level domains, by Aidan Rivera"
echo "Run with --help for more options and list of dependencies"
read -p "Enter the domain: " input
if [ ! -d "Scans" ] ; then mkdir Scans; fi
if [ ! -d "Scans/$input" ] ; then mkdir Scans/$input; fi
sublist3r -d $input -o Scans/$input/sublist3r.txt
echo "Output saved to Scans/$input/sublist3r.txt"
exit
}
thirdlevelnoscans () {
echo "Script: Sublist3r, 3rd level domains, by Aidan Rivera"
echo "Run with --help for more options and list of dependencies"
read -p "Enter the domain: " input
if [ ! -d "Scans" ] ; then mkdir Scans; fi
if [ ! -d "Scans/$input" ] ; then mkdir Scans/$input; fi
sublist3r -d $input -o Scans/$input/sublist3r.txt
mkdir Scans/$input/thirdlevels
cat Scans/$input/sublist3r.txt >> Scans/$input/final.txt
for domain in $(cat Scans/$input/sublist3r.txt) ; do sublist3r -d $domain -o Scans/$input/thirdlevels/$domain; cat Scans/$input/thirdlevels/$domain >> Scans/$input/final.txt; done
cat Scans/$input/final.txt
echo "Output saved to Scans/$input/final.txt"
exit
}

#Here is a bunch of disgusting logic that allows for the switches to work when the command is run
#It also gives errors for when the user supplies bad switches to the script.
#The way Bash handles switches or arguments is by assigning them to the variables $1, $2, $3, etc.
# The variable $# is a variable that is a number, and it will represent the number of switches passed to the script.


if [ $# -gt 2 ] ; then echo "Too many arguments [$#]" ; exit ; fi
if [ "$1" == "--help" ] && [ $# -gt 1 ] ; then echo "Invalid combination of switches, use --help by itself." ; exit ; fi
if [ "$1" != "--help" ] && [ "$1" != "--third-level" ] && [ "$1" != "--no-scans" ] && [ $# -gt 0 ] ; then echo "Invalid argument, try ./run.sh --help" ; exit ; fi
if [ "$2" != "--help" ] && [ "$2" != "--third-level" ] && [ "$2" != "--no-scans" ] && [ $# -eq 2 ] ; then echo "Invalid argument, try ./run.sh --help" ; exit ; fi
if [ "$1" == "--help" ] && [ "$#" == "1" ] ; then help ; fi
if [ "$1" == "--third-level" ] && [ $# -lt 2 ]; then thirdlevel ; fi
if [ "$1" == "--no-scans" ] && [ $# -lt 2 ] ; then secondlevelnoscans ; fi
if [ "$1" == "--no-scans" ] && [ "$2" == "--third-level" ] ; then thirdlevelnoscans ; fi
if [ "$2" == "--no-scans" ] && [ "$1" == "--third-level" ] ; then thirdlevelnoscans ; fi
if [ "$#" == "0" ] ; then secondlevel ; fi
