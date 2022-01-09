#!/bin/bash

##### GBC - Git branch cloner script
##### V.0.1

# THOSE ARE THE VARIABLES FOR THE COLORS:
GREEN="\e[32m"
RED="\e[31m"
ENDCOLOR="\e[0m"

# Get a carriage return into `cr`
cr=`echo $'\n.'`
cr=${cr%.}

###This var provides the date in YY/MM/DD format as needed for the branch naming convention. Should be used on the day the branches must be created
DATE=`printf '%(%Y-%m-%d)T\n' -1` ###Example "git checkout develop-$DATE" on 1st of Feb 2023 would result on swithcing to branch "develop-23-02-01"

###Check dependencies
#Check if git is present on the system
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

###Declare an array of repos
declare -a PROJECTS=("vidar" "baldur" "dagur" "odin-service" "payment-service") ###Should create an array for the projects' URLs?!?

###Arguments
#Help
PRINT_HELP () {
echo "Syntax: $0: "
echo "[-a | auto] - automatic mode created for the purpose to be used in crontab as a weekly job"
echo "[-m| manual] - <name of the branch you want to clone> <name of the new branch you want to create>"
}

AUTO () {
	mkdir ~/GIT
	for $PROJECTS_i in "${PROJECTS[@]}"; do
	rm -rf ~/GIT/$PROJECTS_i
	git clone https://git.pronetdev.com/$PROJECTS_i.git ~/GIT/ ###I HAVE TO CHECK THE CORRECT URL NAMING CONVENTION!
	git --git-dir=~/GIT/$PROJECTS_i/.git
	git fetch -a
	git pull
	git checkout -b develop-$DATE ###WOULD WORK IF THE RC BRANCH IS CREATED ON THE SAME DATE WHICH IS NOT THE CASE
}
MANUAL () {
###TBA
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




