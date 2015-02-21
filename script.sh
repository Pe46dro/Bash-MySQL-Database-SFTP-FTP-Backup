#!/bin/bash

# Linux MySQL Database FTP Backup Script
# Version: 1.0
# Script by: Pietro Marangon
# Skype: pe46dro
# Email: pietro.marangon@gmail.com
# SFTP function by unixfox and Pe46dro

backup_path="/root"

create_backup() {
  umask 177

  FILE="$db_name-$d.sql"
  mysqldump --user=$user --password=$password --host=$host $db_name > $FILE

  echo 'Backup Complete'
}

clean_backup() {
  rm -f $backup_path/$FILE.sql
  echo 'Local Backup Removed'
}

########################
# Edit Below This Line #
########################

# Database credentials

user="USERNAME HERE"
password="PASSWORD HERE"
host="IP HERE"
db_name="DATABASE NAME HERE"

# FTP Login Data
USERNAME="USERNAME HERE"
PASSWORD="PASSWORD HERE"
SERVER="IP HERE"
PORT="SERVER PORT HERE"

#Remote directory where the backup will be placed
REMOTEDIR="./"

#Transfer type
#1=FTP
#2=SFTP
TYPE=1

##############################
# Don't Edit Below This Line #
##############################

d=$(date --iso)
cd $backup_path
create_backup

if [ $TYPE -eq 1 ]
then
ftp -n -i $SERVER <<EOF
user $USERNAME $PASSWORD
binary
mput $FILE $REMOTDIR/$FILE
quit
EOF
elif [ $TYPE -eq 2 ]
then
cd $backup_path
sshpass -p $PASSWORD ssh -p $PORT $USERNAME@$SERVER
cd $REMOTDIR
put $FILE
exit
else
echo 'Please select a valid type'
fi

echo 'Remote Backup Complete'
clean_backup
#END
