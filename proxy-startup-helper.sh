#!/bin/bash

# Remove the proxy container if it exists, then run it again
sudo docker stop proxy
sudo docker rm proxy
sudo docker run -d --privileged --name proxy -p 8443:8443 -v /etc/letsencrypt:/etc/letsencrypt proxy:latest
