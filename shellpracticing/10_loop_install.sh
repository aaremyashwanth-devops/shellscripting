#!/bin/bash
set -e
USER_ID=$(id -u)
 for package in $@ 
 do 
    if [ $USER_ID -eq 0 ]; then
     echo "you are root user"
     

     dnf install $package -y
     
     echo "installed $package"
     
    fi

 done