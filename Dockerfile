############################################################
# OSF Fedora Repo
# A Docker Container Installation of FC4
############################################################


#Declare CentOS the latest
FROM centos

Maintainer Andrew J Krug

# UPDATE
RUN yum -y update  

# INSTALL packages 
RUN yum -y install wget
RUN yum -y install tar
RUN yum -y install epel-release
RUN yum -y install pwgen

# INSTALL JAVA
RUN yum -y install java-1.7.0-openjdk  

# TOMCAT version
ENV TOMCAT_VERSION 7.0.55
ENV CATALINA_HOME /opt/tomcat

# INSTALL TOMCAT
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/catalina.tar.gz

# UNPACK
RUN tar xzf /tmp/catalina.tar.gz -C /opt
RUN ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat
RUN rm /tmp/catalina.tar.gz

# REMOVE APPS 
RUN rm -rf /opt/tomcat/webapps/examples /opt/tomcat/webapps/docs 

# SET CATALINE_HOME and PATH 
ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

#Randomize the TC Admin and write to container log
ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh


#Fetch a Tomcat Application for Deployment
RUN wget https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.0.0/fcrepo-webapp-4.0.0.war -P /opt/apache-tomcat-7.0.55/webapps

ADD run.sh /run.sh
RUN chmod +x /*.sh

CMD ["/run.sh"]

#GET PORT and start TOMCAT
EXPOSE 8080


