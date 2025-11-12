


if [ $USERID  -ne 0 ]
then 
 echo "please run this script with super user"
 exit 1 
else 
 echo "you are a super user"
fi
dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "disabling nodejs"


dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "enabling nodejs"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "installing nodejs"

id expense 
if [ $? -ne 0 ]
then
 useradd expense
 VALIDATE $? "creating expense user"
else
 echo  -e "Expense user alresdy created .....$Y SKIPPING $N"

fi

mkdir  -p /app &>>$LOGFILE
VALIDATE $? "creating app directory"


curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "downloading backend code"


cd /app &>>$LOGFILE
rm -rf /app/*
unzip /tmp/backend.zip
VALIDATE $? "extracting backend code"

npm install &>>$LOGFILE
VALIDATE $? "installing nodejs dependencies"

sudo cp /home/ec2-user/terraform/backend.service  /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "copying backend service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon-reload"

systemctl start backend &>>$LOGFILE
VALIDATE $? "start backend"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "enabling backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "installing mysql"

mysql -h 44.199.254.185 -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "schema loading"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "restart backend"






