#1/bin/bash
USER_ID=$(id -u)
LOGFOLDER="/var/log/shelllog"
LOGFILE="$LOGFOLDER/$0.logs"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USER_ID -ne 0 ]; then
  echo "switch to root user"
  exit 1
 else
  echo "you are root user"
fi

mkdir -p $LOGFOLDER

validate(){
 if [ $1 -ne 0 ]; then
   echo -e " $2... $R failure $N" | tee -a $LOGFILE
   exit 1
  else
   echo -e "$2... $G successfull $N" | tee -a $LOGFILE
  fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "created mongo repo"

dnf install mongodb-org -y &>>$LOGFILE
validate $? "install mongodb"

systemctl enable mongod -y  &>>$LOGFILE
validate $? "enable mongod"

systemctl start mongod -y &>>$LOGFILE
validate $? "start mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "set allow trafic"

systemctl restart mongod
validate $? "restart mongod"