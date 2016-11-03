sudo apt-get install apt-transport-https -y
sudo add-apt-repository "deb https://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" -y
sudo apt-get update
sudo apt-get install postgresql-9.4 -y --force-yes
sudo su postgres

psql -c "CREATE USER dhis WITH PASSWORD 'dhis';"
createdb -O dhis dhis2
sudo apt-get install postgresql-9.4 postgresql-9.4-postgis-2.2 postgresql-contrib-9.4 -y --force-yes