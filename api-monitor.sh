#!/bin/bash

# Define the port used by the proxy
PROXY_PORT=8443

# Wait for any ongoing API requests
while true; do
  # Check if there are any connections on the specified port
  CONNECTIONS=$(netstat -tna | grep -c ":${PROXY_PORT} .*ESTABLISHED")

  # If there are no connections, start the proxy service and exit
  if [ $CONNECTIONS -eq 0 ]; then
    echo "No ongoing API requests found. Starting proxy service..."
    systemctl start proxy-startup.service
    exit 0
  fi

  # If there are connections, wait 5 minutes and check again
  echo "Ongoing API requests found. Waiting 5 minutes..."
  sleep 300
done
