import os
import time
def Menu1():
	os.system("clear")
	print("==================================================")
	print("= Welcome to Aidan's Automatic Enumeration suite =")
	print("==================================================")
	print("\nPlease run 8) Install Dependencies if this is first time\nstart up\n")
	print("1) Enumerate Domain and Subdomains")
	print("2) LLMNR/NBTNS Poisoning w/ password cracking")
	print("7) Help")
	print("8) Install Dependencies")
	print("9) About")
	print("\n")
def Option1():
	os.system("clear")
	print("==================================================")
	print("=        Enumerate Domains and Subdomains        =")
	print("==================================================")
	print("\n")
	print("1) Subdomains")
	print("2) Subdomains, w/ Nmap + EyeWitness")
	print("3) Subdomains + third-level domains")
	print("4) Subdomains + third-level domains, w/ Nmap + EyeWitness")
	print("5) Go Back")
	print("\n")
	selection1 = input("Enter your selection: ")
	if (selection1 == "1"):
		os.system("./EnumDomain.sh --no-scans")
		input("Press any key to return to the main menu...")
		return
	if (selection1 == "2"):
		os.system("./EnumDomain.sh")
		input("Press any key to return to the main menu...")
		return
	if (selection1 == "3"):
		os.system("./EnumDomain.sh --no-scans --third-level")
		input("Press any key to return to the main menu...")
		return
	if (selection1 == "4"):
		os.system("./EnumDomain.sh --third-level")
		input("Press any key to return to the main menu...")
		return
	if (selection1 == "5"):
		return
	print("Invalid Selection")
	time.sleep(2)
	Option1()
def Option2():
	os.system("clear")
	print("==================================================")
	print("=   LLMNR/NBTNS Poisoning w/ password cracking   =")
	print("==================================================")
	print("\n")
	print("Under Construction")
	time.sleep(3)
	os.system("./Poisoner.sh")
	input("Press Enter to go back...")
	return
def Option7():
	os.system("clear")
	print("==================================================")
	print("=                      Help                      =")
	print("==================================================")
	print("\n")
	print("Under Construction")
	print("You can type exit at the main menu to exit the menu")
	input("\nPress Enter to go back...")
	return
def Option8():
	os.system("clear")
	print("==================================================")
	print("=            Installing Dependencies...          =")
	print("==================================================")
	print("\n")
	print("Please run this script as root\n")
	print("Make sure your etc/apt/sources.list file is populated")
	if (str(os.popen("whoami | tr '\n' ','").read()) != "root,"):
		print("You are " + str(os.popen("whoami | tr '\n' ','").read()) + " not root")
		print("Aborting...")
		time.sleep(5)
		return
	time.sleep(2)
	os.system("chmod +x EnumDomain.sh && chmod +x Poisoner.sh")
	os.system("echo 'deb http://http.kali.org/kali kali-rolling main non-free contrib' >> /etc/apt/sources.list")
	os.system("apt install -y --fix-broken sublist3r")
	os.system("apt install -y python3-pip")
	os.system("if [ -d 'EyeWitness' ] ; then rm -r EyeWitness ; fi")
	os.system("git clone https://github.com/FortyNorthSecurity/EyeWitness.git")
	os.system("cd EyeWitness/Python/setup && chmod +x setup.sh && ./setup.sh")
	os.system("cd ../../..")
	os.system("apt install -y responder")
	os.system("apt install -y nmap")
	os.system("apt install -y hashcat")
	finished = input("Finished! Would you like to check if all components installed correctly? [y/n]: ")
	if (finished == "y" or finished == "Y" or finished == "yes" or finished == "Yes" or finished == "YES"):
		working = 0
		if (len(str(os.popen("sublist3r | grep Ahmed").read())) > 0):
			working += 1
			print("Sublist3r is installed properly!")
		else:
			print("Sublist3r did not install properly.")
		if (len(str(os.popen("responder | grep Laurent").read())) > 0):
			working += 1
			print("Responder is installed properly!")
		else:
			print("Responder did not install properly.")
		if (len(str(os.popen("nmap | grep FIREWALL/IDS").read())) > 0):
			working += 1
			print("Nmap is installed properly!")
		else:
			print("Nmap did not install properly.")
		if (len(str(os.popen("python3 EyeWitness/Python/EyeWitness.py | grep FortyNorth").read())) > 0):
			working += 1
			print("EyeWitness is installed properly!")
		else:
			print("EyeWitness did not install properly.")
		if (len(str(os.popen("hashcat | grep hccapxfile").read())) > 0):
			working += 1
			print("Hashcat is installed properly!")
		else:
			print("Hashcat did not install properly.")
		if (len(str(os.popen("pip3 | grep proxy.server:port.").read())) > 0):
			working += 1
			print("pip3 for Python3 is installed properly!")
		else:
			print("Sublist3r did not install properly.")
		print(str(working) + "/6 dependencies installed correctly")
		input("Press Enter to go back to the main menu")
		return
	else:
		time.sleep(1)
		return
def Option9():
	os.system("clear")
	print("==================================================")
	print("=                     About                      =")
	print("==================================================")
	print("\n")
	print("Created by Aidan Rivera")
	print("https://www.linkedin.com/in/aidan-rivera-157090197/")
	print("\n")
	print("This tool is simply an automation suite, I don't claim credit for \n writing any of the underlying security tools used.")
	print("\n")
	input("Press Enter to go back... ")
	return
option = 0
while (option != "exit"):
	Menu1()
	option = input("Enter your selection: ")
	if (option == "1"):
		Option1()
	if (option == "2"):
		Option2()
	if (option == "7"):
		Option7()
	if (option == "8"):
		Option8()
	if (option == "9"):
		Option9()
