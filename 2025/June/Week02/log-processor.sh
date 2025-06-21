#!/bin/bash

set -euo pipefail

SCRIPT_VERSION="1.0"
SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
LOG_DIR="$SCRIPT_DIR/../logs"
LOG_FILE="$LOG_DIR/$(date +%Y%m%d-%H%M_log-processor.log)"
TARGET_FILE=""

# Ensure we have log directory present
mkdir -p "$LOG_DIR"

# Load helper scripts
source "$(dirname "${BASH_SOURCE[0]}")/../../../helpers/logging.sh"

# Help section
print_usage() {
  # Display help
  echo "This script prints size for logfiles in given directory with option to delete logs older than <N> days"
  echo
  echo "Available flags :"
  echo "  -h|--help         -> Prints help"
  echo "  -d|--delete <N>   -> Delete *.log files older than N days"
  echo "Usage :"
  echo "  log-processor.sh [-h, --help] [-d, --delete] <number of days> <path to directory> "
  echo
}

# Function to print out logs in provided directory and their human readable size
word_count() {
  local directory="$1"
  echo "###################################"
  echo "Printing *.log files in directory : $1"
  echo "###################################"
  for file in $(find $directory -type f -name "*.log" 2>/dev/null);
     do 
        file_size=$(du -b $file | awk '{print $1}')
        echo "Subor : $(basename ${file}) a jeho velkost $(du -hs ${file} | awk '{print $1}')"
  done
}

word_count $1