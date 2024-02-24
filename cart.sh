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

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling current Nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling Nodejs:18"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "EnaInstalling Nodejs:18"

id roboshop #if roboshop user does not exist , then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $y SKIPPING $N"
fi

mkdir -p /app

VALIDATE $? "Creating app directory"

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE

VALIDATE $? "Downloading cart application"

cd /app

unzip -o /tmp/cart.zip &>> $LOGFILE

VALIDATE $? "Unzipping cart"

npm install &>> $LOGFILE

VALIDATE $? "Installing dependencies"

#use absolute, because cart.service exists there
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>> $LOGFILE

VALIDATE $? "Copying cart service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "cart daemoon reload"

systemctl enable cart &>> $LOGFILE

VALIDATE $? "Enabling vatalogue"

systemctl start cart &>> $LOGFILE

VALIDATE $? "Starting cart"
