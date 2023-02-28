#!/bin/bash
HOSTNAME=$(sed -n 's/^hostname:\s*//p' /app/app_conf.yml)

gunicorn -b 0.0.0.0:8443 --certfile=/etc/letsencrypt/live/$HOSTNAME/fullchain.pem --keyfile=/etc/letsencrypt/live/$HOSTNAME/privkey.pem --timeout 300 app:app
