
#!/bin/bash

# Create directory if doesn't exist
mkdir -p /usr/share/nginx/html/news-app

# Stop nginx if running
systemctl stop nginx || true

# Clean up existing files
rm -rf /usr/share/nginx/html/news-app/*

# Create nginx config only if it doesn't exist
if [ ! -f "/etc/nginx/conf.d/news-app.conf" ]; then
    cat <<EOF | sudo tee /etc/nginx/conf.d/news-app.conf
server {
    listen 80;
    server_name _;
    
    root /usr/share/nginx/html/news-app;

    location / {
        try_files \$uri \$uri/ /index.html;
    }
    location /api {
        proxy_pass http://localhost:4000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    location /static/ {
        try_files \$uri =404;
    }

    location = /index.html {
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        add_header Pragma "no-cache";
        add_header Expires "0";
    }
}
EOF
fi

# Verify nginx configuration
nginx -t || exit 1