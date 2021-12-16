#!/bin/bash

##### This script is created in ordeer to allow you to automate the cleanup of remote branches.
##### V.0.1

###Check dependencies
#Check if git is present on the system
which git 1>/dev/null
if [ $? != 0 ];
then
echo "GIT is not available on this machine!"
exit
fi

###Arguments
#Help
print_help () {
	echo "Syntax: $0 [task name] <Additional args>"
	echo "Additional args:"
	
}
