# Simple Tomcat image that deploys the built WAR (expects Ant build beforehand).
FROM tomcat:9.0-jdk11

# Set Tomcat env (optional)
ENV CATALINA_OPTS="-Xms256m -Xmx512m"

# Copy WAR into webapps (change name if needed)
COPY build/EduQuiz.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
