#!/bin/bash
############### XCDN启动脚本 ###############
#Author:xiaoz.me
#Update:2021-08-15
#Github:https://github.com/helloxz/xcdn
####################### END #######################

#创建xcdn所需目录
function create_dir(){
    #创建配置文件夹
    mkdir -p /data/xcdn/conf/vhost;
    mkdir -p /data/xcdn/conf/cdn;
    mkdir -p /data/xcdn/conf/stream;

    #创建日志文件夹
    mkdir -p /data/xcdn/logs;
    touch /data/xcdn/logs/error.log
    #创建ssl证书文件夹
    mkdir -p /data/xcdn/ssl;
    #创建缓存文件夹
    mkdir -p /data/xcdn/caches;
    chmod -R 777 /data/xcdn/caches;
}

#运行时检查
function run_check(){
	#检查nginx日志是否存在，如果不存在则创建
	if [ ! -f "/data/xcdn/logs/error.log" ]
	then
		#创建日志文件夹
	    mkdir -p /data/logs;
	    touch /data/logs/error.log
	    touch /data/logs/stream-access.log
	fi

}

function start_run(){
	#运行crond
	/usr/sbin/crond
	sleep 2
    #运行nginx,保持前台运行
    /usr/local/nginx/sbin/nginx -g "daemon off;"
    
    #tail -f /data/xcdn/logs/error.log
}
#运行nginx
#create_dir
run_check && start_run