#!/usr/bin/bash

trunk=$1
branch=$2

if [ -z "${trunk}" ] || [ -z "${branch}" ] ; then
  echo "usage: $0 <trunk> <branch>"
  exit 1
fi

git log --oneline "$(git merge-base "${trunk}" "${branch}")".."${trunk}" | wc -l
