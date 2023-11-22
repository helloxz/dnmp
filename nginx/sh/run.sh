#!/bin/bash
############### XCDN启动脚本 ###############
#Author:xiaoz.me
#Update:2021-08-15
#Github:https://github.com/helloxz/xcdn
####################### END #######################


#运行时检查
function run_check(){
	#检查nginx日志是否存在，如果不存在则创建
	if [ ! -f "/usr/local/nginx/logs/error.log" ]
	then
		#创建日志文件夹
	    # mkdir -p /data/xcdn/logs;
	    touch /usr/local/nginx/logs/error.log
	    touch /usr/local/nginx/logs/stream-access.log
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