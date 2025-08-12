#!/bin/bash
# Logging functions for bash scripts
# This script provides functions to log messages with different severity levels (info, warning, error)
# and to format the log messages with timestamps.
# Usage:
#   source logging.sh
#   log INFO "This is a custom log message"
#   log WARN "This is a warning message"
#   log ERROR "This is an error message"
#   log DEBUG "This is a debug message"
#   log SUCCESS "This is a message to indicate successful VM creation"

log() {
  local level="$1"; shift
  local message="$@"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" | tee -a "$LOG_FILE"
}