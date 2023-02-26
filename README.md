# Create the environment

Create an <bold>Ubuntu 18.04</bold> machine and assign it a <bold>DNS address</bold>.
<br><br>
Expose <bold>port 8443</bold> and <bold>port 80</bold> on your machine.

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

# Make the setup script executable and run it
```chmod +x init.sh```
<br><br>
then
<br><br>
```./init.sh```

# That's all
The endpoint should be available at 
```<your hostname>:8443/proxy/historicjoa?```