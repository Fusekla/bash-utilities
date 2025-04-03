#!/bin/bash

set -euo pipefail

# Set default variable values
SCRIPT_VERSION="1.1"
WORK_DIR=$(pwd)
LOG_DIR=$(pwd)
LOG_FILE=$(date +%Y%m%d-%H%M_var-cleanup.log)
TARGET_DIR=/home/miro-dev/the-plan/week1/sample-dir
RETENTION=7
FILE_COUNT=""
DRY_RUN=false
MAXDEPTH=""

# Help section
Help() {
  # Display help
  echo "This script deletes files older than user defined retention in target folder"
  echo
  echo "Available flags :"
  echo "  -h   -> Prints help"
  echo "  -r   -> Set retention period (default : 7 days)"
  echo "  -d   -> Dry run"
  echo "  -p   -> Path for cleanup (default : /var/log)"
  echo "  -e   -> Exclude all subfolders"
  echo "Usage :"
  echo "  var-cleanup.sh [-h|r|d|p|e]"
  echo
}

log() {
  local level="$1"; shift
  local message="$@"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" | tee -a "$LOG_FILE"
}

UserChoice() {
   printf "You are about to delete $FILE_COUNT files. Do you wish to : [d]elete, [a]bort\n"
   read choice
}

DoTheThing() {
   # obtain list of files in target directory that are older than [user input]
   mapfile -t FILE_LIST < <(find "$TARGET_DIR" $MAXDEPTH -type f -mtime +$RETENTION)
   # echo "====="
   echo $FILE_LIST
   # echo "====="
   FILE_COUNT=${#FILE_LIST[@]}
   # echo "====="
   # echo $FILE_COUNT
   # echo "====="

   if [ $DRY_RUN == true ]; then
      log INFO "Running var-cleanup.sh version $SCRIPT_VERSION"
      log INFO "We are doing dry run, NO FILES ARE ACTUALLY DELETED!"
      log INFO "We found $FILE_COUNT files that match desired retention period in "$TARGET_DIR":"
      for file in "${FILE_LIST[@]}"; do
         ls -la $file
      done
      exit 0
   fi

   while true; do
      UserChoice  

      case $choice in
         a)
            echo "Aborting..."
            exit 0
            ;;
         d)
            log INFO "Running var-cleanup.sh version $SCRIPT_VERSION"
            log INFO "Deleting $FILE_COUNT files..."
            for file in "${FILE_LIST[@]}"; do
               log INFO "deleting file $file"
            done
            exit 0
            ;;
         *)
            echo "Please pick [d]elete, [a]bort"
            echo
            UserChoice
            ;;
      esac 
   done 
}

while getopts "r:hp:de" option; do
  case $option in
    h) # Display help page
       Help
       exit;;
    e) # Set maxdepth to exclude subfolders
       MAXDEPTH="-maxdepth 1";;
    r) # Define retention period
       if [[ ${OPTARG} =~ ^[0-9]+$ ]]; then
         RETENTION=${OPTARG}
         # echo "${RETENTION} is a valid number"
       else
        echo "Please provide a valid number as retention period, aborting."
        exit 1
       fi;;
    p) # Define path to cleanup
       if [[ -d ${OPTARG}  ]]; then
         TARGET_DIR=${OPTARG}
         # echo "${TARGET_DIR} is a valid directory"
       else
        echo "Please provide a valid target directory, aborting."
        exit 1
       fi;;
    d) # Perform dry run
       DRY_RUN=true
       DoTheThing
       exit;;
    \?) # Invalid option
       echo "Error : Invalid option"
       exit;;
  esac
done

DoTheThing
