#!/bin/bash

# Prompt the user for the new values
read -p "Enter the new hostname (current: $hostname): " new_hostname
read -p "Enter the new email (current: $email): " new_email

# Update the hostname and email values in the app_conf.yml file
sed -i "s/hostname: $hostname/hostname: $new_hostname/g" app_conf.yml
sed -i "s/email: $email/email: $new_email/g" app_conf.yml

# Update the values for the hostname and email
hostname=$(grep -oP 'hostname: \K.*' app_conf.yml)
email=$(grep -oP 'email: \K.*' app_conf.yml)

echo "New values set:"
echo "  hostname: $new_hostname"
echo "  email: $new_email"

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
