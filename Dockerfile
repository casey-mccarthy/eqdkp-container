# Use an official Ubuntu 24.04 image as the base
FROM ubuntu:24.04

# Set environment variable to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-venv \
    libaugeas0 \
    software-properties-common \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    apache2 \
    ssl-cert \
    unzip \
    zip \
    curl \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    pkg-config \
    zlib1g-dev \
    build-essential \
    autoconf \
    libtool \
    libmhash-dev

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

# Set up Python virtual environment for Certbot
RUN python3 -m venv /opt/certbot \
    && /opt/certbot/bin/pip install --upgrade pip \
    && /opt/certbot/bin/pip install certbot certbot-apache

# Symlink Certbot to /usr/bin to make it easily accessible
RUN ln -s /opt/certbot/bin/certbot /usr/bin/certbot

# Copy the Certbot entrypoint script into the container
COPY ./certbot/certbot-entrypoint.sh /usr/local/bin/certbot-entrypoint.sh

# Make the script executable
RUN chmod +x /usr/local/bin/certbot-entrypoint.sh

# Expose both HTTP (80) and HTTPS (443) ports
EXPOSE 80
EXPOSE 443

# Set the entrypoint and default command
ENTRYPOINT ["/usr/local/bin/certbot-entrypoint.sh"]
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
