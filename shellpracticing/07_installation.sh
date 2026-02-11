#!/bin/bash
USER_ID=$(id -u)
if [ $USER_ID -eq 0 ]; then
 echo "installing inginx"
else 
 echo "switch to root user"
fi
dnf install nginx -y

if [ $? -eq 0 ]; then
 echo "ngix install successfull"
else
 echo "ngix install failure"
fi