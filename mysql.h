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

if [ $? -eq 0 ]
then 
    echo "mysql server already installed"
else 
    VALIDATE $? "mysql-server installation"
fi

systemctl enable mysqld &>>$LOGFILE
if [ $? -eq 0 ]
then 
    echo "mysql server already installed"
else 
    VALIDATE $? "enable mysql server"
fi



systemctl start mysqld &>>$LOGFILE 
if [ $? -eq 0 ]
then 
    echo "mysql server already installed"
else 
    VALIDATE $? "start mysql server"
fi

mysql_secure_installation --set-root-pass ExpenseApp@1  &>>$LOGFILE
if [ $? -eq 0 ]
then 
    echo "password already set it up"
else 
    VALIDATE $? "password setup success"
fi

