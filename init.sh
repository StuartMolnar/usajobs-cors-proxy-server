#!/bin/bash

# Get the current values for the hostname and email
hostname=$(grep -oP 'hostname:\s*\K\S+' app_conf.yml)
email=$(grep -oP 'email:\s*\K\S+' app_conf.yml)

# Prompt the user for the new values
read -p "Enter the new hostname: " new_hostname
read -p "Enter the new email: " new_email

# Replace the values in the app_conf.yml file
sed -i "s/^hostname: .*$/hostname: $new_hostname/" app_conf.yml
sed -i "s/^email: .*$/email: $new_email/" app_conf.yml

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

# Build the Docker image
sudo docker build --progress=plain -t proxy:latest .

# Remove the proxy-startup service if it exists
sudo systemctl stop proxy-startup.service
sudo systemctl disable proxy-startup.service
sudo systemctl daemon-reload
sudo rm /etc/systemd/system/proxy-startup.service
sudo rm /run/systemd/system/proxy-startup.service.*
sudo systemctl daemon-reload

# Create the proxy-startup service which will start the docker container on boot
chmod +x proxy-startup-helper.sh
sudo mv proxy-startup-helper.sh /usr/local/bin
sudo mv proxy-startup.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable proxy-startup.service
sudo systemctl start proxy-startup.service
