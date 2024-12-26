#!/bin/bash
unzip -o build.zip -d /usr/share/nginx/html/news-app
mkdir -p /usr/share/nginx/html/news-app
systemctl start nginx