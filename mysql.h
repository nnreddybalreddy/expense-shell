#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%M-%H-%S)
SCRIPT_NAME=$( echo $0 | cut -d "." -f1)

LOGFILE=/tmp/$TIMESTAMP-$SCRIPT_NAME.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "Enter Password:"
read -s MYSQL_ROOT_PASSWORD

VALIDATE(){
    if [ $? -ne 0 ]
    then 
        echo -e "   $2... $R failure $N"
        exit 1
    else 
        echo -e "    $2... $G pass $N"    

    fi
}

USERID=$(id -u)

if [ $? -ne 0 ]
then 
    echo "not a root user"
    exit 1
else 
    echo "Its a root user"    
fi


dnf list installed mysql-server &>>$LOGFILE
if [ $? -eq 0 ]
then
    echo -e "$Y mysql server is already installed $N"
else 
    dnf install mysql-server -y &>>$LOGFILE
    VALIDATE $? "Installation of mysql server"
fi 


systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enable of  mysql server"


systemctl start mysqld &>>$LOGFILE
VALIDATE $? "start  of mysql server"


mysql -h db.narendra.shop -uroot -p${MYSQL_ROOT_PASSWORD} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass ${MYSQL_ROOT_PASSWORD} &>>$LOGFILE
    VALIDATE $? "Setting up  mysql server password"  
else 
    echo -e "$Y password alreay set $N"      
fi



