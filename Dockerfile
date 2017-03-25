FROM php:7-fpm

LABEL maintainer "Charlie McClung <charlie@cmr1.com>"

RUN apt-get update && apt-get install -y \
    vim build-essential mysql-client \
    libpng-dev libmcrypt-dev libfreetype6-dev libpng12-dev libjpeg62-turbo-dev

RUN pecl install redis \
    && pecl install xdebug
    
RUN docker-php-ext-enable redis xdebug
 
RUN docker-php-ext-install -j$(nproc) mcrypt opcache pdo pdo_mysql mysqli

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd


COPY sql /sql

COPY ./app/php.d/*.ini /usr/local/etc/php/conf.d/
COPY ./app/fpm.d/*.conf /usr/local/etc/php-fpm.d/

COPY ./src/ /var/www/html/

# Allow us to customize the entrypoint of the image.
COPY wait-for-it.sh /
COPY docker-entrypoint.sh /

RUN chmod +x /wait-for-it.sh && chmod +x /docker-entrypoint.sh

VOLUME [ "/var/www/html" ]

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm"]