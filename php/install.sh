#!/bin/bash
#更新软件
apk update
#安装timezone
apk add -U tzdata
#查看时区列表
ls /usr/share/zoneinfo
#拷贝需要的时区文件到localtime
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#查看当前时间
date
#为了精简镜像，可以将tzdata删除了
apk del tzdata
#安装wget
apk add wget


#安装nginx
function install_nginx() {
	#安装nginx
	apk add nginx
	wget -P /etc/nginx https://github.com/helloxz/dnmp/raw/main/php/nginx.conf
}
#设置PHP
function set_php(){
	#安装依赖
	apk add autoconf gcc musl-dev g++ zlib-dev make
	#安装GD库 依赖
	#apk add libpng-dev
	#设置php.ini
	cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
	#zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20180731/xdebug.so
	#
	sed -i "s/www-data/www/g" /usr/local/etc/php-fpm.d/www.conf
	#安装扩展
	pecl install redis-5.1.1 \
    && pecl install xdebug-2.8.1 \
    && docker-php-ext-enable redis xdebug
}



echo '-----------------------------'
echo 'nginx + php install success.'
echo '-----------------------------'