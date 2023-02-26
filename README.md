# Create the environment

Create an **Ubuntu 18.04** machine and assign it a **DNS address**.

<br>

Expose **port 8443** and **port 80** on your machine.

# Clone the repository
```git clone https://github.com/StuartMolnar/usajobs-cors-proxy-server.git``` -> ```cd usajobs-cors-proxy-server```

# Make the setup script executable and run it
```chmod +x init.sh``` -> ```./init.sh```

# That's all
The endpoint should be available at 
```<your hostname>:8443/proxy/historicjoa?```