FROM ubuntu:18.04

RUN echo 'mysql-server mysql-server/root_password password root' | \
    debconf-set-selections
RUN echo 'mysql-server mysql-server/root_password_again password root' | \
    debconf-set-selections
RUN apt-get -qq update > /dev/null
RUN apt-get -qq install -y mysql-server > /dev/null
RUN mkdir -p /var/run/mysqld
RUN mkdir -p /var/lib/mysql
RUN chown mysql:mysql /var/run/mysqld
RUN chown mysql:mysql /var/lib/mysql

ARG SQLFLOW_MYSQL_PORT="3306"
ENV SQLFLOW_MYSQL_PORT=$SQLFLOW_MYSQL_PORT
EXPOSE $SQLFLOW_MYSQL_PORT
COPY start.bash /
CMD ["/start.bash"]
