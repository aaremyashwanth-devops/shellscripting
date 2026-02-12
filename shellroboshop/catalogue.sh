#1/bin/bash
USER_ID=$(id -u)
LOGFOLDER="/var/log/shelllog"
LOGFILE="$LOGFOLDER/$0.log"
CURRENT_DIR=$PWD
MONGODB_MOMAIN=mongodb.yashwanthaarem.in
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

dnf module enable nodejs:20 -y &>>LOGFILE
validate $? "enable nodejs"

dnf install nodejs -y &>>LOGFILE
validate $? "install nodejs"

id roboshop &>>LOGFILE
if [ $? -ne 0 ]; then
    useradd  --system --home /app --shell /sbin/nologin --comment"create user roboshop" roboshop &>>$LOGFILE
    validate $? "useradd"
else 
    echo -e " skipping"
fi

mkdir -p /app &>>$LOGFILE
validate $? "app dictory created"

rm -rf /app/*
validate $? "remove exiting code"

cd /app &>>LOGFILE
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>$LOGFILE
unzip /tmp/catalogue.zip

npm install &>>LOGFILE

cp $CURRENT_DIR/catalogue.service /etc/systemd/system/catalogue.service 
validate $? "service file is created"

systemctl daemon-reload

systemctl enable catalogue
systemctl start catalogue 
validate $? "catalogue started"

cp $CURRENT_DIR/mongo.repo /etc/yum.repo.d/mongo.repo
dnf install mongodb-mongosh -y 

INDEX=$(mongosh --host $MONGODB_DOMAIN --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_DOMAIN </app/db/master-data.js
    VALIDATE $? "Loading products"
else
    echo -e "Products already loaded ... $Y SKIPPING $N"
fi

systemctl restart catalogue
VALIDATE $? "Restarting catalogue"