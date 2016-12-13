---
layout: post
title:  "docker配置lnmp"
date:   2015-07-24  14:10
categories: 基础运维
tags:   php
---

mac还要注意做端口映射要先开启

     VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port5000,tcp,,5000,,5000";

###基于centos的镜像开始
由于是最小安装很多都没有，先安装基本的工具

        yum install net-tools
        yum -y install wget
        yum -y install vim
        yum install gcc-c++ 
        yum install pcre pcre-devel  
        yum install zlib zlib-devel  
        yum install openssl openssl--devel  
        yum -y install gcc automake autoconf libtool make

安装apache

        yum install httpd

或者安装nginx




下载php包
由于我时日本的代理：

        wget -O php5.3.tar.gz http://jp2.php.net/get/php-5.3.29.tar.gz/from/this/mirror
        tar zxvf php5.3.tar.gz


安装mysql
由于我时centos7，已经改成mariadb

        yum install mariadb-server mariadb-libs mariadb mariadb-devel
        yum -y install curl-devel
先初始化下：

        mysql_install_db
        mysqld_safe —user=root &

到这里mysql就安装完成启动了

编译php

      ./configure --prefix=/opt/php --with-iconv --with-zlib --enable-xml --disable-rpath --enable-discard-path --enable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-fastcgi --enable-fpm --enable-force-cgi-redirect --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-ldap=shared --with-ldap-sasl --with-xmlrpc --enable-zip --enable-soap --without-pear --with-mysql --with-mysqli --enable-sqlite-utf8 --with-pdo-mysql --enable-ftp --with-jpeg-dir --with-freetype-dir --with-png-dir  --enable-lib64 --libdir=/usr/lib64

可能的错误：

     checking for stdarg.h... (cached) yes
     checking for mcrypt support... yes
     configure: error: mcrypt.h not found. Please reinstall libmcrypt.

     libmcrypt库没有安装 ，要是不能用yum安装的话  就要去下载个gz包 自己编译安装

     （编译安装  ./configure --piefix=/usr/local/libmcrypt   make && make install） 


要是错误里面含有mysql的  那是mysql-devel 没有安装
如果还是找不到就搞个软连接

     cp -frp /usr/lib64/libldap* /usr/lib/
     cp -r  /usr/lib64/mysql/libmysqlclient* /usr/lib/
     yum -y install libtool-ltdl-devel


     docker login 登陆上传你的images
