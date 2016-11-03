# java installation
sudo apt-get install -y python-software-properties debconf-utils
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install oracle-java8-installer -y
sudo apt-get install oracle-java8-set-default

# tomcat installation
sudo apt-get install tomcat7-user -y
tomcat7-instance-create tomcat-dhis

# dhis configuration
echo "export JAVA_HOME='/usr/lib/jvm/java-8-oracle/'" >> /tomcat-dhis/bin/setenv.sh
echo "export JAVA_OPTS='-Xmx7500m -Xms4000m'" >> /tomcat-dhis/bin/setenv.sh
echo "export DHIS2_HOME='/home/dhis/config'" >> /tomcat-dhis/bin/setenv.sh
wget https://www.dhis2.org/download/releases/2.21/dhis.war
mv dhis.war /tomcat-dhis/webapps/ROOT.war