# Use an official Ubuntu 24.04 image as the base
FROM ubuntu:24.04

# Set environment variable to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update package list
RUN apt-get update

# Install software-properties-common and dependencies
RUN apt-get install -y software-properties-common lsb-release apt-transport-https ca-certificates

# Add PHP PPA repository
RUN add-apt-repository ppa:ondrej/php

# Update package list again after adding PPA
RUN apt-get update

# Install PHP 7.4
RUN apt-get install -y php7.4

# Install PHP MySQL extension
RUN apt-get install -y php7.4-mysql

# Install PHP cURL extension
RUN apt-get install -y php7.4-curl

# Install PHP GD extension
RUN apt-get install -y php7.4-gd

# Install PHP XML extension
RUN apt-get install -y php7.4-xml

# Install PHP Multibyte String extension
RUN apt-get install -y php7.4-mbstring

# Install PHP JSON extension
RUN apt-get install -y php7.4-json

# Install PHP ZIP extension
RUN apt-get install -y php7.4-zip

# Install Apache2
RUN apt-get install -y apache2

# Install Apache2 PHP module
RUN apt-get install -y libapache2-mod-php7.4

# Install unzip and zip utilities
RUN apt-get install -y unzip zip

# Install cURL utility
RUN apt-get install -y curl

# Install libzip-dev
RUN apt-get install -y libzip-dev

# Install libpng-dev
RUN apt-get install -y libpng-dev

# Install libonig-dev
RUN apt-get install -y libonig-dev

# Install libxml2-dev
RUN apt-get install -y libxml2-dev

# Install libssl-dev
RUN apt-get install -y libssl-dev

# Install libcurl4-openssl-dev
RUN apt-get install -y libcurl4-openssl-dev

# Install pkg-config
RUN apt-get install -y pkg-config

# Install zlib1g-dev
RUN apt-get install -y zlib1g-dev

# Install build-essential
RUN apt-get install -y build-essential

# Install autoconf
RUN apt-get install -y autoconf

# Install libtool
RUN apt-get install -y libtool

# Install libmhash-dev
RUN apt-get install -y libmhash-dev

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy local files to the container
COPY ./html/eqdkp-plus.zip /var/www/html/

# Unzip the application and remove the zip file
RUN unzip eqdkp-plus.zip && rm eqdkp-plus.zip

# Set folder permissions
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Expose port 80 for Apache
EXPOSE 80

# Start Apache server
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
