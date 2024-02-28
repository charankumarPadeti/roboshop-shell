#!/bin/bash

#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
y="\e[33m"
N="\e[0m"
MONGODB_HOST=mongodb.charan.fun

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

dnf module disable mysql -y &>> $LOGFILE

VALIDATE $? "Disable current MYSQL version"

cp mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE

VALIDATE $? "Copied MySQL repo"

dnf install mysql-community-server -y &>> $LOGFILE

VALIDATE $? "Installing mysql server"

systemctl enable mysqld &>> $LOGFILE

VALIDATE $? "Enabling Mysql server"

systemctl start mysqld &>> $LOGFILE

VALIDATE $? "Starting Mysql server"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE

VALIDATE $? "Setting My root password"





