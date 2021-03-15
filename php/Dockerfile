FROM php:7.3-fpm-alpine3.12
#设置时区,仅Debian需要
#ENV TZ=Asia/Shanghai
#工作目录
WORKDIR /root
#复制安装脚本
COPY ./install.sh /root
#复制启动脚本
COPY ./run.sh /usr/sbin
#执行安装脚本
RUN sh install.sh
#暴露配置文件
VOLUME /etc/nginx/conf.d
VOLUME /var/www/html
VOLUME /var/log/nginx
EXPOSE 80
EXPOSE 443
#运行crontab和nginx
CMD ["/usr/sbin/run.sh"]