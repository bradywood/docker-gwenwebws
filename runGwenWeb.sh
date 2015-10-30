#!/bin/bash -x
#
# This bash script is to allow a user to run gwen from anywhere passing in
# both a feature directory and report directory.
# It will attempt to run the features against the running docker-compose selenium
# grid.  It is making an assumption that the management of the docker-compose  
# environment up to the user to start and scale appropriately.

# Args: feature directory
#       report directory

HOST_USER_ID=`id -u`
HOST_GROUP_ID=`id -g`
BROWSER_TYPE=${BROWSER_TYPE:-chrome}
BROWSER_COUNT=${BROWSER_COUNT:-3}
DEBUG=${DEBUG:-false}
DOCKER_GWENWEB_NAME=dockergwenweb

PID=$$

if [ "$#" -eq 2 ]
then
  DOCKER_CMD="docker"
  GWEN_IMAGE=gwen/gwenweb

  export FEATURE_DIRECTORY=$1
  export REPORTS_DIRECTORY=$2

  mkdir -p $REPORTS_DIRECTORY;
  echo $REPORTS_DIRECTORY
  export ABSOLUTE_REPORTS_PATH=$(cd `dirname "$REPORTS_DIRECTORY"` && pwd)/`basename "$REPORTS_DIRECTORY"`

  echo $ABSOLUTE_REPORTS_PATH


  ${DOCKER_CMD} run -d -P --name ${DOCKER_GWENWEB_NAME}_hub_1 selenium/hub

  if [ "$DEBUG" == true ]
  then
    DEBUG="-debug"
  else
    DEBUG=""
  fi

  #start the browsers
  for INSTANCE in $(eval echo "{0..$((BROWSER_COUNT - 1))}")
  do
    echo "starting ${BROWSER_TYPE}{DEBUG} as instance: $INSTANCE"
    
    ${DOCKER_CMD} run -d -P --name ${DOCKER_GWENWEB_NAME}_${BROWSER_TYPE}_${INSTANCE} --link ${DOCKER_GWENWEB_NAME}_hub_1:hub selenium/node-${BROWSER_TYPE}${DEBUG}
  done

  #Should parse env variables.
  #allows pushing the meta files in, then is able to handle connections.
  ${DOCKER_CMD} run --name ${DOCKER_GWENWEB_NAME}_instance_${PID} -u ${HOST_USER_ID}:${HOST_GROUP_ID} -v `pwd`:/tmp -v $FEATURE_DIRECTORY:/features -v $ABSOLUTE_REPORTS_PATH:/reports --link ${DOCKER_GWENWEB_NAME}_hub_1:hub -p 8080:8080  --workdir='/opt/gwen-web' gwen/gwenwebws bash -c "/opt/websocketd --port=8080 --devconsole gwen-web-1.0.0-SNAPSHOT/bin/gwen-web -p /opt/gwen-web/gwen.properties -m /features/*.meta"

  # ${DOCKER} run -d --name ${BROWSER_TYPE}_ernie_wb_${BUILD_NUMBER}_${BROWSER_INDEX} \
  #    -e "JAVA_OPTS=-trustAllSSLCertificates" ${PORT_BROWSERVNC} \
  #    --link hub_ernie_wb_${BUILD_NUMBER}:hub \
  #    --link web_ernie_wb_${BUILD_NUMBER}:web \
  #    --link webstub_ernie_wb_${BUILD_NUMBER}:webstub \
  #    --env=no_proxy=localhost,127.0.0.1,169.254.169.254,iod-artifactory.account,172.17.*,hub,web,webstub \
  #    -v /usr/share/zoneinfo/Australia/Sydney:/etc/localtime \
  #   -e=TZ=Australia/Sydney \
  #    selenium/node-${BROWSER_TYPE}${DEBUG}
  #done

  #sleep 10

  #PROCESSES=$(docker ps | grep ${DOCKER_GWENWEB_NAME}_ | awk 'FS=" " {printf("%s ",$1)}')
  #docker kill ${PROCESSES}
  #docker rm -f ${PROCESSES}

else
  echo "To run gwenweb, please run as follows: "
  echo "runGwenWeb.sh <feature directory> <report directory>"
fi

