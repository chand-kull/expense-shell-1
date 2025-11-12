#!/bin/bash
source ./common.sh
check_root

echo "please enter DB password:"
read  -s mysql_root_password

dnf install mysql-server -y &>>$LOGFILE

systemctl enable mysqld &>>$LOGFILE

systemctl start mysqld &>>$LOGFILE

#below code will seful for idempotent nature
mysql -h db.zarasolutions.shop -uroot -p ${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
  mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
else
  echo  -e "MYSQL root password is already setup.....$G skipping $N" 
fi 
 
#interviw question
# idempotency?



