FROM php:7.3-fpm-alpine3.12
#设置时区
ENV TZ=Asia/Shanghai
#工作目录
WORKDIR /root
#复制安装脚本
COPY ./install.sh /root
#复制启动脚本
COPY ./run.sh /usr/sbin
#执行安装脚本
RUN bash install.sh
#暴露配置文件
VOLUME /usr/local/nginx/conf/vhost
VOLUME /var/www/html
EXPOSE 80
EXPOSE 443
#运行crontab和nginx
CMD ["/usr/sbin/run.sh"]