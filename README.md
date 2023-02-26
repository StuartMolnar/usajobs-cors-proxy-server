# Create the environment

Create an <bold>Ubuntu 18.04</bold> machine and assign it a <bold>DNS address</bold>.
<br><br>
Expose <bold>port 8443</bold> and <bold>port 80</bold> on your machine.

# Clone the repository
```git clone https://github.com/StuartMolnar/usajobs-cors-proxy-server.git``` -> ```cd usajobs-cors-proxy-server```

# Adjust the DNS address
Set the DNS address inside: ```nano app_config.yml```
<br><br>
then change
<br>

```hostname: <Your DNS Address>```
<br><br>
to the DNS address of your machine

# Make the setup script executable and run it
```chmod +x init.sh``` -> ```./init.sh```

# That's all
The endpoint should be available at 
```<your hostname>:8443/proxy/historicjoa?```