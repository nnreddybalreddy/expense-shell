#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%M-%H-%S)
SCRIPT_NAME=$( echo $0 | cut -d "." -f1)

LOGFILE=/tmp/$TIMESTAMP-$SCRIPT_NAME.log

USERID=$(id -u)

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 $R FAILURE.. $N"
        exit 1
    else 
        echo -e "$2 $G SUCCESS.. $N"
    fi
}


if [ $USERID -ne 0 ]
then 
    echo "Not a root user"
    exit 1
else 
    echo "Super User"    
fi 


