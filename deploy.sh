#!/bin/bash

# Update the system packages
sudo yum update -y


# volume-mount
VOLUME_ID="vol-0cc6251a78b383605"  # Your EBS volume ID
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# Attach the volume
aws ec2 attach-volume \
    --volume-id $VOLUME_ID \
    --instance-id $INSTANCE_ID \
    --device /dev/xvdf

# Device and Mount Point

DEVICE="/dev/xvdf"
MOUNT_POINT="/mnt/mongodb"
while [ ! -e $DEVICE ]; do 
echo "Waiting for device $DEVICE to appear..."
sleep 1; 
done

# Check if the device is formatted as ext4
if ! blkid $DEVICE | grep -q "TYPE=\"ext4\""; then
echo "Formatting $DEVICE as ext4..."
# Ensure the device is not mounted before formatting
sudo umount $DEVICE || true
sudo mkfs.ext4 $DEVICE
fi

# Create the mount point if it doesn't exist
sudo mkdir -p $MOUNT_POINT

# Mount the device
echo "Mounting $DEVICE to $MOUNT_POINT..."
sudo mount $DEVICE $MOUNT_POINT

# Update /etc/fstab to ensure persistence
if ! grep -qs "$DEVICE" /etc/fstab; then
echo "$DEVICE $MOUNT_POINT ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab
fi


sudo yum install -y ruby wget

# Install AWS CodeDeploy agent
cd ~
wget https://aws-codedeploy-us-west-2.s3.us-west-2.amazonaws.com/latest/install
chmod +x ./install
./install auto

# Install Docker
yum install -y docker

# Start Docker service
systemctl start docker

# Enable Docker to start on boot
systemctl enable docker

# Add current user to docker group to run docker commands without sudo
usermod -a -G docker $USER

DOCKER_COMPOSE_VERSION="v2.20.0"
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


# Display Docker and Docker Compose versions to verify installation
docker --version
docker compose version

echo "Docker and Docker Compose installation completed. Please log out and log back in for group changes to take effect."