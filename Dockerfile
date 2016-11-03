FROM ubuntu:14.04

# populate repos list
RUN apt-get update

# install package dependencies
RUN apt-get install software-properties-common -y
RUN apt-get install apt-transport-https -y

# add repositories
RUN add-apt-repository "deb https://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" -y
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update

# dhis user setup
RUN useradd -d /home/dhis -m dhis -s /bin/bash
RUN usermod -G sudo dhis
RUN echo "dhis:dhis" | chpasswd
RUN passwd -l root
RUN mkdir -p /home/dhis/config

# postgres installation
RUN apt-get install postgresql-9.4 postgresql-9.4-postgis-2.2 postgresql-contrib-9.4 -y --force-yes

# java installation
RUN apt-get install -y python-software-properties debconf-utils
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN apt-get install oracle-java8-installer -y
RUN apt-get install oracle-java8-set-default

# tomcat installation
RUN apt-get install tomcat7-user -y
RUN tomcat7-instance-create tomcat-dhis

# dhis configuration
RUN echo "export JAVA_HOME='/usr/lib/jvm/java-8-oracle/'" >> /tomcat-dhis/bin/setenv.sh
RUN echo "export JAVA_OPTS='-Xmx7500m -Xms4000m'" >> /tomcat-dhis/bin/setenv.sh
RUN echo "export DHIS2_HOME='/home/dhis/config'" >> /tomcat-dhis/bin/setenv.sh

#### Download
RUN wget https://www.dhis2.org/download/releases/2.21/dhis.war
RUN mv dhis.war /tomcat-dhis/webapps/ROOT.war

#### Local
#ADD ./dhis.war /home/dhis/config/dhis.war
#RUN mv /home/dhis/config/dhis.war /tomcat-dhis/webapps/ROOT.war

# tomcat config
ADD ./dhis.conf /home/dhis/config/dhis.conf
RUN chmod 0600 /home/dhis/config/dhis.conf
ADD ./hibernate.properties /home/dhis/config/hibernate.properties
RUN chmod 0600 /home/dhis/config/hibernate.properties

# port configuration
RUN sed -ie s/8080/9999/g /tomcat-dhis/conf/server.xml
EXPOSE 9999

# config postgres
RUN /etc/init.d/postgresql start \
    && sleep 3 \
    && su postgres -c "psql -c \"CREATE USER dhis WITH PASSWORD 'dhis';\"" \
    && su postgres -c "createdb -O dhis dhis2"

CMD /etc/init.d/postgresql start \
    && /tomcat-dhis/bin/startup.sh \
    && tail -f /tomcat-dhis/logs/catalina.out
    
    
               