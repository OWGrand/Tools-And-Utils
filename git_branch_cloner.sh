#!/bin/bash

##### GBC - Git branch cloner script
##### V.0.4
##### v.0.2 - Added a DIRCHECK funct that prevents the script to fail if the ~/GIT dir doesn't exist
##### V.0.3 - Fixed the "$DATE" var to format YY (ex.:22) instead of YYYY (ex.: 2022)
##### V.0.4 - Ready to be used as a cronjob util to create "develop" from RC branches

# THOSE ARE THE VARIABLES FOR THE COLORS:
GREEN="\e[32m"
RED="\e[31m"
ENDCOLOR="\e[0m"

# Get a carriage return into `cr`
cr=`echo $'\n.'`
cr=${cr%.}

###This var provides the date in YY/MM/DD format as needed for the branch naming convention. Should be used on the day the branches must be created
DATE_DEV=`date +%y-%m-%d` #For "develop-YY-MM-DD"
DATE_RC=`date -d "yesterday" '+%y-%m-%d'` #For "RC-YY-MM-DD"


###~/GIT dir check
DIRCHECK () {
if [ ! -d "~/GIT" ];
then
mkdir ~/GIT
fi
}

###Check dependencies
#Check if git is present on the system
DEP_CHECK () {
git_check=$(whereis git | cut -d' ' -f2)
if [ ! -x "$git_check" ];
then
echo "$0: GIT is not available on this machine! Do you want to install it?"
read -p "y/n" choice1
if [ $choice1 -eq "y" ]; then

#Declaring the most common package managers!
declare -a arr=("yum" "pakman" "apt")

#For loop that checks which is the correct one
for i in "${arr[@]}"; do
	echo which $i 2> /dev/null
done

#This is an "if" statement to determine the package manager

if [ $? -eq 0 ]
then echo "The package in use is $i"
fi


#The initialization starts from here
$i -y update
$i -y upgrade
$i -y install git

exit
fi
fi
}

###Arguments
#Help
PRINT_HELP () {
echo "Syntax: $0: "
echo "[-a | auto] - automatic mode created for the purpose to be used in crontab as a weekly job"
echo "[-m| manual] - <name of the branch you want to clone> <name of the new branch you want to create>"
}

AUTO () {
	DIRCHECK
	rm -rf ~/GIT/$PROJECTS_i
	###Declare an array of repos
	declare -a PROJECTS=("vidar" "baldur" "dagur" "odin-service" "payment-service") ###Should create an array for the projects' URLs?!?
	for PROJECTS_i in "${PROJECTS[@]}"; do
	git clone https://git.pronetdev.com/sbbackend/$PROJECTS_i.git ~/GIT/$PROJECTS_i ###I HAVE TO CHECK THE CORRECT URL NAMING CONVENTION!
	git --git-dir="~/GIT/$PROJECTS_i/.git"
	git fetch -a
	git pull
	git checkout RC-$DATE_RC
	git branch develop-$DATE_DEV
	done
}

MANUAL () {
echo TBA
}

###Arg phrasing
case "${1}" in
	-a|auto) AUTO
		;;
	-m|manual) MANUAL
		;;
	--help|-h) PRINT_HELP
		;;
	*) echo -e "${RED}invalid or missing argument${ENDCOLOR}"
		PRINT_HELP
		exit
		;;
esac




