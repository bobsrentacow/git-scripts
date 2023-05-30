#!/usr/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

fg_red="\e[31m"
fg_dflt="\e[0m"

readarray -t branches <<< "$(git branch | awk '{ print $1 }' | sed '/origin\|*\|+/d')"
readarray -t remotes <<< "$(git branch -r | awk '{ print $1 }' | sed '/*\|+/d')"
for b in "${branches[@]}" ; do
  if ! remote="$(git rev-parse -q --abbrev-ref "${b}@{u}" 2>/dev/null)"; then
    echo "${b}: upstream not set"
    continue
  fi
  if [[ ! "${remotes[*]}" =~ "${remote}" ]]; then
    echo "${b}: upstream not in remotes"
    continue
  fi
  ahead="$("${SCRIPT_DIR}"/git-commits-ahead.sh "${remote}" "${b}")"
  if [ "${ahead}" -gt 0 ] ; then
    echo -e "${b}: ${fg_red}${ahead}${fg_dflt}"
  fi
done

