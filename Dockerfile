# Use an official PHP image with Apache
FROM php:7.4-apache

# Update package list
RUN apt-get update

# Install libzip-dev
RUN apt-get install -y libzip-dev

# Install zip and unzip
RUN apt-get install -y zip unzip

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

# Configure zip extension
RUN docker-php-ext-configure zip

# Install PHP extensions zip
RUN docker-php-ext-install zip

# Install PHP extensions mysqli, pdo, pdo_mysql
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Install PHP extensions mbstring
RUN docker-php-ext-install mbstring

# Install PHP extensions gd
RUN docker-php-ext-install gd

# Install PHP extensions xml
RUN docker-php-ext-install xml

# Install PHP extensions curl
RUN docker-php-ext-install curl

# Install PHP extensions json
RUN docker-php-ext-install json

# Install PHP extensions mhash
RUN apt-get install -y libmhash-dev


# Extract PHP source
RUN docker-php-source extract

# Navigate to the hash extension directory, configure, make, and install manually
RUN cd /usr/src/php/ext/hash \
    && phpize \
    && ./configure \
    && make \
    && make install

# Delete PHP source after the installation
RUN docker-php-source delete

# Install PHP extensions hash
#RUN docker-php-ext-install hash

# Install PHP extensions zlib
RUN docker-php-ext-install zlib

# Install PHP extensions openssl
RUN docker-php-ext-install openssl

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
CMD ["apache2-foreground"]
