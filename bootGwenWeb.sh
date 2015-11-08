

#PROXY //proxy should be host and port of the docker host. please use <ip>:<port> don't specify protocol
HOST_USER_ID=`id -u`
HOST_GROUP_ID=`id -g`

export PROXY_COMMAND=
export VNC_COMMAND=
export PORTS_COMMAND=${PORTS_COMMAND:-"-p 4444:24444"}

function addProxy () {
  if [ -z "$PROXY" ]; then
    echo "Adding in proxy to the docker image"
    export PROXY_COMMAND="-e http_proxy=http://${PROXY} -e https_proxy=https://${PROXY} -e no_proxy=localhost,127.0.0.1"
  fi
}

function addVNC () {
  export VNC_COMMAND="-e NOVNC=true -e VNC_PASSWORD=secret"
  export PORTS_COMMAND="${PORTS_COMMAND} -p 6080:26080 -p 5920:25900"
}

function startSelenium () {

#  //build up the command
  addProxy
  addVNC

  docker run -d --rm --name=grid ${PORTS_COMMAND} ${PROXY_COMMAND} ${VNC_COMMAND} elgalu/selenium
  #docker run --rm --name=grid -p 4444:24444 -p 5920:25900 -p 6080:26080 -e http_proxy=http://172.17.42.1:3128 -e https_proxy=http://172.17.42.1:3128 -e no_proxy=localhost,127.0.0.1 -e NOVNC=true -e VNC_PASSWORD=secret elgalu/selenium
}

function startGwenWebSocket() {
  docker run --name gwenwebws -u ${HOST_USER_ID}:${HOST_GROUP_ID} -v `pwd`:/tmp -v `pwd`/gwen.properties:/opt/gwen-web/gwen.properties -v /home/ibdev/repos/gwen-web/features/jkvine:/features -v `pwd`/reports:/reports --link grid:hub -p 8080:8080  --workdir='/opt/gwen-web' gwen/gwenwebws bash -c "/opt/websocketd --port=8080 --devconsole gwen-web-1.0.0-SNAPSHOT/bin/gwen-web -p /opt/gwen-web/gwen.properties -m /features/*.meta"
}

function startGwen() {
 :
}

startSelenium
startGwenWebSocket
