#!/usr/bin/expect
cd /tmp/yscheduler
set STORAGE_HOST [lindex $argv 0]
set USER [lindex $argv 1]
set PASSWORD [lindex $argv 2]
set DATE [lindex $argv 3]
set VERSION [lindex $argv 4]
set ENV [lindex $argv 5]
set timeout -1

   #scp
   spawn scp deploy/target/yscheduler-storage-${VERSION}.zip $USER@${STORAGE_HOST}:/dianyi/
   expect "password:" {
      send "${PASSWORD}\r"
   }
   expect "100%"
   #login
   spawn ssh $USER@$STORAGE_HOST
   expect "(yes/no)?" {
         send "yes\r"
         expect "password:" {
             send "$PASSWORD\r"
         }
   } "password:" {
         send "$PASSWORD\r"
   }
   expect "*~*"
   #stop
   send "jetty.sh stop\r"
   expect "*~*"
   #stop

   #backup,unzip
   send "rm /dianyi/backup/yscheduler-storage-$ENV* -rf\r"
   expect "*~*"
   send "mkdir -p /dianyi/backup/ \r"
   expect "*~*"
   send "mv /dianyi/webapps/yscheduler-storage-$ENV /dianyi/backup/yscheduler-storage-$ENV.${DATE}\r"
   expect "*~*"
   send "unzip -q -o /dianyi/yscheduler-storage-${VERSION}.zip -d /dianyi/webapps/\r"
   expect "*~*"
   send "mv /dianyi/webapps/ROOT /dianyi/webapps/yscheduler-storage-$ENV \r"
   #start
   expect "*~*"
   send "jetty.sh start\r"
   expect "*~*"
   send "exit\r"
   expect "*closed*"
exit