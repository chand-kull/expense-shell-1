#!/bin/bash
set -e 

handle_error(){
    echo "Failed at  line no $1: error command is $2"
 }

 trap 'handle error ${LINENO} "$BASH_COMMAND"' ERR 
source ./common.sh

check_root

echo "please enter DB password:"
read  -s mysql_root_password

dnf install mysql-servedddr -y &>>$LOGFILE
# VALIDATE $? "installing mysql-server"

systemctl enable mysqld &>>$LOGFILE
# VALIDATE $? "enabling mysql server" 

systemctl start mysqld &>>$LOGFILE
# VALIDATE $? "starting mysql" 

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "settingup root password"

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



