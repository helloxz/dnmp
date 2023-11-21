FROM php:7.4-fpm-alpine

# 安装gd扩展和其他扩展的依赖
RUN apk add --no-cache freetype-dev libjpeg-turbo-dev libpng-dev libzip-dev libpng libjpeg-turbo \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install gd bcmath exif gettext intl mysqli pcntl pdo_mysql shmop soap sockets sysvsem xmlrpc xsl zip opcache

# 安装 ImageMagick 和 imagick
RUN apk add --no-cache imagemagick imagemagick-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && pecl install redis \
    && docker-php-ext-enable redis

# 删除不再需要的依赖
RUN apk del freetype-dev libjpeg-turbo-dev libpng-dev \
    && rm -rf /var/cache/apk/*

# 复制自定义PHP-FPM配置文件到容器
COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf

# 添加自定义的PHP配置文件
COPY custom-php.ini $PHP_INI_DIR/conf.d/

EXPOSE 9074
