#!/bin/bash

set -euo pipefail

SCRIPT_VERSION="1.0"
SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
LOG_DIR="$SCRIPT_DIR/../logs"
LOG_FILE="$LOG_DIR/$(date +%Y%m%d-%H%M_word-count.log)"
TARGET_FILE=""

# Ensure we have log directory present
mkdir -p "$LOG_DIR"

# Load helper scripts
source "$(dirname "${BASH_SOURCE[0]}")/../helpers/logging.sh"

# Help section
print_usage() {
  # Display help
  echo "This script counts lines, words and letters in provided file"
  echo
  echo "Available flags :"
  echo "  -h|--help         -> Prints help"
  echo "Usage :"
  echo "  word-count.sh [-h, --help] <path to file>"
  echo
}

# Word count funcion
word_count() {
    if [[ -z "$TARGET_FILE" ]]; then
      log ERROR "Missing required file argument."
      print_usage
      exit1
    fi

    if [[ ! -r "$TARGET_FILE" ]]; then
      log ERROR "Provided file '$TARGET_FILE' does not exist or is not readable."
      exit 1
    else
      wc -l "$TARGET_FILE"
    fi
}

# Collect user provided arguments and validate
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      print_usage
      exit 0
      ;;
    -*)
      log ERROR "Unknown option: $1"
      print_usage
      exit 1
      ;;
    *)
      if [[ -z "$TARGET_FILE" ]]; then
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

word_count "$TARGET_FILE"