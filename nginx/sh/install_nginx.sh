#!/bin/bash

#http://soft.xiaoz.org/xcdn/xcdn-binary-alpine-1.20.2-20220518_x86_64.tar.gz
nginx_version='1.24.0'
THEDATE='20231123'
#安装依赖
depend(){
	apk update
	apk add --no-cache --virtual .build-deps \
	openssl-dev \
	pcre-dev \
	gd-dev \
	libmaxminddb-dev \
	git \
	wget \
	curl \
	bash \
	openssh-client \
	logrotate
}

#设置时间
set_time(){
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
}

install_before(){
	#脚本添加执行权限
	chmod +x /opt/*.sh
	cp /opt/run.sh /usr/sbin/
	cp /opt/xc.sh /usr/sbin/
	#创建软连接
	ln -s /usr/local/nginx/sbin/nginx /usr/sbin/nginx
	#创建缓存文件夹
	# mkdir -p /data/caches
	# 创建SSL证书文件夹
	mkdir -p /usr/local/nginx/conf/ssl
	#创建站点文件夹
	mkdir -p /var/www/html
}

#安装nginx
install_nginx(){
	# 创建用户
	addgroup -S nginx && adduser -S nginx -G nginx
	cd /usr/local
	NGINX_NAME=xcdn-binary-alpine-${nginx_version}-${THEDATE}_x86_64.tar.gz
	wget http://soft.xiaoz.org/xcdn/${NGINX_NAME}
	tar -xvf ${NGINX_NAME}
	rm -rf ${NGINX_NAME}
	#mv /usr/local/nginx/conf/nginx.conf.bak /usr/local/nginx/conf/nginx.conf
	#环境变量与服务
	echo "export PATH=$PATH:/usr/local/nginx/sbin" >> /etc/profile
	export PATH=$PATH:'/usr/local/nginx/sbin'
	# 设置权限
	chown -R nginx:nginx /usr/local/nginx
	chown -R nginx:nginx /opt

	#日志分割
	#wget --no-check-certificate https://raw.githubusercontent.com/helloxz/nginx-cdn/master/etc/logrotate.d/nginx -P /etc/logrotate.d/
	wget --no-check-certificate https://raw.githubusercontent.com/helloxz/xcdn/alpine/conf/nginx -P /etc/logrotate.d/

	echo "------------------------------------------------"
	echo "XCDN installed successfully."
}

#添加定时任务
add_crontab() {
	echo "添加定时任务"
	# 检测配置文件和SSL证书变化
	echo "*/3    *       *       *       *       /opt/xc.sh check_change" >> /etc/crontabs/opt
	# 日志分割
	echo "50     23       *       *       *       /usr/sbin/logrotate -f /etc/logrotate.d/nginx" >> /etc/crontabs/opt
}

#清理工作
clean_work(){
	rm -rf /var/cache/apk/*
	rm -rf /opt/.cache
	rm -rf /tmp/*
}

install_before && depend && set_time && install_nginx && add_crontab && clean_work