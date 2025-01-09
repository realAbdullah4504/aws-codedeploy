#!/bin/bash

# Update the system packages
sudo yum update -y

sudo yum install -y ruby wget

# Install AWS CodeDeploy agent
cd ~
wget https://aws-codedeploy-us-west-2.s3.us-west-2.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

# Install Docker
sudo yum install -y docker

# Start Docker service
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker

# Add current user to docker group to run docker commands without sudo
sudo usermod -a -G docker $USER

DOCKER_COMPOSE_VERSION="v2.20.0"
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


# Display Docker and Docker Compose versions to verify installation
docker --version
docker compose version

echo "Docker and Docker Compose installation completed. Please log out and log back in for group changes to take effect."