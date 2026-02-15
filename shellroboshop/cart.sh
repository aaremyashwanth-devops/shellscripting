#!/bin/bash
USER_ID=$(id -u)
LOGFOLDER="/var/log/shelllog"
LOGFILE="$LOGFOLDER/$0.log"
CURRENT_DIR=$PWD
MONGODB_DOMAIN=mysql.yashwanthaarem.in
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\E[0m"
if [ $USER_ID -ne 0 ]; then
    echo  "switch to root user"
    exit1
else
    echo "you are root user"
fi
mkdir -p $LOGFOLDER
validate(){
    if [ $? -ne 0 ]; then
        echo -e "$2...$R failure$N" | tee -a $LOGFILE
    else
        echo -e "$2...$R successfull$N" |tee -a $LOGFILE
    fi
}

dnf module disable nodejs -y  &>>$LOGFILE
validate $? "module disable"  

dnf module enable nodejs:20 -y &>>$LOGFILE
validate $? "enable nodejs"

dnf install nodejs -y &>>$LOGFILE
validate $? "install nodejs"

id roboshop &>>$LOGFILE
if [ $? -ne 0 ]; then
    useradd  --system --home /app --shell /sbin/nologin --comment "create user roboshop" roboshop &>>$LOGFILE
    validate $? "creating user"
else 
    echo -e " skipping"
fi

mkdir -p /app &>>$LOGFILE
validate $? "app dictory created"

rm -rf /app/*
validate $? "remove exiting code"
cd /app &>>$LOGFILE
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip  &>>$LOGFILE
unzip /tmp/cart.zip

npm install &>>$LOGFILE

cp $CURRENT_DIR/cart.service /etc/systemd/system/cart.service 
validate $? "service file is created"

systemctl daemon-reload

systemctl enable cart
systemctl start cart 
validate $? "cart started"



systemctl restart cart
VALIDATE $? "Restarting cart"