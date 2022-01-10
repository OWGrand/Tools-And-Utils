#!/bin/bash
#################################################
### Version	1.0  @V.Zlatkov a.k.a - Xerxes###
#################################################
##### GBC - Git branch cloner script
##### V.1.1
##### v.0.2 - Added a DIRCHECK funct that prevents the script to fail if the ~/GIT dir doesn't exist
##### V.0.3 - Fixed the "$DATE" var to format YY (ex.:22) instead of YYYY (ex.: 2022)
##### V.0.4 - Ready to be used as a cronjob util to create "develop" from RC branches
##### V.0.5 - Debuging done - Translates into version "V.1.0"
##### V.1.0
##### V.1.1 - Redone so you can use the automode to create diferent branches with the same script
##### V.1.2 - Added the manual option


# THOSE ARE THE VARIABLES FOR THE COLORS:
GREEN=`\e[32m`
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
DEPCHECK () {
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
echo "[-D | DEV] - automatic mode created for the purpose to be used in crontab as a weekly job to create dev from RC- branch"
echo "[-R | RC] - automatic mode created for the purpose to be used in crontab as a weekly job to create RC from master branch"
echo "[-m| manual] - <name of the branch you want to clone> <name of the new branch you want to create>"
}

AUTO_DEV () {
	DIRCHECK
	###Declare an array of repos
	declare -a PROJECTS=("repo1" "repo2" "repo3" "repo4" "repo5") 
	rm -rf ~/GIT/$PROJECTS_i
	for PROJECTS_i in "${PROJECTS[@]}"; do
	git clone https://git.repo.com/$PROJECTS_i.git ~/GIT/$PROJECTS_i 
	cd ~/GIT/$PROJECTS_i/
	git fetch -a
	git pull
	git checkout RC-$DATE_RC
	git branch develop-$DATE_DEV
	git push -u origin develop-$DATE_DEV
	done
}

AUTO_RC () {
	DIRCHECK
	###Declare an array of repos
	declare -a PROJECTS=("repo1" "repo2" "repo3" "repo4" "repo5") 
	rm -rf ~/GIT/$PROJECTS_i
	for PROJECTS_i in "${PROJECTS[@]}"; do
	git clone https://git.repo.com/$PROJECTS_i.git ~/GIT/$PROJECTS_i 
	cd ~/GIT/$PROJECTS_i/
	git fetch -a
	git pull
	git checkout master
	git pull
	git branch RC-$DATE_RC
	git push -u origin develop-$DATE_RC
	done
}

MANUAL () {
	echo -e "${GREEN}This is the manual mode, please provide the following values:${ENDCOLOR}"
	echo
	echo
	read -p "$cr${RED}Please provide the repo's name: ${ENDCOLOR}$cr" repo
	echo $cr
	read -p "$cr${RED}Please provide the name of the branch you want to use as a origin : ${ENDCOLOR}$cr" branch_or
	echo $cr
	read -p "$cr${RED}Please provide the name of the branch you want to be created as a clone : ${ENDCOLOR}$cr" branch_clone
	echo $cr
	if [ ! $repo ];then
		git fetch -a
		git checkout $branch_or
		git pull
		git branch $branch_clone
		git pull
		git push -u origin $branch_clone
	else
		DIRCHECK
		rm -rf ~/GIT/$repo
		git clone https://git.repo.com/$repo.git ~/GIT/$repo
		cd ~/GIT/$repo/
		git fetch -a
		git checkout $branch_or
		git pull
		git branch $branch_clone
		git pull
		git push -u origin $branch_clone
	fi
}

###Arg phrasing
case "${1}" in
	-D|DEV) AUTO_DEV
		;;
	-R|RC) AUTO_RC
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

#################################################
### Version	1.0  @V.Zlatkov a.k.a - Xerxes###
#################################################

