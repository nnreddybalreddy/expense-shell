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


dnf list installed mysql-server &>>$LOGFILE
if [ $? -eq 0 ]
then 
    echo "ALready mysql-server is installed"
else 
    dnf install mysql-server -y &>>$LOGFILE
    VALIDATE $? "mysql server installation"
fi


systemctl enable mysqld 
VALIDATE $? "enable mysql"

systemctl start mysqld
VALIDATE $? "start  mysql"


mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "Password set"





