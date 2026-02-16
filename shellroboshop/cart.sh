#!/bin/bash

USERID=$(id -u)
LOGFOLDER="/var/log/shelllog"
LOGFILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
#MONGODB_HOST=mongodb.daws88s.online

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

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling NodeJS Default version"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling NodeJS 20"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Install NodeJS"

id roboshop &>>$LOGFILE
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGFILE
    VALIDATE $? "Creating system user"
else
    echo -e "Roboshop user already exist ... $Y SKIPPING $N"
fi

mkdir -p /app 
VALIDATE $? "Creating app directory"

curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip  &>>$LOGFILE
VALIDATE $? "Downloading cart code"

cd /app
VALIDATE $? "Moving to app directory"

rm -rf /app/*
VALIDATE $? "Removing existing code"

unzip /tmp/cart.zip &>>$LOGFILE
VALIDATE $? "Unzip cart code"

npm install  &>>$LOGFILE
VALIDATE $? "Installing dependencies"

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service
VALIDATE $? "Created systemctl service"

systemctl daemon-reload
systemctl enable cart  &>>$LOGFILE
systemctl start cart
VALIDATE $? "Starting and enabling cart"