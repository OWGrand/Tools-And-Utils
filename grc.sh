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
PRINT_HELP () {
echo "Syntax: $0 [repo/project name] <Additional args> <Action args>"
echo "-- Additional args:"
echo "[-t | task] [task name in capital letters] [Action args]"
echo "[-b | backup] <branch name> - clones the repo and pulls the feature branch for a local safekeeping in '~/' or 'C:\Users'"
echo "-- Adction args"
echo "[-l | list] lists all the branches related to this task"
echo "[-p | print]
}
