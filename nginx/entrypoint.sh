#!/bin/bash

# Set your domain name here
CLIENT_DOMAIN="sd.bchportal.com"
USERS_DOMAIN="sd.users.bchportal.com"
DEVICES_DOMAIN="sd.devices.bchportal.com"
INFO_DOMAIN="sd.info.bchportal.com"
CHAT_DOMAIN="sd.chat.bchportal.com"

# Ensure the directory for Certbot challenge files exists
mkdir -p /var/www/certbot

# Check if the certificate already exists
if [ ! -f /etc/letsencrypt/live/$DOMAIN/fullchain.pem ]; then
    # Obtain the certificate if it doesn't exist
    certbot certonly --webroot -w /var/www/certbot -d $CLIENT_DOMAIN -d $USERS_DOMAIN -d $DEVICES_DOMAIN -d $INFO_DOMAIN -d $CHAT_DOMAIN --email tudorovidiub@gmail.com --agree-tos --non-interactive
fi

# Modify NGINX to listen on port 443 for SSL
cat <<EOF > /etc/nginx/conf.d/ssl.conf
    server {
	listen 443 ssl;
	server_name $CLIENT_DOMAIN;

	ssl_certificate /etc/nginx/certificates/$CLIENT_DOMAIN/fullchain.pem;
	ssl_certificate_key /etc/nginx/certificates/$CLIENT_DOMAIN/privkey.pem;

	ssl_protocols     TLSv1.2 TLSv1.3;
	ssl_ciphers       'HIGH:!aNULL:!MD5';

	location / {
	    proxy_pass http://client:80;
	    proxy_set_header Host \$host;
	    proxy_set_header X-Real-IP \$remote_addr;
	    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
	    proxy_set_header X-Forwarded-Proto \$scheme;

	    proxy_http_version 1.1;
	    proxy_set_header Upgrade \$http_upgrade;
	    proxy_set_header Connection "upgrade";
	}
    }

    server {
	listen 443 ssl;
	server_name $USERS_DOMAIN;

	ssl_certificate /etc/nginx/certificates/$CLIENT_DOMAIN/fullchain.pem;
	ssl_certificate_key /etc/nginx/certificates/$CLIENT_DOMAIN/privkey.pem;

	ssl_protocols     TLSv1.2 TLSv1.3;
	ssl_ciphers       'HIGH:!aNULL:!MD5';

	location / {
	    proxy_pass http://users_server:7021;
	    proxy_set_header Host \$host;
	    proxy_set_header X-Real-IP \$remote_addr;
	    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
	    proxy_set_header X-Forwarded-Proto \$scheme;

	    proxy_http_version 1.1;
	    proxy_set_header Upgrade \$http_upgrade;
	    proxy_set_header Connection "upgrade";
	}
    }

    server {
	listen 443 ssl;
	server_name $DEVICES_DOMAIN;

	ssl_certificate /etc/nginx/certificates/$CLIENT_DOMAIN/fullchain.pem;
	ssl_certificate_key /etc/nginx/certificates/$CLIENT_DOMAIN/privkey.pem;

	ssl_protocols     TLSv1.2 TLSv1.3;
	ssl_ciphers       'HIGH:!aNULL:!MD5';

	location / {
	    proxy_pass http://devices_server:7022;
	    proxy_set_header Host \$host;
	    proxy_set_header X-Real-IP \$remote_addr;
	    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
	    proxy_set_header X-Forwarded-Proto \$scheme;

	    proxy_http_version 1.1;
	    proxy_set_header Upgrade \$http_upgrade;
	    proxy_set_header Connection "upgrade";
	}
    }

    server {
	listen 443 ssl;
	server_name $CHAT_DOMAIN;

	ssl_certificate /etc/nginx/certificates/$CLIENT_DOMAIN/fullchain.pem;
	ssl_certificate_key /etc/nginx/certificates/$CLIENT_DOMAIN/privkey.pem;

	ssl_protocols     TLSv1.2 TLSv1.3;
	ssl_ciphers       'HIGH:!aNULL:!MD5';

	location / {
	    proxy_pass http://chat_server:7024;
	    proxy_set_header Host \$host;
	    proxy_set_header X-Real-IP \$remote_addr;
	    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
	    proxy_set_header X-Forwarded-Proto \$scheme;

	    proxy_http_version 1.1;
	    proxy_set_header Upgrade \$http_upgrade;
	    proxy_set_header Connection "upgrade";
	}
    }
EOF

# Start NGINX in the foreground
nginx -g "daemon off;"

