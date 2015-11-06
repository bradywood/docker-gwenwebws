#!/bin/bash -x
#
# This bash script is to allow a user to run gwen from anywhere passing in
# both a feature directory and report directory.
# Args: feature directory
#       report directory

HOST_USER_ID=`id -u`
HOST_GROUP_ID=`id -g`
BROWSER_TYPE=${BROWSER_TYPE:-chrome}
BROWSER_COUNT=${BROWSER_COUNT:-3}
DEBUG=${DEBUG:-false}
DOCKER_GWENWEB_NAME=dockergwenweb
BROWSER_VNCPORT=

PID=$$

if [ "$#" -eq 2 ]
then
  DOCKER_CMD="docker"
  GWEN_IMAGE=gwen/gwenweb

  export FEATURE_DIRECTORY=$1
  export META_DIRECTORY=$1
  export REPORTS_DIRECTORY=$2

  mkdir -p $REPORTS_DIRECTORY;
  echo $REPORTS_DIRECTORY
  export ABSOLUTE_REPORTS_PATH=$(cd `dirname "$REPORTS_DIRECTORY"` && pwd)/`basename "$REPORTS_DIRECTORY"`

  echo $ABSOLUTE_REPORTS_PATH

  #docker run with proxy.
  #next up configure it to use browsermob proxy then get browsermob proxy to be the proxy to the world.  browsermobproxy has a restful client.
  #need to put in TZ=Australia
  #need to ensure trustAllSSLCertificates is set
  docker run --rm --name=grid -p 4444:24444 -p 5920:25900 -p 6080:26080 -e http_proxy=http://172.17.42.1:3128 -e https_proxy=http://172.17.42.1:3128 -e no_proxy=localhost,127.0.0.1 -e NOVNC=true -e VNC_PASSWORD=secret elgalu/selenium

  #${DOCKER_CMD} run -d -P --name ${DOCKER_GWENWEB_NAME}_hub_1 selenium/hub

  if [ "$DEBUG" == true ]
  then
    DEBUG="-debug"
    BROWSER_VNCPORT="-p 5900"
  else
    DEBUG=""
  fi

  #start the browsers
  #for INSTANCE in $(eval echo "{0..$((BROWSER_COUNT - 1))}")
  #do
  #  echo "starting ${BROWSER_TYPE}{DEBUG} as instance: $INSTANCE"
  #  echo "need to config this if there is a proxy"
  #  
  #  ${DOCKER_CMD} run -d -P \
  #    --name ${DOCKER_GWENWEB_NAME}_${BROWSER_TYPE}_${INSTANCE} \
  #    --env="JAVA_OPTS=-trustAllSSLCertificates" \
  #    --env=TZ=Australia/Sydney ${BROWSER_VNCPORT} \
  #    --env=no_proxy=localhost,127.0.0.1,172.17.*,hub \
  #    --link ${DOCKER_GWENWEB_NAME}_hub_1:hub \
  #    selenium/node-${BROWSER_TYPE}${DEBUG}
  #done

  #Should parse env variables.
  #allows pushing the meta files in, then is able to handle connections.

  #If batch mode, run features, meta and produce a report.
  #${DOCKER_CMD} run --name ${DOCKER_GWENWEB_NAME}_instance_${PID} -u ${HOST_USER_ID}:${HOST_GROUP_ID} -v `pwd`:/tmp -v $FEATURE_DIRECTORY:/features -v $ABSOLUTE_REPORTS_PATH:/reports --link ${DOCKER_GWENWEB_NAME}_hub_1:hub -p 8080:8080  --workdir='/opt/gwen-web' gwen/gwenwebws bash -c "/opt/websocketd --port=8080 --devconsole gwen-web-1.0.0-SNAPSHOT/bin/gwen-web -p /opt/gwen-web/gwen.properties -m /features/*.meta"

  #if interactive mode, run meta
  #${DOCKER_CMD} run --name ${DOCKER_GWENWEB_NAME}_instance_${PID} -u ${HOST_USER_ID}:${HOST_GROUP_ID} -v `pwd`:/tmp -v $META_DIRECTORY:/meta -v $ABSOLUTE_REPORTS_PATH:/reports --link ${DOCKER_GWENWEB_NAME}_hub_1:hub -p 8080:8080  --workdir='/opt/gwen-web' gwen/gwenwebws bash -c "/opt/websocketd --port=8080 --devconsole gwen-web-1.0.0-SNAPSHOT/bin/gwen-web -p /opt/gwen-web/gwen.properties -m /meta/*.meta"
  ${DOCKER_CMD} run --name ${DOCKER_GWENWEB_NAME}_instance_${PID} -u ${HOST_USER_ID}:${HOST_GROUP_ID} -v `pwd`:/tmp -v `pwd`/gwen.properties:/opt/gwen-web/gwen.properties -v $META_DIRECTORY:/features -v $ABSOLUTE_REPORTS_PATH:/reports --link grid:hub -p 8080:8080  --workdir='/opt/gwen-web' gwen/gwenwebws bash -c "/opt/websocketd --port=8080 --devconsole gwen-web-1.0.0-SNAPSHOT/bin/gwen-web -p /opt/gwen-web/gwen.properties -m /features/*.meta"
  #needs work
  #${DOCKER_CMD} run -it --rm --name ${DOCKER_GWENWEB_NAME}_instance_${PID} -v `pwd`/gwen.properties:/opt/gwen-web/gwen.properties -u ${HOST_USER_ID}:${HOST_GROUP_ID} -v `pwd`:/tmp -v $FEATURE_DIRECTORY:/features -v $ABSOLUTE_REPORTS_PATH:/reports --link grid:hub gwen/gwenweb "-m /features/*.meta -p /opt/gwen-web/gwen.properties
  docker run --name gwenwebws -u ${HOST_USER_ID}:${HOST_GROUP_ID} -v `pwd/tmp -v `pwd`/gwen.properties:/opt/gwen-web/gwen.properties -v /home/ibdev/repos/gwen-web/features/jkvine:/features -v `pwd`/reports:/reports --link grid:hub -p 8080:8080  --workdir='/opt/gwen-web' gwen/gwenwebws bash -c "/opt/websocketd --port=8080 --devconsole gwen-web-1.0.0-SNAPSHOT/bin/gwen-web -p /opt/gwen-web/gwen.properties -m /features/*.meta"

  #sleep 10

  #PROCESSES=$(docker ps | grep ${DOCKER_GWENWEB_NAME}_ | awk 'FS=" " {printf("%s ",$1)}')
  #docker kill ${PROCESSES}
  #docker rm -f ${PROCESSES}

else
  echo "To run gwenweb, please run as follows: "
  echo "runGwenWeb.sh <feature directory> <report directory>"
fi

