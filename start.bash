#!/bin/bash

SQLFLOW_MYSQL_HOST=${SQLFLOW_MYSQL_HOST:-0.0.0.0}

echo "Start mysqld ..."
sed -i "s/.*bind-address.*/bind-address = ${SQLFLOW_MYSQL_HOST}/" \
    /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql start

echo "Sleep until MySQL server is ready ..."
until mysql -u root -proot \
            --host "$SQLFLOW_MYSQL_HOST" \
            --port "$SQLFLOW_MYSQL_PORT" \
            -e ";" ; do
    sleep 1
    read -r -p "Can't connect, retrying..."
done

# Grant all privileges to all the remote hosts so that the sqlflow
# server can be scaled to more than one replicas.
#
# NOTE: should notice this authorization on the production
# environment, it's not safe.
mysql -uroot -proot \
      -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'' IDENTIFIED BY 'root' WITH GRANT OPTION;"

sleep infinity
