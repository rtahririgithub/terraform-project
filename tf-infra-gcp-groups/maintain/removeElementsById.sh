#!/bin/bash

STATE_FILE=$1
INPUT_FILE=$2

COUNTER=0
while IFS= read -r id
do
  echo "Removing $id from $STATE_FILE"
  let COUNTER=COUNTER+1
  jq 'del(.resources[].instances[] | select(.attributes.id == "'$id'"))' $STATE_FILE  > $STATE_FILE.tmp
  cp -f $STATE_FILE.tmp $STATE_FILE
done < "$INPUT_FILE"

