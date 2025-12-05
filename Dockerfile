FROM tomcat:11.0-jdk21

# Clean default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file as ROOT (deploys at /)
COPY eduquiz.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
