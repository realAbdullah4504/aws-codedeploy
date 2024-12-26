#!/bin/bash

# Check if nginx is already installed
if ! rpm -q nginx > /dev/null; then
    yum update -y
    yum install -y nginx
    systemctl enable nginx
fi