# 说明：PHP 8.0 起核心已移除 xmlrpc 扩展，故本镜像不再包含，其余扩展与 php74 保持一致
# 构建并推送镜像：
# docker build -t helloz/php:8.3-fpm-alpine .
# docker push helloz/php:8.3-fpm-alpine
FROM php:8.3.36-fpm-alpine

# 安装gd扩展和其他扩展的依赖
RUN apk add --no-cache autoconf g++ make linux-headers libxslt libxslt-dev libxml2 libxml2-dev icu-dev freetype-dev libjpeg-turbo-dev libpng-dev libzip-dev libpng libjpeg-turbo gettext-dev \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install gd bcmath exif gettext intl mysqli pcntl pdo_mysql shmop soap sockets sysvsem xsl zip opcache \
    && apk add --no-cache imagemagick imagemagick-dev \
    && yes | pecl install imagick-3.8.1 \
    && docker-php-ext-enable imagick \
    && pecl install redis-6.3.0 \
    && docker-php-ext-enable redis \
    && apk del linux-headers freetype-dev libjpeg-turbo-dev libpng-dev libxml2-dev libxslt-dev autoconf g++ make imagemagick-dev \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /usr/local/log \
    && sed -i 's/9000/127.0.0.1:9083/' /usr/local/etc/php-fpm.d/zz-docker.conf

# www.conf和php.ini由docker-compose挂载，无需复制进镜像

EXPOSE 9083
