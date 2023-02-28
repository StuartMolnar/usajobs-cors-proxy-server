#!/bin/bash

# Remove the proxy container if it exists, then run it again
sudo docker stop proxy
sudo docker rm proxy

# Start the docker container on port 8443, and pass in SSL/TLS certification
sudo docker run -d --privileged --name proxy -p 8443:8443 -v /etc/letsencrypt:/etc/letsencrypt proxy:latest
