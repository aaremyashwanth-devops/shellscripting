#!/bin/bash
COUNTRY=india
echo "this is from script one $COUNTRY"
sh 13_file2.sh

echo "PID OF script one $$"
echo " second method source"
source ./13_file.sh