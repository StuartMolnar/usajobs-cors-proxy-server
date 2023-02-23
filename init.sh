#!/bin/bash

# Get the current values for the hostname and email
hostname=$(grep -oP 'hostname:\s*\K\S+' app_conf.yml)
email=$(grep -oP 'email:\s*\K\S+' app_conf.yml)

# Prompt the user for the new values
read -p "Enter the new hostname (current: $hostname): " new_hostname
read -p "Enter the new email (current: $email): " new_email

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
