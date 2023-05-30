#!/usr/bin/bash

if [ -z "$1" ] ; then
  echo "usage: $0 <trunk>"
  exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

readarray -t branches <<< "$(git branch | awk '{ print $1 }' | sed '/origin\|*\|+/d')"
for b in "${branches[@]}" ; do
  # echo ">branch: ${b}" 1>&2
  min_behind=4294967295
  min_ahead=4294967295
  for trunk in "$@" ; do
    behind="$("${SCRIPT_DIR}"/git-commits-behind.sh "${trunk}" "${b}")"
    if [ "${min_behind}" -gt "${behind}" ] ; then
      min_behind="${behind}"
    fi
    ahead="$("${SCRIPT_DIR}"/git-commits-ahead.sh "${trunk}" "${b}")"
    # if [ "${ahead}" -ne 0 ] ; then
    #   echo "${trunk} -> ${b} ${ahead}"
    # fi
    if [ "${min_ahead}" -gt "${ahead}" ] ; then
      min_ahead="${ahead}"
    fi
    # echo "> ${trunk} behind: ${behind}" 1>&2
    # echo "> ${trunk} ahead: ${ahead}" 1>&2
  done
  if [ "${min_ahead}" -ne 0 ] ; then
    echo "${b} ${min_behind}:${min_ahead}"
  fi
done
