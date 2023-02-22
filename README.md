# Clone the repository
```git clone https://github.com/StuartMolnar/usajobs-cors-proxy-server.git```
<br><br>
then
<br><br>
```cd usajobs-cors-proxy-server```

# Adjust the DNS address
```nano app_config.yml```
<br><br>
then change
<br>

```hostname: usajobs-cors-proxy.westus3.cloudapp.azure.com```
<br><br>
to the DNS address of your machine

# Make the setup script executable
```chmod +x init.sh```

# Execute the setup script
```./init.sh```

# Create the proxy service
```sudo nano /etc/systemd/system/proxy.service```
<br><br>
then enter
<br>
note: adjust WorkingDirectory and ExecStart to replace "azureuser" with your own username
<br>

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
```sudo systemctl status proxy.service```
<br><br>
this should return:
<br><br>
``` proxy service output
● proxy.service - Proxy Server Service
   Loaded: loaded (/etc/systemd/system/proxy.service; disabled; vendor preset: enabled)
   Active: active (running) since Wed 2023-02-22 08:33:22 UTC; 4min 35s ago
 Main PID: 21462 (sudo)
    Tasks: 2 (limit: 446)
   CGroup: /system.slice/proxy.service
           ├─21462 sudo /usr/bin/python3 /home/azureuser/usajobs-cors-proxy-server/app.py
           └─21473 /usr/bin/python3 /home/azureuser/usajobs-cors-proxy-server/app.py

Feb 22 08:33:22 cors-proxy-service sudo[21462]: pam_unix(sudo:session): session opened for user root by (uid=0)
Feb 22 08:33:22 cors-proxy-service bash[21462]:  * Serving Flask app 'app' (lazy loading)
Feb 22 08:33:22 cors-proxy-service bash[21462]:  * Environment: production
Feb 22 08:33:22 cors-proxy-service bash[21462]:    WARNING: This is a development server. Do not use it in a production deployment.
Feb 22 08:33:22 cors-proxy-service bash[21462]:    Use a production WSGI server instead.
Feb 22 08:33:22 cors-proxy-service bash[21462]:  * Debug mode: off
Feb 22 08:33:22 cors-proxy-service bash[21462]:  * Running on all addresses.
Feb 22 08:33:22 cors-proxy-service bash[21462]:    WARNING: This is a development server. Do not use it in a production deployment.
Feb 22 08:33:22 cors-proxy-service bash[21462]:  * Running on https://10.1.0.4:443/ (Press CTRL+C to quit)
```