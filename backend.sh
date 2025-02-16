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

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "nodejs disable"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "enable nodejs 20"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "install nodejs 20"

id expense &>>$LOGFILE

if [ $? eq 0 ]
then 
    echo -e "$Y Expense user already added $N"
else  
    useradd expense
fi 

mkdir -p /app &>>$LOGFILE

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip  &>>$LOGFILE

cd /app &>>$LOGFILE

rm -rf /app/*

unzip /tmp/backend.zip &>>$LOGFILE
npm install &>>$LOGFILE

cp -rf /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>$LOGFILE

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon reload"

systemctl start backend &>>$LOGFILE
VALIDATE $? "start backend"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "enable backend"

dnf list installed mysql &>>$LOGFILE
VALIDATE $? "enable backend"

if [$? -eq 0 ]
then 
    echo "mysql already installed"
else 
    dnf list installed mysql &>>$LOGFILE
    VALIDATE $? "enable backend"
fi 

mysql -h db.narendra.shop -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
systemctl restart backend &>>$LOGFILE











