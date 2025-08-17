#!/bin/bash

set -euo pipefail

export LC_ALL=C

SCRIPT_VERSION="1.0"
SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
LOG_DIR="$SCRIPT_DIR/../logs"
LOG_FILE="$LOG_DIR/$(date +%Y%m%d-%H%M_topN.log)"
TARGET_FILE="$SCRIPT_DIR/../examples/sample.txt"
TOPN_WORDS="10" # 10 by default

mkdir -p $LOG_DIR

# Load helper scripts
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logging.sh"

# Help section
print_usage() {
  echo "This script prints top <N> (defaults to 10) most used words in provided file"
  echo
  echo "Available flags :"
  echo "  -h|--help         -> Prints help"
  echo "  -n|--number <N>   -> Count of most used words (default: 10)"
  echo "  -v|--version      -> Prints script version"
  echo "Usage :"
  echo "  topN.sh [-h, --help] [-n, --number <count of top words>] <path to file>"
  echo
}

count_words() {
  # Streamed pipeline, no giant variables, no temp files
  tr -cd '[:alpha:][:space:]' < "$TARGET_FILE" \
  | tr '[:upper:]' '[:lower:]' \
  | sed 's/[[:space:]]\+/\n/g' \
  | sed '/^$/d' \
  | sort \
  | uniq -c \
  | sort -rn \
  | head -n "$TOPN_WORDS"
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
    -n|--number)
      if [[ -n "$2" ]] && [[ $2 =~ ^[0-9]+$ && "$2" -gt 0 ]]; then
        TOPN_WORDS=$2
      else
        echo "Word count must be numeric value greater than 0; aborting."
        print_usage
        exit 2
      fi
      shift 2
      ;;
    *)
      if [[ -f "$1" ]]; then
        TARGET_FILE="$1"
      else
        echo "Provided file '"$1"' does not exist; aborting."
        print_usage
        exit 2
      fi
      shift
      ;;
  esac
done

if [[ ! -r "$TARGET_FILE" ]]; then
  log ERROR "Provided file '$TARGET_FILE' does not exist or is not readable."
  exit 1
fi

count_words