#!/bin/bash
#update system
apt-get update
apt-get install -y wget
#install nginx
function install_nginx() {
	cd /usr/local
	#add user and group
	groupadd www
	useradd -M -g www www -s /sbin/nologin
	#download nginx
	wget http://soft.xiaoz.org/nginx/xcdn-binary-1.18-debian.tar.gz
	tar -zxvf xcdn-binary-1.18-debian.tar.gz
	rm -rf xcdn-binary-1.18-debian.tar.gz
	#add env
	echo "export PATH=$PATH:/usr/local/nginx/sbin" >> /etc/profile
	export PATH=$PATH:'/usr/local/nginx/sbin'
	#备份配置文件
	cd /usr/local/nginx/conf
	cp nginx.conf nginx.conf.bak
	wget -P /usr/local/nginx/conf https://github.com/helloxz/dnmp/raw/main/php/nginx.conf
}

#setting php
function set_php() {
	cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
	#install gd ext
	apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd
    #install xdebug and redis
    pecl install redis-5.1.1 \
    && pecl install xdebug-2.8.1 \
    && docker-php-ext-enable redis xdebug
}

install_nginx && set_php
chmod +x /usr/sbin/run.sh
echo '-----------------------------'
echo 'nginx + php install success.'
echo '-----------------------------'