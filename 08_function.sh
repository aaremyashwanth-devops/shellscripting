#!/bin/bash
set -e
USER_ID=$(id -u)
VALIDATE(){
    if [ $USER_ID -eq 0 ]; then
     echo "you are root user"
     echo "Ready to install dnf $1"
     dnf install $2
     exit 1
    else 
     echo "please switch to root user"
    fi
}
VALIDATE "installing mysql" $2