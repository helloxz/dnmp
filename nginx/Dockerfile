#基于哪个镜像制作,3.14会有问题
FROM alpine:3.13
RUN addgroup -S nginx && adduser -S nginx -G nginx
USER nginx
#工作目录
WORKDIR /opt
# 确保 nginx 用户有权限访问复制的文件
COPY --chown=nginx:nginx sh/* /opt/
#执行安装脚本
# 切换到 root 用户进行安装
USER root
RUN sh install_nginx.sh

# 切换回 nginx 用户
USER nginx

#健康检查
HEALTHCHECK --interval=10s --timeout=5s \
  CMD curl -fs http://localhost/ || exit 1
#暴露端口
EXPOSE 80 443 10000-10100
#运行启动脚本和nginx
CMD ["/usr/sbin/run.sh"]