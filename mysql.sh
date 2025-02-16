#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%M-%H-%S)
SCRIPT_NAME=$( echo $0 | cut -d "." -f1)

LOGFILE=/tmp/$TIMESTAMP-$SCRIPT_NAME.log

USERID=$(id -u)

echo "Enter mysql root password"
read mysql_root_password

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
    echo -e "$Y ALready mysql-server is installed $N"
else 
    dnf install mysql-server -y &>>$LOGFILE
    VALIDATE $? "mysql server installation"
fi


systemctl enable mysqld 
VALIDATE $? "enable mysql"

systemctl start mysqld
VALIDATE $? "start  mysql"

mysql -h db.narendra.shop -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -eq 0 ]
then 
    echo "password already set"
else 
    mysql_secure_installation --set-root-pass ${mysql_root_password}  &>>$LOGFILE
    VALIDATE $? "Password set"        
fi 






