FROM tomcat:latest
RUN mkdir /usr/local/tomcat
RUN mkdir /usr/local/tomcat/webapps
RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps
COPY ./*.war /usr/local/tomcat/webapps

