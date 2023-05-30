#!/usr/bin/bash

trunk=$1
branch=$2

if [ -z "${trunk}" ] || [ -z "${branch}" ] ; then
  echo "usage: $0 <trunk> <branch>"
  exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

readarray -t revs <<< "$(git log --no-merges --format="%H" "$(git merge-base "${trunk}" "${branch}")".."${branch}")"
declare -A authors
for rev in "${revs[@]}" ; do
  readarray -t ac <<< "$("${SCRIPT_DIR}"/git-lines-per-author-in-commit.sh "${rev}")"
  re='(.*): (.*)'
  for acl in "${ac[@]}" ; do
    if [[ ${acl} =~ ${re} ]] ; then
      author="${BASH_REMATCH[1]}"
      count="${BASH_REMATCH[2]}"
      if [ "${authors[${author}]+x}" ] ; then
        (( authors[${author}]+=count ))
      else
        authors[${author}]="${count}"
      fi
    fi
  done
done

readarray -t results <<< "$(for author in "${!authors[@]}" ; do
  echo "${authors[${author}]}: ${author}"
done | sort -rn -k1)"

re='(.*): (.*)'
for r in "${results[@]}" ; do
  if [[ ${r} =~ ${re} ]] ; then
    echo "${BASH_REMATCH[2]}: ${BASH_REMATCH[1]}"
  fi
done
