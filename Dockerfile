FROM tomcat:10-jdk11
COPY eduquiz.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
