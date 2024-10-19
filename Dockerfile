# Use an official Ubuntu 24.04 image as the base
FROM ubuntu:24.04

# Set environment variable to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update package list
RUN apt-get update

# Install software-properties-common and dependencies
RUN apt-get install -y software-properties-common lsb-release apt-transport-https ca-certificates

# Install snapd and Certbot via snap
RUN apt-get install -y snapd
RUN snap install core && snap refresh core
RUN snap install --classic certbot
RUN ln -s /snap/bin/certbot /usr/bin/certbot

# Add PHP PPA repository
RUN add-apt-repository ppa:ondrej/php

# Update package list again after adding PPA
RUN apt-get update

# Install PHP 7.4 and necessary PHP extensions
RUN apt-get install -y \
    php7.4 \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-xml \
    php7.4-mbstring \
    php7.4-json \
    php7.4-zip \
    libapache2-mod-php7.4

# Install Apache2 and mod_ssl for HTTPS support
RUN apt-get install -y apache2 ssl-cert

# Install necessary build tools and libraries
RUN apt-get install -y unzip zip curl libzip-dev libpng-dev libonig-dev libxml2-dev libssl-dev libcurl4-openssl-dev pkg-config zlib1g-dev build-essential autoconf libtool libmhash-dev

# Enable Apache modules: rewrite and SSL
RUN a2enmod rewrite ssl

# Set working directory to the Apache document root
WORKDIR /var/www/html

# Download the latest EQdkp Plus core from the official site
RUN curl -L https://eqdkpplus.github.io/packages/core/eqdkp-plus_2.3.39_fullpackage.zip -o eqdkp-plus.zip

# Unzip the application into the root of /var/www/html and remove the zip file
RUN unzip -o eqdkp-plus.zip && rm eqdkp-plus.zip

# Set folder permissions for the web root
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Install Certbot (for SSL certificate management)
RUN apt-get install -y certbot python3-certbot-apache

# Environment variables for Certbot (inject secrets via Docker Compose or .env file)
ENV CERTBOT_EMAIL=${CERTBOT_EMAIL}
ENV DOMAIN_NAME=${DOMAIN_NAME}

# Expose both HTTP (80) and HTTPS (443) ports
EXPOSE 80
EXPOSE 443

# On first boot, setup Certbot and generate SSL certificates
RUN mkdir -p /var/www/certbot

# Set entrypoint script to check for SSL certificates and run Certbot
COPY ./certbot/certbot-entrypoint.sh /usr/local/bin/certbot-entrypoint.sh
RUN chmod +x /usr/local/bin/certbot-entrypoint.sh

# Start Apache and run Certbot in the background for certificate renewal
ENTRYPOINT ["/usr/local/bin/certbot-entrypoint.sh"]
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
