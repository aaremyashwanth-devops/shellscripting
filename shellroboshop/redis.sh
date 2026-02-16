#!/bin/bash

USERID=$(id -u)
LOGFOLDER="/var/log/shelllog"
LOGFILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]; then
    echo -e "$R Please run this script with root user access $N" | tee -a $LOGFILE
    exit 1
fi

mkdir -p $LOGFOLDER

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $LOGFILE
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N" | tee -a $LOGFILE
    fi
}

dnf module disable redis -y &>>$LOGFILE
dnf module enable redis:7 -y &>>$LOGFILE
VALIDATE $? "Enable Redis:7"

dnf install redis -y  &>>$LOGFILE
VALIDATE $? "Installed Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Allowing remote connections"

systemctl enable redis &>>$LOGFILE
systemctl start redis 
VALIDATE $? "Enabled and started Redis"