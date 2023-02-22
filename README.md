# Clone the repository
```git clone https://github.com/StuartMolnar/usajobs-cors-proxy-server.git```<br><br>
then<br><br>
```cd usajobs-cors-proxy-server```

# Make the setup script executable
```chmod +x init.sh```

# Execute the setup script
```./init.sh```

# Create the proxy service
```sudo nano /etc/systemd/system/proxy.service```
<br><br>then enter<br>

``` proxy.service
[Unit]
Description=Proxy Server Service
After=network.target

[Service]
User=azureuser
WorkingDirectory=/home/azureuser/usajobs-cors-proxy-server
ExecStart=/bin/bash -c "sudo /usr/bin/python3 /home/azureuser/usajobs-cors-proxy-server/app.py"
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog

[Install]
WantedBy=multi-user.target
```

# Reload services
```sudo systemctl daemon-reload```

# Start the service
```sudo systemctl start proxy.service```

# Check status of service
```sudo systemctl status proxy.service
