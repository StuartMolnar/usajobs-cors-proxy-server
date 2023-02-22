#!/bin/bash

# Read the hostname value from the app_conf.yml file
hostname=$(grep -oP 'hostname: \K.*' app_conf.yml)

# Update and install Python 3.7 and pip
sudo apt-get update -y
sudo apt-get install -y python3.7
sudo apt-get install -y python3-pip

# Install the required packages
pip3 install -r requirements.txt

# Install and run Certbot to obtain the SSL certificate
sudo snap install core
sudo snap refresh core
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot certonly --standalone -d "$hostname"
