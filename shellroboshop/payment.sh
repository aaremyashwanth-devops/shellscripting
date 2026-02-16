#!/bin/bash
USER_ID=$(id -u)
LOGFOLDER="/var/log/shelllogs"
LOGFILE="$LOGFOLDER/$0.log"
CURRETNT_DIR=$PWD

if [ $USER_ID -ne 0 ]; then
 echo "you are not root user"
else
 echo "you are root user"
fi

validation(){
    if [ $1 -ne 0 ]; then
     echo "$2...failure"
    else
     echo "$2...sucessfull"
    fi
}

dnf install python3 gcc python3-devel -y
validation $? "python install"

id roboshop &>>$LOGFILE

if [ $? -eq 0 ]; then
 echo "user is exits"
 exit 1
else 
 useradd --system --home /app --shell /sbin/nologin --comment "create user roboshop" roboshop
fi
mkdir /app
cd /app
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip 
unzip /tmp/payment.zip

pip3 install -r requirements.txt

cp $CURRETNT_DIR/payment.service /etc/system/systemd/payment.service

validation $? "systemctl is enable"

systemctl daemon-reload
systemctl enable payment
systemctl start payment
validation $? "start payment"