#!/bin/bash

# Set the HOSTNAME variable to the value of the 'hostname' key in the app_conf.yml file
HOSTNAME=$(sed -n 's/^hostname:\s*//p' /app/app_conf.yml)

# Start the Gunicorn server with the specified configuration
# Bind to all network interfaces on port 8443
# Use the fullchain.pem and privkey.pem files from Let's Encrypt for TLS
# Use a timeout of 300 seconds
# Serve the 'app' Flask application
gunicorn -b 0.0.0.0:8443 --certfile=/etc/letsencrypt/live/$HOSTNAME/fullchain.pem --keyfile=/etc/letsencrypt/live/$HOSTNAME/privkey.pem --timeout 180 --workers 4 app:app
