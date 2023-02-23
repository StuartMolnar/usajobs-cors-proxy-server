# Start from a base image with Ubuntu 18.04
FROM ubuntu:18.04

# Install Python 3.9 and other necessary packages
RUN apt-get update && \
    apt-get install -y python3.7 python3-pip && \
    apt-get install -y systemd && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the app.py file into the container
COPY app.py .

# Copy the configuration file into the container
COPY app_conf.yml .

# Copy the requirements file into the container
COPY requirements.txt .

# Install any necessary dependencies
RUN pip3 install -r requirements.txt

# Expose the port that the app will run on
EXPOSE 8443

# Enable the proxy service
COPY proxy.service /etc/systemd/system/proxy.service

RUN systemctl enable proxy.service

# Start systemd as the container's entrypoint
CMD ["/sbin/init"]


