#!/bin/bash

#####   name:dnmp管理脚本        #####
#####   update:2023/11/23       #####

# 获取当前运行目录
CURRENT_DIR=$PWD

# 检查环境变量是否存在，存在就加载
if [ -f "${CURRENT_DIR}/.env" ]
then
    source ${CURRENT_DIR}/.env
    # 根据.env里面的变量，设置用户ID和组ID
    USER_ID=$(id -u ${USER})
    GROUP_ID=$(id -g ${USER})

    export USER_ID=${USER_ID}
    export GROUP_ID=${GROUP_ID}    
fi

# 服务列表
services=(nginx mysql php74)


# 初始化运行
init(){
    # 拷贝环境变量
    cp ${CURRENT_DIR}/.env.simple ${CURRENT_DIR}/.env
    # 询问用户使用哪个用户运行，如果为空，则默认使用root用户
    read -p "Please enter the running user (default root):" USER
    # 如果为空，则USER=root
    if [ "${USER}" = "" ]
    then
        USER="root"
    fi
    # 替换.env文件中的USER变量
    sed -i "s/USER=root/USER=${USER}/g" ${CURRENT_DIR}/.env

    # 询问用户MySQL初始化密码，默认root3306，运行前请修改为其它复杂密码，密码如果为空，则设置为root3306，且密码不能低于8位字符
    read -p "Please set the MySQL root password (default: root3306):" MYSQL_ROOT_PASSWORD
    # 如果密码为空
    if [ "${MYSQL_ROOT_PASSWORD}" = "" ]
    then
        MYSQL_ROOT_PASSWORD="root3306"
    fi
    # 如果密码长度小于8位
    if [ ${#MYSQL_ROOT_PASSWORD} -lt 8 ]
    then
        echo "The password length cannot be less than 8 characters"
        exit
    fi
    # 替换.env文件中的MYSQL_ROOT_PASSWORD变量
    sed -i "s/MYSQL_ROOT_PASSWORD=root3306/MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}/g" ${CURRENT_DIR}/.env
    sed -i "s/MYSQL_ROOT_PASSWORD=root3306/MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}/g" ${CURRENT_DIR}/mysql/.env
    # 加载环境变量
    source ${CURRENT_DIR}/.env
    # 提示用户初始化完成
    echo '------------------------------------------------------'
    echo "Initialization completed, please run the start command."
}

# 服务运行前必要检查
run_check(){
    # 检查docker是否安装
    if [ ! -x "$(command -v docker)" ]
    then
        echo "Docker is not installed, please install it first."
        exit
    fi
    # 检查docker-compose是否安装
    if [ ! -x "$(command -v docker-compose)" ]
    then
        echo "Docker-compose is not installed, please install it first."
        exit
    fi
    # 检查.env文件是否存在
    if [ ! -f "${CURRENT_DIR}/.env" ]
    then
        echo "The .env file does not exist, please run the init command first."
        exit
    fi
}

# 运行docker服务
start(){
    # 运行前检查
    run_check
    # 获取用户传递的第二个参数
    service=$2
    echo $service
    # 如果service为空，或者为all，则运行所有服务
    if [ "${service}" = "" ] || [ "${service}" = "all" ]
    then
        # 遍历服务列表
        for svc in "${services[@]}"
        do
            # 拼接当前目录 + service，判断目录是否存在
            if [ -d "${CURRENT_DIR}/${svc}" ]
            then
                # 进入到service目录
                cd ${CURRENT_DIR}/${svc}
                # 重置目录权限
                chown -R ${USER_ID}:${GROUP_ID} ${CURRENT_DIR}/${svc}
                # 运行docker-compose
                docker-compose up -d
                echo '------------------------------------------------------'
                echo "The ${svc} service start success."
                echo '------------------------------------------------------'
                # 回到当前目录
                cd ${CURRENT_DIR}
            else
                # 目录不存在，则直接提示服务不存在
                echo "The ${svc} service does not exist."
            fi
        done
        exit
    fi

    # 拼接当前目录 + service，判断目录是否存在
    if [ -d "${CURRENT_DIR}/${service}" ]
    then
        # 进入到service目录
        cd ${CURRENT_DIR}/${service}
        # 运行docker-compose
        docker-compose up -d
        echo '------------------------------------------------------'
        echo "The ${service} service start success."
        echo '------------------------------------------------------'
        # 回到当前目录
        cd ${CURRENT_DIR}
    else
        # 目录不存在，则直接提示服务不存在
        echo "The service does not exist."
        exit
    fi

}

# 停止docker服务
stop(){
    # 运行前检查
    run_check
    # 获取用户传递的第二个参数
    service=$2
    echo $service
    # 如果service为空，或者为all，则停止所有服务
    if [ "${service}" = "" ] || [ "${service}" = "all" ]
    then
        # 遍历服务列表
        for svc in "${services[@]}"
        do
            # 拼接当前目录 + service，判断目录是否存在
            if [ -d "${CURRENT_DIR}/${svc}" ]
            then
                # 进入到service目录
                cd ${CURRENT_DIR}/${svc}
                # 停止docker-compose
                docker-compose stop
                echo '------------------------------------------------------'
                echo "The ${svc} service stop success."
                echo '------------------------------------------------------'
                # 回到当前目录
                cd ${CURRENT_DIR}
            else
                # 目录不存在，则直接提示服务不存在
                echo "The ${svc} service does not exist."
            fi
        done
        exit
    fi

    # 拼接当前目录 + service，判断目录是否存在
    if [ -d "${CURRENT_DIR}/${service}" ]
    then
        # 进入到service目录
        cd ${CURRENT_DIR}/${service}
        # 停止docker-compose
        docker-compose stop
        echo '------------------------------------------------------'
        echo "The ${service} service stop success."
        echo '------------------------------------------------------'
        # 回到当前目录
        cd ${CURRENT_DIR}
    else
        # 目录不存在，则直接提示服务不存在
        echo "The service does not exist."
        exit
    fi
}

# 通过case判断用户输入的第一个参数，然后执行对应函数的动作
case $1 in
    'init')
        init
    ;;
    'start')
        start
    ;;
    'stop')
        stop
    ;;
    *)
        echo "Usage: $0 {init|run|stop}"
    ;;
esac