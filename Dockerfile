FROM ubuntu:14.04

MAINTAINER Brady and Branko <gwen-interpreter@googlegroups.com>

#================================================
# Customize sources for apt-get
#================================================
RUN  echo "deb http://archive.ubuntu.com/ubuntu trusty main universe\n" > /etc/apt/sources.list \
  && echo "deb http://archive.ubuntu.com/ubuntu trusty-updates main universe\n" >> /etc/apt/sources.list

#========================
# Miscellaneous packages
# Includes minimal runtime used for executing non GUI Java programs
#========================
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    ca-certificates \
    openjdk-7-jre-headless \
    unzip \
    wget \
  && rm -rf /var/lib/apt/lists/* \
  && sed -i 's/\/dev\/urandom/\/dev\/.\/urandom/' ./usr/lib/jvm/java-7-openjdk-amd64/jre/lib/security/java.security

RUN mkdir /opt/jdk \
   && cd /opt \
   && wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u5-b13/jdk-8u5-linux-x64.tar.gz \
   && tar -zxf jdk-8u5-linux-x64.tar.gz -C /opt/jdk \
   && update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_05/bin/java 100 \
   && update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_05/bin/javac 100
   
RUN cd /opt \
   && wget https://github.com/joewalnes/websocketd/releases/download/v0.2.11/websocketd-0.2.11-linux_amd64.zip \
   && unzip websocketd-0.2.11-linux_amd64.zip

#==========
# gwen-web
#==========
RUN  mkdir -p /opt/gwen-web \
  && cd /opt/gwen-web \ 
  && wget --no-verbose https://oss.sonatype.org/content/repositories/snapshots/org/gweninterpreter/gwen-web_2.11/1.0.0-SNAPSHOT/gwen-web_2.11-1.0.0-SNAPSHOT.zip -O /opt/gwen-web/gwen-web.zip \
  && unzip gwen-web


ADD gwen.properties /opt/gwen-web/
#ADD runGwenWeb.sh /opt/gwen-web/

#RUN chmod a+x /opt/gwen-web/runGwenWeb.sh

#============================
#gwen-web update properties
#============================
RUN echo 'gwen.web.browser=chrome' >> /opt/gwen-web/gwen.properties \
 && echo 'gwen.web.remote.url=http://hub:4444/wd/hub' >> /opt/gwen-web/gwen.properties \
 && echo 'gwen.web.capture.screenshots=true' >> /opt/gwen-web/gwen.properties \
 && echo '#!/bin/bash' > /opt/gwen-web/runMe.sh  \
 && echo 'if [ -f "/tmp/gwen.properties" ]; then export GWEN_PROPERTIES=/tmp/gwen.properties; else export GWEN_PROPERTIES=/opt/gwen-web/gwen.properties; fi' >> /opt/gwen-web/runMe.sh \
 && echo 'gwen-web-1.0.0-SNAPSHOT/bin/gwen-web /features -b -r /reports -p ${GWEN_PROPERTIES} --parallel' >> /opt/gwen-web/runMe.sh \
 && chmod +x /opt/gwen-web/runMe.sh

#========================================
# Add normal user with passwordless sudo
#========================================
RUN sudo useradd gwen --shell /bin/bash --create-home \
  && sudo usermod -a -G sudo gwen \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'gwen:gwen' | chpasswd

