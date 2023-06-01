#!/usr/bin/bash

rev=$1

if [ -z "${rev}" ] ; then
  echo "usage: $0 <rev>"
  exit 1
fi

name="$(git log -n1 --format='%an' "${rev}")"
if true ; then
  # count="$(git diff --numstat "${rev}"~.."${rev}" | awk '{sum+=$1+$2} END {print sum}')"
  count="$(git diff --numstat "${rev}"~.."${rev}" -- . ':^cache' | awk '{sum+=$1+$2} END {print sum}')"
  echo "${name}: ${count}"
else
  readarray -t log <<< "$(git log -n1 --pretty="%an" --numstat "${rev}")"
  re='([0-9]+)\s+([0-9]+)\s+(.*)'
  for ii in "${!log[@]}" ; do
    case ${ii} in 
      0)
        name="${log[${ii}]}"
        count=0
        ;;
      1)
        ;;
      *)
        if [[ ${log[${ii}]} =~ $re ]] ; then
          (( count+= (BASH_REMATCH[1] + BASH_REMATCH[2]) ))
        fi
        ;;
    esac
  done

  echo "${name}: ${count}"
fi
