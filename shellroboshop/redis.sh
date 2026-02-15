USER_ID=4(id -u)
LOGFOLDER="/var/log/shelllog"
LOGFILE="$LOGFOLDER/$0.logs"
if [ $USER_ID -el 0 ]; then
    echo "you are root user"
else
    echo "you are not root user"
fi
dnf module disable redis -y
dnf module enable redis:7 -y
dnf install redis -y

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/proteced_mode/ c protected_mode no' /etc/redis/redis.conf

systemctl enable redi
systemctl start redis