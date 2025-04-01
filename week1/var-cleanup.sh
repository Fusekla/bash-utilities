#!/bin/bash

# VARIABLES
WORK_DIR=$(pwd)
LOG_DIR=$(pwd)
LOG_FILE=$(date +%Y%m%d-%H%M_var-cleanup.log)
TARGET_DIR=/var/log
RETENTION=$1

# FLOW
# check retention validity (must be >=0)

if [[ $RETENTION =~ ^[0-9]+$ ]]; then
   echo "${RETENTION} is a number"
else
   echo "Please provide a valid number as retention period, aborting."
   exit 1
fi

# obtain list of files in target directory that are older than [user input]
FILE_LIST=$(find $TARGET_DIR -type f -mtime +$RETENTION)
echo $FILE_LIST | xargs ls -la

# ask user about desired action
function user_choice() {
printf "You are about to delete $FILE_COUNT files. Do you wish to : [d]elete, [p]rint list, [a]bort\n"
read choice
}

# perfrom action picked by user, if deleting or printing files, log targeted files in logfile
while true; do
  user_choice

  case $choice in
  a)
    echo "Aborting..."
    exit 0
    break
    ;;
  d)
    echo "Deleting $FILE_COUNT files..."
    for file in $FILE_LIST; do
      echo "deleting file $file" | tee $LOG_FILE
      rm $file
    done
    break
    ;;
  p)
    echo "Printing files..."
    for file in $FILE_LIST; do
      echo "printing file $file" | tee -a $LOG_FILE
    done
    break
    ;;
  *)
    echo "Input not recognized, please retry"
    user_choice
    ;;
  esac

done
