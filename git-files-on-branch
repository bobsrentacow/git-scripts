#!/usr/bin/bash

if [[ "$#" -ne 1 ]] ; then
  echo "usage: $0 <trunk_branch_name>"
fi
trunk="$1"

echo "Displaying branches that have cache/* in their tree somewhere between the merge-base and HEAD"
echo "of that branch.  Merge-base is checked on a per-branch basis relative to trunk."
echo ""

# find all branches, and merged branches, then create list of unmerged branches
readarray -t branches <<< "$(git branch | awk '{ print $1 }' | sed '/*\|+/d')"
readarray -t merged <<< "$(git branch --merged "${trunk}" | awk '{ print $1 }' | sed '/*\|+/d')"
for del in "${merged[@]}"; do
  for ii in "${!branches[@]}"; do
    if [[ "${branches[ii]}" == "${del}" ]]; then
      unset 'branches[ii]'
    fi
  done
done

for branch in "${branches[@]}" ; do
  commits_text="$(git log --format=format:"%H" "$(git merge-base "${trunk}" "${branch}")".."${branch}")"
  if [ -z "${commits_text}" ] ; then
    continue
  fi
  readarray -t commits <<< "${commits_text}"

  branch_printed=false
  for commit in "${commits[@]}" ; do
    tree_cache_text="$(git ls-tree -r "${commit}" | awk '$4 ~ /^cache\/\S+\//')"
    if [ -z "${tree_cache_text}" ] ; then
      continue
    fi
    if [ ${branch_printed} != true ]; then
      echo "branch: ${branch}"
      branch_printed=true
      break
    fi
    echo "  commit: ${commit}"
  done
  if [ ${branch_printed} == true ]; then
    continue
  fi
done
