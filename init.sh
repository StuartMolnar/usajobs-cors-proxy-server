#!/bin/bash

# Get the current values for the hostname and email
hostname=$(grep -oP 'hostname:\s*\K\S+' app_conf.yml)
email=$(grep -oP 'email:\s*\K\S+' app_conf.yml)

# Prompt the user for the new values
read -p "Enter the new hostname: " new_hostname
read -p "Enter the new email: " new_email

# Replace the values in the app_conf.yml file
sed -i "s/hostname:\s*$hostname/hostname: $new_hostname/" app_conf.yml
sed -i "s/email:\s*$email/email: $new_email/" app_conf.yml

# Update the values for the hostname and email
hostname=$(grep -oP 'hostname:\s*\K\S+' app_conf.yml)
email=$(grep -oP 'email:\s*\K\S+' app_conf.yml)

echo "New values set:"
echo "  hostname: $hostname"
echo "  email: $email"

# Install necessary packages
sudo apt-get update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" -y
sudo apt-get update
sudo apt-cache policy docker-ce
sudo apt install docker-ce -y

# Install Certbot
sudo snap install core
sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# Request SSL/TLS certificate using Certbot
sudo certbot certonly --non-interactive --agree-tos --standalone -d "$hostname" --email "$email"

# Stop and remove the old Docker image/container if it exists
sudo docker stop proxy
sudo docker rm proxy
sudo docker rmi proxy:latest

# Build the Docker image with Hostname as an environment variable
sudo docker build --build-arg HOSTNAME=$hostname-t -t proxy:latest .

# Start the docker container on port 8443, and pass in SSL/TLS certification
sudo docker run -d --privileged --name proxy -p 8443:8443 -v /etc/letsencrypt:/etc/letsencrypt proxy:latest

# Stop the docker container to prepare it for the service
sudo docker stop proxy

# Remove the proxy-container service if it exists
sudo systemctl stop proxy-startup.service
sudo systemctl disable proxy-startup.service
sudo systemctl daemon-reload
sudo rm /etc/systemd/system/proxy-startup.service
sudo rm /run/systemd/system/proxy-startup.service.*
sudo systemctl daemon-reload

# Create the proxy-container service which will start the docker container on boot
sudo mv proxy-startup.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable proxy-startup.service
sudo systemctl start proxy-startup.service
