# DNMP

Learn more about how DNMP can streamline your development process and make your projects more efficient.

## Install

```bash
git clone https://github.com/helloxz/dnmp.git
cd dnmp
bash dnmp.sh run
# install phpmyadmin
bash dnmp.sh install runtime
bash dnmp.sh install phpmyadmin
```

## PHP 版本

| 版本 | 容器名 | FastCGI 端口 | 目录 |
| --- | --- | --- | --- |
| PHP 7.4（默认启动） | php-7.4 | 127.0.0.1:9074 | php74 |
| PHP 8.3（按需启动） | php-8.3 | 127.0.0.1:9083 | php83 |

`bash dnmp.sh run` 只会启动 PHP 7.4；需要 PHP 8.3 时执行 `bash dnmp.sh start php83`（`bash dnmp.sh start all` 也会一并启动）。站点使用哪个版本由 nginx vhost 里的 `fastcgi_pass` 端口决定，参考 `nginx/conf/vhost/site.conf.example`。

PHP 8.3 镜像需要自行构建并推送（Docker Hub 上的 `helloz/php` 只提供 7.4）：

```bash
cd php83
docker build -t helloz/php:8.3-fpm-alpine .
docker push helloz/php:8.3-fpm-alpine
```

## Common commands

```bash
# reload nginx config
docker exec -it nginx xc.sh reload

# start / stop PHP 8.3 on demand
bash dnmp.sh start php83
bash dnmp.sh stop php83

# check php version
docker exec php-8.3 php -v
```

