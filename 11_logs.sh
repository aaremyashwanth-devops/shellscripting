#!/bin/bash
LOGS_FLODER="/var/log/shell_script"
LOGS_FILE="/var/log/shell_script/$0.log"

echo "just now created log file"  &>> $LOGS_FILE
echo "CHECK log file"  &>> $LOGS_FILE