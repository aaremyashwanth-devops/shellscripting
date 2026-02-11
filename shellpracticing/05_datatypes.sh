#!/bin/bash
NAME="Yashwanth"
AGE=26
AGE1=3
echo "my name is $NAME"
echo "my age is $AGE"

#array list
ITEMS=("LIGHT","BULB","KEYBOARD","PEN")
echo "accessing first item $ITEMS"
echo "accessing secound item {$ITEMS[1]}"
#addition
echo "$(($AGE + 2)):: result"
echo "addition two ages are $(($AGE + $AGE1))"