#!/usr/bin/env bash

set -euo pipefail

export LC_ALL=C

readonly SCRIPT_VERSION="1.1"
SCRIPT_DIR=$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")
readonly SCRIPT_DIR
readonly LOG_DIR="$SCRIPT_DIR/../logs"
LOG_FILE="$LOG_DIR/$(date +%Y%m%d-%H%M_pods-by-ns.log)"
readonly LOG_FILE

mkdir -p "$LOG_DIR"

# Load helper scripts
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logging.sh"

# Help section
print_usage() {
  echo "This script lists pods with their status, grouped by namespace"
  echo
  echo "Available flags :"
  echo "  -h|--help         -> Prints help"
  echo "  -v|--version      -> Prints script version"
  echo "  -s|--summary      -> Prints summary pods count grouped by namespace"
  echo "Usage :"
  echo "  pod-by-ns.sh [-h, --help] [-v, --version] [-s, --summary]"
  echo
}

# Ensure we have kubectl available
if ! command -v kubectl > /dev/null 2>&1; then
  echo "kubectl not found, aborting!"
  exit 1
fi

# Function that collect all pods in cluster, their status and groups by namespace
collect_pods() {
  kubectl get po -A --no-headers -o=custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,STATUS:.status.phase 2>&1
}

# Function that prints count of pods grouped by namespace
summary() {
  kubectl get po -A --no-headers -o=custom-columns=NAMESPACE:.metadata.namespace 2>&1 | sort | uniq -c | tee "$LOG_FILE"
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
    -s|--summary)
      summary
      exit 0
      ;;
    -*)
      log ERROR "Unknown option: $1"
      print_usage
      exit 2
      ;;
    *)
      echo "This script does not accept any arguments"
      print_usage
      exit 2
      ;;
  esac
done

collect_pods | tee "$LOG_FILE"