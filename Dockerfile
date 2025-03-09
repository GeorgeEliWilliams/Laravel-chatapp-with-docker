# PHP Image  
FROM php:8.1 as php  

RUN apt-get update -y && apt-get install -y unzip libpq-dev libcurl4-gnutls-dev  
RUN docker-php-ext-install pdo pdo_mysql bcmath  

# Install Redis extension  
RUN pecl install -o -f redis && rm -rf /tmp/pear && docker-php-ext-enable redis  

WORKDIR /var/www  
COPY . .  

# Copy Composer from official image  
COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer  

ENV PORT=8000  
ENTRYPOINT [ "docker/entrypoint.sh" ]  

# ==============================================================================  
# Node.js Image  
FROM node:14-alpine as node  

WORKDIR /var/www  
COPY . .  

RUN npm install --global cross-env && npm install  

VOLUME /var/www/node_modules  
