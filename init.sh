#!/bin/bash

# Get variables from the configuration file
hostname=$(grep -oP 'hostname: \K.*' app_conf.yml)
email=$(grep -oP 'email: \K.*' app_conf.yml)

# Install necessary packages
sudo apt-get update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" -y
sudo apt-get update
sudo apt-cache policy docker-ce
sudo apt install docker-ce -y

# Build the Docker image
sudo docker build -t proxy:latest .

# Install Certbot
sudo snap install core
sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# Request SSL/TLS certificate using Certbot
sudo certbot certonly --non-interactive --agree-tos --standalone -d "$hostname" --email "$email"

# Move the Systemd service unit file and start the service
sudo mv proxy.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl start proxy
