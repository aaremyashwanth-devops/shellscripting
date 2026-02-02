#!/bin/bash
echo "how much time taken for excution"
START_TIME=$(date)
echo "time started $START_TIME"
sleep 10
END_TIME=$(date)
TOTAL_TIME=$(($START_TIME-$END_TIME))
echo "final time consumed $TOTAL_TIME"