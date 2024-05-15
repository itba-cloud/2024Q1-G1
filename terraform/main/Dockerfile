# Use a base image with JDK installed, required for Tomcat and Maven
FROM openjdk:8

# Set environment variables for the application
ENV VITE_APP_BASE_PATH='/webapp' \
    VITE_APP_BASE_URL='http://lb-1891763237.us-east-1.elb.amazonaws.com:8080' \
    DB_URL_ENV="jdbc:postgresql://database-1.ct80qs8yuayi.us-east-1.rds.amazonaws.com:5432/" \
    DB_USERNAME_ENV="postgres" \
    DB_PASSWORD_ENV="1SRcd8pto"

# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat7
ENV M2_HOME /opt/apache-maven-3.6.3
ENV MAVEN_HOME /opt/apache-maven-3.6.3
ENV PATH $CATALINA_HOME/bin:$M2_HOME/bin:$PATH

# Install required packages
RUN apt-get update && \
    apt-get install -y wget git

# Download and install Tomcat 7
RUN wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.109/bin/apache-tomcat-7.0.109.tar.gz -O /tmp/tomcat7.tar.gz && \
    tar -xvzf /tmp/tomcat7.tar.gz -C /tmp && \
    mv /tmp/apache-tomcat-7.0.109 $CATALINA_HOME && \
    rm /tmp/tomcat7.tar.gz

# Download and install Maven
RUN wget https://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -O /tmp/maven.tar.gz && \
    tar -xvzf /tmp/maven.tar.gz -C /opt && \
    rm /tmp/maven.tar.gz

# Clone the repository
RUN git config --global http.postBuffer 1048576000  # Set buffer to 1000MB
RUN for i in {1..5}; do git clone "https://github.com/Marco444/LendARead2-AWS.git" /usr/src/LendARead2AWS && break || sleep 5; done

# Change the working directory
WORKDIR /usr/src/LendARead2AWS/LendARead2/

# Compile the application
RUN mvn clean install -Dmaven.test.skip=true -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true

# Move the WAR file to Tomcat's webapps directory
RUN mv /usr/src/LendARead2AWS/LendARead2/webapp/target/webapp.war $CATALINA_HOME/webapps/

# Expose the port Tomcat will run on
EXPOSE 8080

# Set the default command to run when starting the container
CMD ["/usr/local/tomcat7/bin/catalina.sh", "run"]

