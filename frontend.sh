#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%M-%H-%S)
SCRIPT_NAME=$( echo $0 | cut -d "." -f1)

LOGFILE=/tmp/$TIMESTAMP-$SCRIPT_NAME.log

USERID=$(id -u)

# echo "Enter mysql root password"
# read mysql_root_password

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

dnf list installed nginx &>>$LOGFILE

if [ $? -eq 0 ]
then 
    echo "nginx already isntalled"
else 
    dnf install nginx -y &>>$LOGFILE
    VALIDATE $? "nodejs disable"
fi 

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "enable nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "start nginx"

# rm -rf /usr/share/nginx/html/* &>>$LOGFILE
# VALIDATE $? "remove html"

# curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
# VALIDATE $? "code for tmp"

