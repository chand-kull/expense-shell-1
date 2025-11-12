
#!/bin/bash
source ./common.sh

check_root

dnf module disable nodejs -y &>>$LOGFILE

dnf module enable nodejs:20 -y &>>$LOGFILE

dnf install nodejs -y &>>$LOGFILE

id expense 
if [ $? -ne 0 ]
then
 useradd expense
 VALIDATE $? "creating expense user"
else
 echo  -e "Expense user alresdy created .....$Y SKIPPING $N"

fi

mkdir  -p /app &>>$LOGFILE

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE


cd /app &>>$LOGFILE
rm -rf /app/*
unzip /tmp/backend.zip

npm install &>>$LOGFILE

sudo cp /home/ec2-user/terraform/backend.service  /etc/systemd/system/backend.service &>>$LOGFILE

systemctl daemon-reload &>>$LOGFILE

systemctl start backend &>>$LOGFILE

systemctl enable backend &>>$LOGFILE

dnf install mysql -y &>>$LOGFILE

mysql -h 44.199.254.185 -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE

systemctl restart backend &>>$LOGFILE






