# docker-gwenwebws

### This repo contains the logic to generally connect to gwen-web, however recently have uploaded the gwen-rest.
### need to make it work for bot

### To get the rest engine
```
download gwen-rest
run ...
copy the zip file to this location, 
run docker build -t gwen/gwenwebws .
```

### Run the terraform script found in
```
https://github.com/bradywood/gwen-scraper.git
```

### Copy the aws url to the gwen.properties file found in this repo.
```
eg.  gwen.web.remote.url=https://ec2-13-211-147-42.ap-southeast-2.compute.amazonaws.com:4444/wd/hub
```

### Run the bootGwenWeb.sh startGwenWS
this starts the websocket version of gwen connecting to AWS grid

## websocket client for terminal
```
git clone https://github.com/danielstjules/wsc.git
npm install

node wsc http://localhost:8080  <--websocket exposed during startGwenWS which uses websocketd
```
