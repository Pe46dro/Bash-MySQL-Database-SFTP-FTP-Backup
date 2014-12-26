#!/bin/sh

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

if [ $TYPE -eq 1 ]
then
backup_path="/root"

umask 177

mysqldump --user=$user --password=$password --host=$host $db_name > $db_name-$d.sql

FILE="$db_name-$d.sql"

echo 'Backup Complete'
ftp -n -i $SERVER <<EOF
user $USERNAME $PASSWORD
binary
mput $FILE $REMOTDIR/$FILE
quit
EOF
echo 'Remote Backup Complete'
rm -f $backup_path/$db_name-$date.sql
echo 'Local Backup Removed'

elif [ $TYPE -eq 2 ]
then
echo "Please use FTP, SFTP isn't supported"
else
echo "Please select a valid type"
fi
# End of script