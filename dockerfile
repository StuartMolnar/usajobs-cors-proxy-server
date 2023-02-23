# Start from a base image with Ubuntu 18.04
FROM ubuntu:18.04

# Install Python 3.9 and other necessary packages
RUN apt-get update && \
    apt-get install -y python3.7 python3-pip && \
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

# Start the application using gunicorn with SSL/TLS encryption
# The command listens on port 8443 and uses the Flask app defined in app.py
# It reads the server hostname from app_conf.yml to retrieve the SSL/TLS certificate and key files
CMD ["sh", "-c", "gunicorn -b 0.0.0.0:8443 --certfile=/etc/letsencrypt/live/$(grep hostname app_conf.yml | cut -d ':' -f 2 | xargs)/fullchain.pem --keyfile=/etc/letsencrypt/live/$(grep hostname app_conf.yml | cut -d ':' -f 2 | xargs)/privkey.pem --timeout 300 app:app"]

