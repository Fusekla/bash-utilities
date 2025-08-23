#!/usr/bin/env bash

set -euo pipefail

export LC_ALL=C

readonly SCRIPT_VERSION="1.1"
SCRIPT_DIR=$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")
readonly SCRIPT_DIR
readonly LOG_DIR="$SCRIPT_DIR/../logs"
LOG_FILE="$LOG_DIR/$(date +%Y%m%d-%H%M_extract-images.log)"
readonly LOG_FILE
WITH_NAMESPACES=0

mkdir -p "$LOG_DIR"

# Load helper scripts
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logging.sh"

# Help section
print_usage() {
  echo "This script lists images used in deployments across cluster, optionally with namespace"
  echo
  echo "Available flags :"
  echo "  -h|--help            -> Prints help"
  echo "  -v|--version         -> Prints script version"
  echo "  -w|--with-ns         -> Prints namespaces along with images"
  echo "Usage :"
  echo "  extract-images.sh [-h, --help] [-v, --version] [-w, --with-ns]"
  echo
}

# Ensure we have utilities available
if ! command -v kubectl > /dev/null 2>&1; then
  echo "kubectl not found, aborting!"
  exit 1
fi

if ! command -v jq > /dev/null 2>&1; then
  echo "jq not found, aborting!"
  exit 1
fi

# Function that collect images used in all deployments across cluster
get_images() {
  if [[ ${WITH_NAMESPACES} -eq 1 ]]; then
    kubectl get deploy -o json -A| jq -r '.items[] | .metadata.namespace as $ns | .spec.template.spec.containers[].image as $img | "\($ns) \($img)"' | sort -u
  else
    kubectl get deploy -o json -A| jq -r '.items[].spec.template.spec.containers[].image' | sort -u
  fi
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
    -w|--with-ns)
      WITH_NAMESPACES=1
      get_images
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

get_images | tee "$LOG_FILE"