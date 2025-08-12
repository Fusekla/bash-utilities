#!/bin/bash

set -euo pipefail

SCRIPT_VERSION="1.0"
SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
LOG_DIR="$SCRIPT_DIR/../logs"
LOG_FILE="$LOG_DIR/$(date +%Y%m%d-%H%M_log-processor.log)"
TARGET_DIR=""
FILE_SIZE_THRESHOLD="104857600" # 100M by default
RETENTION=""

# Font colors
NC='\033[0m' # No Color
RED='\033[0;31m'

# Ensure we have log directory present
mkdir -p "$LOG_DIR"

# Load helper scripts
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logging.sh"

# Help section
print_usage() {
  # Display help
  echo "This script prints size for logfiles in given directory with option to delete logs older than <N> days"
  echo
  echo "Available flags :"
  echo "  -h|--help         -> Prints help"
  echo "  -d|--delete <N>   -> Delete *.log files older than <N> days"
  echo "  -s|--size <N>     -> Highlight files larger than <N> MB"
  echo "  -v|--version      -> Prints script version"
  echo "Usage :"
  echo "  log-processor.sh [-h, --help] [-d, --delete <number of days>] [-s, --size <size in MB>] <path to directory>"
  echo
}

# Function to print out logs in provided directory and their human readable size
print_logs() {  
  local directory="$1"
  echo "###################################"
  echo "Printing *.log files in directory : $1"
  echo "Highlighting files larger than $(( ${FILE_SIZE_THRESHOLD}/1024/1024 ))MB"
  if [[ -z ${RETENTION} ]]; then
    echo "Deleting logs older than ${RETENTION} days"
  fi
  echo "###################################"
  for file in $(find $directory -type f -name "*.log" 2>/dev/null);
     do 
        file_size=$(du -b $file | awk '{print $1}')
        if [[ $file_size -gt ${FILE_SIZE_THRESHOLD} ]]; then
            echo -e "${RED}Subor : $(basename ${file}) a jeho velkost je $(du -hs ${file} | awk '{print $1}').${NC}"
        else
            echo -e "Subor : $(basename ${file}) a jeho velkost je $(du -hs ${file} | awk '{print $1}')."
        fi
  done
}

# Collect user provided arguments and validate
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      print_usage
      exit 0
      ;;
    -v|--version)
      echo "$SCRIPT_VERSION"
      exit 0
      ;;
    -s|--size)
      FILE_SIZE_THRESHOLD=$1
      shift
      ;;
    -d|--delete)
      RETENTION=$2
      shift
      ;;
    -*)
      log ERROR "Unknown option: $1"
      print_usage
      exit 1
      ;;
    *)
      if [[ -z "$TARGET_DIR" ]]; then
        TARGET_DIR="$1"
      else
        log ERROR "Only one file argument is allowed."
        print_usage
        exit 1
      fi
      shift
      ;;
  esac
done

if [[ ! -r "$TARGET_DIR" ]]; then
  log ERROR "Provided directory '$TARGET_DIR' does not exist or is not readable."
  exit 1
fi

print_logs "$TARGET_DIR"