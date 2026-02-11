#!/bin/bash
NUMBER=$1
if [ $NUMBER -gt 20 ]; then
 echo "this is true $NUMBER"
elif [ $NUMBER -eq 20 ]; then
 echo "this equal :number $NUMBER"
else 
  echo "this is false $NUMBER"
fi