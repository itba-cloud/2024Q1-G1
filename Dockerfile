# Use an official base image with Java 8 installed
FROM openjdk:8-jdk

# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat7

# Install required packages
RUN apt-get update && apt-get install -y wget

# Download and install Tomcat 7
RUN wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.109/bin/apache-tomcat-7.0.109.tar.gz -O /tmp/tomcat7.tar.gz && \
    tar -xvzf /tmp/tomcat7.tar.gz -C /tmp && \
    mv /tmp/apache-tomcat-7.0.109 $CATALINA_HOME && \
    rm /tmp/tomcat7.tar.gz

# Expose the port Tomcat will run on
EXPOSE 8080

# Set PATH environment variable
ENV PATH $CATALINA_HOME/bin:$PATH

# Allow traffic on port 8080 (optional step, usually handled by Docker host)
# RUN ufw allow 8080

# Set the default command to run when starting the container
CMD ["catalina.sh", "run"]

