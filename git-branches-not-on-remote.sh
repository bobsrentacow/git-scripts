#!/usr/bin/bash

# Method A: Find the upstream for each branch and output those without
readarray -t branches <<< "$(git branch | awk '{ print $1 }' | sed '/origin\|*\|+/d')"
for b in "${branches[@]}" ; do
  remote="$(git for-each-ref --format='%(upstream:short)' refs/heads/"${b}")"
  if [ -z "${remote}" ] ; then
    echo "${b}:"
    continue
  fi
done

# Methob B: find all branches, and merged branches, then create list of unmerged branches
# readarray -t branches <<< "$(git branch | awk '{ print $1 }' | sed '/origin\|*\|+/d')"
# readarray -t remotes <<< "$(git branch -r | sed '/*\|+/d' | sed 's/  origin\///')"
# for del in "${remotes[@]}"; do
#   for ii in "${!branches[@]}"; do
#     if [[ "${branches[ii]}" == "${del}" ]]; then
#       unset 'branches[ii]'
#     fi
#   done
# done

# for branch in "${branches[@]}" ; do
#   echo "${branch}"
# done
