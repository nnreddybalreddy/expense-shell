#!/bin/bash
TIMESTAMP=$(date +%F-%M-%H-%S)
SCRIPT_NAME=$( echo $0 | cut -d "." -f1)

LOGFILE=/tmp/$TIMESTAMP-$SCRIPT_NAME.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "   $2... $R failure $N"
        exit 1
    else 
        echo -e "    $2... $G pass $N"    

    fi
}

USERID=$(id -u)

if [ $USERID -ne 0 ]
then 
    echo "not a root user"
    exit 1
else 
    echo "Its a root user"    
fi

dnf install mysql-server -y &>>$LOGFILE
