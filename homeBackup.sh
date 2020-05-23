#!/bin/bash
BACKUP_PATH=~/backups
SOURCE_PATH=~
DESTINATION_PATH="$PWD"
ARGS="$#"
TODAY="$(date +%Y-%m-%d-%H-%M-%S)"

usage(){

echo "Usage:
-h, --help		display usage
-c, --create		create backup
-r, --restore		restore backup
-b, --backupDir		change backup directory, standard is ~/backups
-s, --sourceDir		change source directory, standard is ~
-d, --destinationDir	change destination directory, standard is $PWD"
exit 0

}

verifyBackupDirectory(){

if [ -d "$BACKUP_PATH" ]; then
	echo "backup directory: $BACKUP_PATH"

elif [ -f "$BACKUP_PATH" ]; then
	echo "Error: backups is a file"
	exit 1

else 
	mkdir "$BACKUP_PATH"
	if [ "$?" = 0 ]; then
		echo "Directory created: $BACKUP_PATH"
	
	else
		echo "Error occured while creating folder"
		exit 1
	fi
fi

}

setBackupDirectory(){

if [ "$ARGS" = 1 ]; then
	read -r -p "Enter path to backup directory " newBackupPath
	BACKUP_PATH="$newBackupPath"/backups
	verifyBackupDirectory "$BACKUP_PATH"
else
	BACKUP_PATH="$1"/backups
	verifyBackupDirectory "$BACKUP_PATH"
fi


echo "Changed backup directory to $BACKUP_PATH"

}

setSourceDirectory(){

if [ "$ARGS" = 1 ]; then
	read -r -p "Enter path to source directory " newSourcePath
	SOURCE_PATH="$newSourcePath"
else
	SOURCE_PATH="$1"
fi
echo "Changed source directory to $SOURCE_PATH"

}

setDestinationDirectory(){

if [ "$ARGS" = 1 ]; then
	read -r -p "Enter path to destination directory " newDestinationPath
	DESTINATION_PATH="$newDestinationPath"
else
	DESTINATION_PATH="$1"	
fi

echo "Changed destination directory to $DESTINATION_PATH"

}

createBackup(){

verifyBackupDirectory
tar --exclude="$BACKUP_PATH" -cvPzf "$BACKUP_PATH/$TODAY""_backup.tgz" "$SOURCE_PATH" > /dev/null
if [ "$?" != 0 ]; then
	echo "Error occured while creating backup"
	exit 1
else 
	echo "Backup created: " "$BACKUP_PATH/$TODAY""_backup.tgz"
	
fi



}

restore(){
if [ "$ARGS" = 1 ]; then
	read -r -p "Enter name of desired archive to restore using the format YEAR-MONTH-DAY-HOUR-MINUTE-SECOND " timestamp
	FILENAME=$timestamp"_backup.tgz"
else
	FILENAME=$1"_backup.tgz"
fi
	if [ -f "$BACKUP_PATH/$FILENAME" ]; then

		tar -xvzf "$BACKUP_PATH/$FILENAME" -C "$DESTINATION_PATH" > /dev/null

		if [ "$?" != 0 ]; then
			echo "Error occured while restoring from archive"
			exit 1
		else 
			echo "Succesfully restored from $FILENAME"
		fi
	else
		echo "File $FILENAME not found in $BACKUP_PATH"
		exit 1
	fi
	
}

flagCombination(){

if [[ "$1" =~ "h" ]]; then
	usage
fi

if [[ "$1" =~ "b" ]]; then
	setBackupDirectory
fi

if [[ "$1" =~ "s" ]]; then
	setSourceDirectory
fi

if [[ "$1" =~ "d" ]]; then
	setDestinationDirectory
fi

if [[ "$1" =~ "c" ]]; then
	createBackup
fi

if [[ "$1" =~ "r" ]]; then
	restore
fi

}

if [ "$ARGS" = 0 ]; then
	usage
elif [ "$ARGS" = 1 ]; then
	case "$1" in
		-h | --help) usage;;
		-b | --backupDir) setBackupDirectory;;
		-s | --sourceDir) setSourceDirectory;;
		-d | --destinationDir) setDestinationDirectory;;
		-c | --create) createBackup;;	
		-r | --restore) restore;;
		*) flagCombination "$1";;
	esac
	exit 0
else
	while [ $# != 0 ]; do
		case "$1" in
			-h | --help) usage;;
			-b | --backupDir) shift
			setBackupDirectory "$1";;
			-s | --sourceDir) shift
			setSourceDirectory "$1";;
			-d | --destinationDir) shift 
			setDestinationDirectory "$1";;
			-c | --create) createBackup;;	
			-r | --restore) shift 
			restore "$1";;
				
		esac
		shift
	done	
fi

echo "Exited with code $?"
