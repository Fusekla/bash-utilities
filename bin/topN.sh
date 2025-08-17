#!/bin/bash

set -euo pipefail

SCRIPT_VERSION="1.0"
SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
LOG_DIR="$SCRIPT_DIR/../logs"
LOG_FILE="$LOG_DIR/$(date +%Y%m%d-%H%M_topN.log)"
TARGET_FILE="test.txt"
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
      TOPN_WORDS=$1
      shift
      ;;
    *)
      if [[ -f "$TARGET_FILE" ]]; then
        TARGET_FILE="$1"
      else
        log ERROR "Only one file argument is allowed."
        print_usage
        exit 1
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