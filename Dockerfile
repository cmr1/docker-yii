FROM php:7-fpm

LABEL maintainer "Charlie McClung <charlie@cmr1.com>"

RUN apt-get update && apt-get install -y \
    vim build-essential mysql-client git \
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

RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    # Make sure we're installing what we think we're installing!
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --snapshot \
    && rm -f /tmp/composer-setup.*

# Allow us to customize the entrypoint of the image.
COPY wait-for-it.sh /
COPY docker-entrypoint.sh /

RUN chmod +x /wait-for-it.sh && chmod +x /docker-entrypoint.sh

WORKDIR /var/www/html

# COPY ./src/composer.json .

# RUN composer global require "composer-plugin-api:^1.0.0" && composer global require "fxp/composer-asset-plugin:~1.1.3"
# RUN composer install

COPY ./src/ .

VOLUME [ "/var/www/html" ]

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm"]