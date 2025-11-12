#!/bin/bash
source ./common.sh

check_root


dnf install nginx -y &>>$LOGFILE
VALIDATE $? "installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "enable nginx"

systemctl start nginx  &>>$LOGFILE
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "removing nginx"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "downloading code"

cd /usr/share/nginx/html &>>$LOGFILE
VALIDATE $? "extract code"

cp /home/ec2-user/terraform/expense.config /etc/nginx/default.d/expense.conf
VALIDATE $? "copy code"


unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "unzip code"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "restart nginx"









