FROM php:7.4-fpm-alpine

# 安装依赖并配置安装扩展
RUN apk add --no-cache freetype-dev libjpeg-turbo-dev libpng-dev libzip-dev libpng libjpeg-turbo \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install bcmath exif gd gettext imagick intl mysqli pcntl pdo_mysql redis shmop soap sockets sysvsem xmlrpc xsl zip opcache \
    && apk del libpng-dev libjpeg-turbo-dev \
    && rm -rf /var/cache/apk/*

# 复制自定义PHP-FPM配置文件到容器
COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf

# 添加自定义的PHP配置文件
COPY custom-php.ini $PHP_INI_DIR/conf.d/

EXPOSE 9074
