#!/bin/bash
set -euo pipefail

SCRIPT_VERSION="1.0"
SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
REPORT_DIR="$SCRIPT_DIR/../logs"
TIMESTAMP=$(date +%Y%m%d-%H%M)
REPORT_FILE="$REPORT_DIR/errors.log"

mkdir -p "$REPORT_DIR"

print_usage() {
  echo "Usage: $0 <logfile>"
  echo
  echo "Extracts lines containing 'error' (case-insensitive) from the specified log file"
  echo "and saves them to a timestamped report file in: $REPORT_DIR"
  echo
}

if [[ $# -ne 1 ]]; then
  echo "ERROR: Missing log file argument"
  print_usage
  exit 1
fi

LOG_FILE="$1"

if [[ ! -f "$LOG_FILE" ]]; then
  echo "ERROR: File not found: $LOG_FILE"
  exit 1
fi

# --- MAIN LOGIC ---
# Get distinct error messages
ERROR_MESSAGES=$(grep -i "error" "$LOG_FILE" | awk '{$1=$2=$3=""; sub(/^ +/,""); print}' | sort -u)

while IFS= read -r msg; do
  echo "Error message: \"$msg\""
  error_count=$(grep -iF "$msg" "$LOG_FILE" | wc -l)
  echo "Occurred $error_count times at timestamps:"
  grep -iF "$msg" "$LOG_FILE" | awk '{print $1" "$2}'
  echo "-------------------"
done <<< "$ERROR_MESSAGES"

echo "✅ Extracted errors to: $REPORT_FILE"
