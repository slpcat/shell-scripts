#!/bin/bash
 
trash_dir=${HOME}/.Trash/$(date +%Y%m%d%H%M%S)
 
function move_item(){
  item=$1
  full_path=$2
  full_dir=$(dirname ${full_path})
  mkdir -p ${trash_dir}${full_dir}
  mv ${item} ${trash_dir}${full_path}
  if [[ $? -eq 0 ]]; then
    echo "Moved ${item} to ${trash_dir}${full_path}"
  fi
}
 
if [[ $# -eq 0 ]] || $(echo "$1" |grep -Ewq '\-h|\-\-help'); then
  echo "${0} [-f] [*|FILE]"
  exit 2
fi
 
for item in $@; do
  if $(echo ${item} |grep -vq '^-'); then
    if $(echo ${item} |grep -q '^/'); then
      full_path=${item}
    else
      full_path=$(pwd)/${item}
    fi
    if $(echo $@ |grep -Ewq '\-f|\-rf|\-fr'); then
      move_item ${item} ${full_path}
    else
      echo -n "Move ${item} to ${trash_dir}${full_path}? [y/n] "
      read yorn
      if $(echo ${yorn} |grep -Ewq 'y|Y|yes|YES'); then
        move_item ${item} ${full_path}
      fi
    fi
  fi
done
