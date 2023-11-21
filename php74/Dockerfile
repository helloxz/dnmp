from php:7.4-fpm-alpine
RUN apk add --no-cache libpng libpng-dev libjpeg-turbo libjpeg-turbo-dev && \
    docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ && \
    docker-php-ext-install gd && \
    apk del libpng-dev libjpeg-turbo-dev
RUN docker-php-ext-install bcmath exif gd gettext imagick intl mysqli pcntl pdo_mysql redis shmop soap sockets sysvsem xmlrpc xsl zip opcache
RUN rm -rf /var/cache/apk/*
# 复制自定义PHP-FPM配置文件到容器
COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf
# 添加自定义的PHP配置文件
COPY custom-php.ini $PHP_INI_DIR/conf.d/
EXPOSE 9074