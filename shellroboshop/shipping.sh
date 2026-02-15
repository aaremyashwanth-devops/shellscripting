#!/bin/bash
USER_ID=$(id -u)
LOGFOLDER="/var/log/shelllog"
LOGFILE="$LOGFOLDER/$0.log"
CURRENT_DIR=$PWD
MYSQL_HOST=mysql.yashwanthaarem.in
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

dnf install maven -y  &>>$LOGFILE
validate $? "install maven"  



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
curl -L -o curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip   &>>$LOGFILE
unzip /tmp/shipping.zip

dnf mvn clean package  &>>$LOGFILE
validate $? "package clean"

dnf mv target/shipping-1.0.jar shipping.jar  &>>$LOGFILE
validate $? "moved shipping file"

cp $CURRENT_DIR/shipping.service /etc/systemd/system/shipping.service 
validate $? "service file is created"

systemctl daemon-reload



mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities'
if [ $? -ne 0 ]; then

    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOGS_FILE
    VALIDATE $? "Loaded data into MySQL"
else
    echo -e "data is already loaded ... $Y SKIPPING $N"
fi

systemctl enable shipping &>>$LOGS_FILE
systemctl start shipping
VALIDATE $? "Enabled and started shipping"

systemctl restart shipping
VALIDATE $? "Restarting shipping"