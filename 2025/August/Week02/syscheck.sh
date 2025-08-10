#!/bin/bash

set -euo pipefail

SCRIPT_VERSION="1.0"
SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
LOG_DIR="$SCRIPT_DIR/../logs"
LOG_FILE="$LOG_DIR/$(date +%Y%m%d-%H%M_syscheck.log)"

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
  echo "  -v|--version      -> Prints script version"
  echo "  -c|--cpu          -> CPU usage"
  echo "  -m|--memory       -> Memory usage"
  echo "  -d|--disk         -> Disk usage"
  echo "  -a|--all          -> CPU, memory and disk usage"
  echo "Usage :"
  echo "  syscheck.sh [-h, --help] [-c, --cpu] [-m, --memory] [-d, --disk] [-a, --all] [-v, --version]"
  echo
}

disk_usage() {
  log INFO "=== DISK UTILIZATION ==="
  df -h >> $LOG_FILE
  echo "" >> $LOG_FILE
}

memory_usage() {
  log INFO "=== MEMORY UTILIZATION ==="
  sar -r 1 1 >> $LOG_FILE
  echo "" >> $LOG_FILE
}

cpu_usage() {
  log INFO "=== CPU UTILIZATION ==="
  sar -u 2 5 >> $LOG_FILE
  echo "" >> $LOG_FILE
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
    -c|--cpu)
      cpu_usage
      shift
      ;;
    -m|--memory)
      memory_usage
      shift
      ;;
    -d|--disk)
      disk_usage
      shift
      ;;
    -a|--all)
      cpu_usage
      memory_usage
      disk_usage
      shift
      ;;
    *)
      log ERROR "Unknown option: $1"
      print_usage
      exit 1
      ;;
  esac
done