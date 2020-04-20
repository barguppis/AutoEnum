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
	print("3) Mitm6, DNS Takeover + ntmlrelayx attack")
	print("4) Crackmapexec automation coming soon")
	print("7) Help")
	print("8) Install Dependencies")
	print("9) About")
	print("10) Update")
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
	os.system("chmod +x Poisoner.sh && ./Poisoner.sh")
	input("Press Enter to go back...")
	return
def Option3():
	os.system("clear")
	print("==================================================")
	print("=     Mitm6, DNS Takeover + ntmlrelayx attack    =")
	print("==================================================")
	print("\nUnder Construction")
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
	os.system("chmod +x setup.sh")
	os.system("./setup.sh")
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
	print("This tool is simply a collection of automation scripts I created, I don't claim credit for \n writing any of the underlying security tools used.")
	print("\n")
	input("Press Enter to go back... ")
	return

def Option10():
	os.system("chmod +x update.sh")
	os.system("./update.sh")
	option = "exit"
option = 0
while (option != "exit"):
	Menu1()
	option = input("Enter your selection: ")
	if (option == "1"):
		Option1()
	if (option == "2"):
		Option2()
	if (option == "3"):
		Option3()
	if (option == "7"):
		Option7()
	if (option == "8"):
		Option8()
	if (option == "9"):
		Option9()
	if (option == "10"):
		option = "exit"
		Option10()
