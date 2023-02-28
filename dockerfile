# Start from a base image with Ubuntu 18.04
FROM ubuntu:18.04

# Set the hostname as an environment variable in the container
ARG HOSTNAME
ENV HOSTNAME=$HOSTNAME
RUN echo "export HOSTNAME=$HOSTNAME" >> ~/.bashrc

# Install Python 3.9 and other necessary packages
RUN apt-get update && \
    apt-get install -y python3.7 python3-pip && \
    apt-get install -y systemd && \
    apt-get install -y jq && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the required files into the container
COPY app.py .
COPY app_conf.yml .
COPY requirements.txt .
COPY proxy.service /etc/systemd/system/proxy.service
COPY proxy-helper.sh /usr/local/bin/proxy-helper.sh
RUN chmod +x /usr/local/bin/proxy-helper.sh

# Install any necessary dependencies
RUN pip3 install -r requirements.txt

# Expose the port that the app will run on
EXPOSE 8443

# Enable the proxy service
RUN systemctl enable proxy.service

# Start systemd as the container's entrypoint
CMD ["/sbin/init"]


