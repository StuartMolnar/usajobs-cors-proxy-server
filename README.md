# Create the environment

Create an **Ubuntu 18.04** machine and assign it a **DNS address**.

<br>

Expose **port 8443** and **port 80** on your machine.

# Clone the repository
```git clone https://github.com/StuartMolnar/usajobs-cors-proxy-server.git``` -> ```cd usajobs-cors-proxy-server```

# Adjust the DNS address
Set the DNS address inside: ```nano app_config.yml```

<br>

then change ```hostname: <Your DNS Address>``` to the DNS address of your machine

# Make the setup script executable and run it
```chmod +x init.sh``` -> ```./init.sh```

# That's all
The endpoint should be available at 
```<your hostname>:8443/proxy/historicjoa?```