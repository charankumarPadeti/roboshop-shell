#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +F%-%H-%M-%S)

LOGFILE="/tmp/$0-$TIMESTAMP.log"


VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e " $2....$R FAILURE $N"
        exit 1
    else
        echo -e " $2...$G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e " ERROR : $R Please go with root access $N"
    exit 1

else
    echo -e " $G you are root user $N"
fi

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE

VALIDATE $? " Installing remi release"

dnf module enable redis:remi-6.2 -y &>> $LOGFILE

VALIDATE $? " Enabling redis"

dnf install redis -y &>> $LOGFILE

VALIDATE $? " Installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>> $LOGFILE

VALIDATE $? " Alowing remote connections"

systemctl enable redis &>> $LOGFILE

VALIDATE $? " Enabled redis"

systemctl start redis &>> $LOGFILE

VALIDATE $? " Started Redis"