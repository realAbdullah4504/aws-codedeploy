#!/bin/bash
# Device and Mount Point
DEVICE="/dev/xvdf"
MOUNT_POINT="/var/lib/mongo"

# Wait until the device exists
while [ ! -b $DEVICE ]; do
  echo "Waiting for device $DEVICE to appear..."
  sleep 5
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
