
# Update system packages
sudo yum update -y

# Install the nginx package
sudo yum install nginx -y

# Start nginx service
sudo systemctl start nginx

# Enable nginx to start on boot
sudo systemctl enable nginx

# Check nginx status
sudo systemctl status nginx
