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

dnf install maven -y

VALIADTE $? ""

id roboshop #if roboshop user does not exist , then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $y SKIPPING $N"
fi

mkdir -p /app &>> $LOGFILE

VALIDATE $? "Creating app directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip

VALIDATE $? "Downloading shipping"

cd /app

VALIDATE $? "Moving to app directory"

unzip -o /tmp/shipping.zip

VALIDATE $? "unzipping shipping"

mvn clean package

VALIDATE $? "Installing dependencies"

mv target/shipping-1.0.jar shipping.jar

VALIDATE $? "Renaming jar file"

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service

VALIDATE $? "copying shipping service"

systemctl daemon-reload

VALIDATE $? "daemon reload"

systemctl enable shipping

VALIDATE $? "Enable shipping"

systemctl start shipping

VALIDATE $? "Starting shipping"

dnf install mysql -y

VALIDATE $? "Install mysql client"

mysql -h mysql.charan.fun -uroot -pRoboShop@1 < /app/schema/shipping.sql 

VALIDATE $? "loading shipping data"

systemctl restart shipping

VALIDATE $? "Restart shipping"
