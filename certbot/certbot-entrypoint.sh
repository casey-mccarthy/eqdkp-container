#!/bin/bash

# Check if SSL certificate exists
if [ ! -f /etc/letsencrypt/live/${DOMAIN_NAME}/fullchain.pem ]; then
  echo "SSL certificate not found. Requesting a new certificate for ${DOMAIN_NAME}..."
  certbot --apache --non-interactive --agree-tos --email ${CERTBOT_EMAIL} -d ${DOMAIN_NAME}
else
  echo "SSL certificate found for ${DOMAIN_NAME}. Skipping certificate request."
fi

# Start certificate renewal in the background
while :; do
  certbot renew --quiet --no-self-upgrade
  sleep 12h
done
