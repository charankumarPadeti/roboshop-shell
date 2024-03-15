#!/bin/bash

AMI=ami-0f3c7d07486cad139
SG_ID=sg-0280acde162fb3c29
INSTANCES=("mangodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do
    echo "instance is: $i"
    if [ $i == "mangodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type $INSTANCE_TYPE  --security-group-ids sg-0280acde162fb3c29
done