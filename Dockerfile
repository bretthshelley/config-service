# example build command
# docker build -t resumetailor/config-service:1.1 .

# example run and connect
# docker run --rm -ti resumetailor/config-service:1.1 /bin/sh

# example run as detached
# docker run -d resumetailor/config-service:1.1

# example run with port exposed to localhost (docker host)
# docker run -d -p 8888:8888 resumetailor/config-service:1.1

# run explicitly define the cloud config server's git uri
# docker run -d -p 8888:8888 resumetailor/config-service:1.1 

FROM adoptopenjdk/openjdk16:latest

WORKDIR /java-apps/

# enables the use of netstat and curl commands to determine use of ports
RUN apt-get update && apt-get install -y net-tools && apt-get -y install git

# setup a local git repo
RUN mkdir /config-server-git
COPY ./src/main/resources/resume-tailor-service.properties /config-server-git
COPY ./src/main/resources/resume-tailor-webapp.properties /config-server-git
COPY ./src/main/resources/resume-tailor-service-development.properties /config-server-git
COPY ./src/main/resources/resume-tailor-webapp-development.properties /config-server-git

WORKDIR /config-server-git/
RUN git config --global user.email "bshelley585@gmail.com"
RUN git config --global user.name "Brett Shelley"
RUN git init 
RUN git add *.properties
RUN git commit -m "initial commit"

# setup environment variable to tell spring config service
# the value in application properties must be overridden
# spring.cloud.config.server.git.uri=C:\\dev\\config-server-git
ENV cloud.config.server.git.uri /config-server-git/ 

WORKDIR /java-apps/
COPY ./build/libs/config-service-1.1.jar /java-apps/config-service-1.1.jar

# the *:8002 part of the following line is critical for docker debugging 
ENV JAVA_TOOL_OPTIONS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8002

ENV CONFIG_SERVER_GIT /config-server-git

# run the java apps at container startup
CMD ["java", "-jar", "config-service-1.1.jar"]

EXPOSE 8888
EXPOSE 8002


