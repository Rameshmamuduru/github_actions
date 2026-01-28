FROM tomcat:9-jdk17

LABEL Maintainer="Ramesh_Mamuduru"

LABEL email="rameshmamuduru7799@gmail.com"

RUN rm -rf /usr/local/tomcat/webapps/*

COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]


