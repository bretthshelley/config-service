
to see a configuration without a defined profile:

	http://localhost:8888/resume-tailor-service/default

	this corresponds to the git file resume-tailor-service.properties


to see a configuration with the development profile

	http://localhost:8888/resume-tailor-service/development/

	this corresponds to the git file resume-tailor-service-development properties


starting the config server on windows:

	java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8002 -DCONFIG_SERVER_GIT=c:\\dev\\config-server-git -jar .\build\libs\config-service-1.0.jar

specify the CONFIG_SERVER_GIT value as an environment property in docker


build docker container at project root

	docker build -t resumetailor/config-service:1.0 .
	
run docker container in debugging mode 

	docker run -d -p 8002:8002 -p 8888:8888 resumetailor/config-service:1.0	