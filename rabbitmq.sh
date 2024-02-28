#!/bin/bash

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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? " Downloading erlang script"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? "Downloading rabbitmq script"

dnf install rabbitmq-server -y &>> $LOGFILE

VALIDATE $? "Installing rabbitMQ serever"

systemctl enable rabbitmq-server &>> $LOGFILE

VALIDATE $? " Enabling rabbitmq"

systemctl start rabbitmq-server &>> $LOGFILE

VALIDATE $? " Starting rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE

VALIDATE $? "Creating user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE

VALIDATE $? " Setting permission"