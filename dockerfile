#FROM php:7.3.6-fpm-alpine3.9
FROM php:8.0.1-fpm-alpine3.13

RUN apk add bash mysql-client --no-cache shadow

RUN apk add --no-cache openssl

RUN docker-php-ext-install pdo pdo_mysql

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Definindo diretorio de trabajo
WORKDIR /var/www

# Eliminando carpeta html que viene por defecto en php-fpm
RUN rm -rf /var/www/html

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiando todo de mi pasta al container
COPY . /var/www

RUN composer install

# Link simbolico de html to public do laravel
RUN ln -s public html

RUN usermod -u 1000 www-data

USER www-data

# Exponiendo el puerto
EXPOSE 9000

# Comando para mantener servicio de php activo
ENTRYPOINT ["php-fpm"]