FROM php:7.4-fpm-alpine3.13

# 安装gd扩展和其他扩展的依赖
RUN apk add --no-cache autoconf g++ make libxslt libxslt-dev libxml2 libxml2-dev icu-dev freetype-dev libjpeg-turbo-dev libpng-dev libzip-dev libpng libjpeg-turbo gettext-dev \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install gd bcmath exif gettext intl mysqli pcntl pdo_mysql shmop soap sockets sysvsem xmlrpc xsl zip opcache \
    && apk add --no-cache imagemagick imagemagick-dev \ 
    && yes | pecl install imagick-3.7.0 \ 
    && docker-php-ext-enable imagick \
    && pecl install redis-6.0.2 \ 
    && no | docker-php-ext-enable redis \
    && apk del freetype-dev libjpeg-turbo-dev libpng-dev libxml2-dev libxslt-dev autoconf g++ make imagemagick-dev \ 
    && rm -rf /var/cache/apk/* \
    && mkdir -p /usr/local/log \
    && sed -i 's/9000/127.0.0.1:9074/' /usr/local/etc/php-fpm.d/zz-docker.conf


# 复制自定义PHP-FPM配置文件到容器
COPY ./www.conf /usr/local/etc/php-fpm.d/www.conf

# 添加自定义的PHP配置文件
COPY ./php.ini $PHP_INI_DIR/conf.d/

EXPOSE 9074
