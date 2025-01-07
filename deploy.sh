#!/bin/bash

# Update system packages
sudo yum update -y

# Install required dependencies
sudo yum install -y ruby wget

# Install AWS CodeDeploy agent
cd ~
wget https://aws-codedeploy-us-west-2.s3.us-west-2.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

# Add MongoDB Repository
cat << 'EOF' | sudo tee /etc/yum.repos.d/mongodb-org-8.0.repo
[mongodb-org-8.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/8.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-8.0.asc
EOF

# Install MongoDB components
sudo yum install -qy mongodb-mongosh-shared-openssl3
sudo yum install -y mongodb-org-8.0.4 mongodb-org-database-8.0.4 mongodb-org-server-8.0.4 mongodb-org-mongos-8.0.4 mongodb-org-tools-8.0.4

# Start MongoDB service
sudo systemctl start mongod
sudo systemctl enable mongod  # Enable MongoDB to start on boot

# Check services status
sudo service codedeploy-agent status
sudo systemctl status mongod

# Add error handling
if [ $? -ne 0 ]; then
    echo "Error: Service check failed"
    exit 1
fi