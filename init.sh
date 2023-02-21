#!/bin/bash

# Clone the repository
git clone https://usajobs-cors-proxy.westus3.cloudapp.azure.com
cd usajobs-cors-proxy-server

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
sudo certbot certonly --standalone -d usajobs-cors-proxy.westus3.cloudapp.azure.com

