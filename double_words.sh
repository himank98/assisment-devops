#!/bin/bash
#
FILE=$1
#
TEMP='.'
#
for word in `cat -E $FILE`
do
  if [[ ${word} == '$' ]]
  then
    echo
  else
    if [[ ${word} != ${TEMP} ]]
    then
      echo -en "${word} "
      TEMP=$word
    fi
  fi 
done