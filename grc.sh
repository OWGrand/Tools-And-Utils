#!/bin/bash

##### This script is created in ordeer to allow you to automate the cleanup of remote branches.
##### V.0.3
#####Removed git check since it won't find "whereis" on Windows' GIT bash
#####Added git check again for usage on linux machines
#####Added OS/Distro check

# THOSE ARE THE VARIABLES FOR THE COLORS:
GREEN="\e[32m"
RED="\e[31m"
ENDCOLOR="\e[0m"

# Get a carriage return into `cr`
cr=`echo $'\n.'`
cr=${cr%.}

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
#$i -y update
#$i -y upgrade
$i -y install git

exit
fi
fi

###Arguments
#Help
PRINT_HELP () {
echo "Syntax: $0: "
echo "[-l | list] <path to your local repo> <name of the task> - lists and sort all the remote branches related to this task for the repo/project"
echo "[-r | remove] <path to your local repo> <list with branches>"
echo "[-b | backup] <path to your local repo> <name of the branch> - checks out and coppies the feature branch for a local safekeeping in '~/' or 'C:\Users'"
#echo "-- Adction args"
#echo "[-p | print] <path to the save destination> - saves a file with the existing branch names" 
}

LIST () {
	cd $2
	git branch -r | grep *"$3"* && 1>list.txt
}
REMOVE () {
	cd $2
	for line in `cat "$3"`; do
		git push origin --delete $line
	done
}
#BACKUP () {
#}

###Arg phrasing
case "${1}" in
	-l|list) LIST
		;;
	-r|remove) REMOVE
		;;
	--help|-h) PRINT_HELP
		;; 
	*) echo -e "${RED}invalid or missing argument${ENDCOLOR}" 
		PRINT_HELP
		exit
		;;
esac
