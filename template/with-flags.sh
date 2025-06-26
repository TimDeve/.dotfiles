#!/usr/bin/env bash

# TODO: change this doc

set -CEeuo pipefail
shopt -s extglob # Needed for = in flags

print-usage() {
  awk '/^#!/{next} /^#/{print substr($0, 3); h++} /^$/{if (h) exit}' "${BASH_SOURCE[0]}"
}

trap cleanup SIGINT SIGTERM ERR EXIT
cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  set +CEeuo pipefail # Don't stop in middle of cleanup

  # Cleanup resources here
}

while [[ $# -gt 0 ]]; do
  case $1 in
    # Unsticks single letter flags _without_ parameter
    -[ha][!-]*) set -- "${1:0:2}" "-${1:2}" "${@:2}" ; continue ;;
    # Unsticks single letter flags with parameter
    -[bc]?*) set -- "${1:0:2}" "${1:2}" "${@:2}" ; continue ;;
    # Split long flags with = signs
    --@(argb|argc)=*) set -- "${1%%=*}" "${1#*=}" "${@:2}" ; continue ;;

    -h|--help)
      print-usage && exit 0
      ;;
    -a|--arga)
      argA=1
      ;;
    -b|--argb)
      shift
      arbB="$1"
      ;;
    -c|--argc)
      shift
      arbC="$1"
      ;;
    *)
      echo "Unkwown arg '$1'"
      exit 1
      # Or positional arguments
      # pos_args+=("$1")
      ;;
  esac
  shift
done

exit 1
