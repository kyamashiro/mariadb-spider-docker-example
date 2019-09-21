#!/bin/sh -eo
echo "source /usr/share/mysql/install_spider.sql" | mariadb -uroot -p"${MYSQL_ROOT_PASSWORD}"