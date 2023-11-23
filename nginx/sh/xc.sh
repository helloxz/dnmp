#!/bin/sh
############### XCDN管理脚本 ###############
# Author:xiaoz.me
# Update:2021-11-17
# Github:https://github.com/helloxz/xcdn
####################### END #######################

#nginx路径
NGINX_PATH="/usr/local/nginx"
nginx="${NGINX_PATH}/sbin/nginx"

# 配置文件路径
CONF_PATH="${NGINX_PATH}/conf/"
# SSL证书路径
SSL_PATH="${CONF_PATH}/ssl/"

#获取用户传递的参数
arg1=$1

if [ "${BRANCH}" = "" ]
then
	BRANCH="master"
fi

#启动脚本
function start(){
	#运行nginx
    $nginx -g "daemon off;"
    #sleep 10
    #tail -f /data/xcdn/logs/error.log
}
#停止脚本
function stop() {
	#运行nginx
    $nginx -s stop
}
#退出脚本
function quit() {
	#运行nginx
    $nginx -s quit
}

#重载配置
function reload(){
	$nginx -t && $nginx -s reload
}

# 检查配置
function check_conf() {
    $nginx -t
}

# 检查配置/SSL证书是否有更新，有更新则重载
function check_change() {
    find ${CONF_PATH} -mmin -1 -exec /usr/sbin/xc.sh reload {} +
	echo '-------------------------------------'
	sleep 3
	find ${SSL_PATH} -mmin -1 -exec /usr/sbin/xc.sh reload {} +
}


# 根据用户输入执行不同动作
case ${arg1} in
    'start') 
        start
    ;;
    'stop') 
        stop
    ;;
    'quit')
        quit
    ;;
    'reload')
        reload
    ;;
    '-t')
        check_conf
    ;;
    'check_change')
        check_change
    ;;
    *) 
        echo 'Parameter error!'
    ;;
esac

