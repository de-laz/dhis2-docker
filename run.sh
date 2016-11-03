#!/bin/bash 
/etc/init.d/postgresql start
sleep 3
psql -c "CREATE USER dhis WITH PASSWORD 'dhis';"
createdb -O dhis dhis2
/tomcat-dhis/bin/startup.sh
sleep 3
tail -f /tomcat-dhis/logs/catalina.out
while :; do echo 'Hit CTRL+C'; sleep 1; done