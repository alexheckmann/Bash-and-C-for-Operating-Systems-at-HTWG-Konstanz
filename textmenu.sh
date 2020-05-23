#!/bin/bash
helloWorld() {
echo helloWorld	
menuInput
}

printUsage() {
echo "	Illegal option
	usage: checkfile -d|-f <NAME>
	Verify the existence of the passed file or directory <NAME> 
	
	-d check a directory
	-f check a regular file"

	menuInput
}

checkFile() {
read -p "What would you like to check? " name arg
if [ $arg == "-f" ]; then
 	if [ -d $name ]; then
		echo "$name is not a regular file."
	elif [ -f $name ]; then
		echo "File $name found"
	else 
		printUsage
	fi

elif [ $arg == "-d" ]; then
	if [ -d $name ]; then
		echo "Directory $name found"
	elif [ -f $name ]; then
		echo "$name is not a directory."
	else
		printUsage
	fi

else
	printUsage
fi

menuInput
}

printMenu() {
echo "-------------------
h hello world
u print usage
c check file
m print menu
e exit
-------------------"
menuInput
}

menuInput(){
read -p "Please enter what you would like to execute: " letter
	case $letter in
		h) helloWorld;;
		u) printUsage;;
		c) checkFile;;
		m) printMenu;;
		e) exit;;
		*) menuInput

	esac
}

menuInput
