---
layout: post
title:  "利用docker配置mysql主从"
date:   2014-12-01  23:50
categories: 云计算
tags:   docker
---

### 目的

1. 熟悉docker基本使用和基本网络设置
2. 了解mysql主从
3. 启发mysql集群

### docker是什么？

作为13年出现的云计算的宠儿，其利用容器的概念，老物新用，确实功能强大，能够快速构建集群，每个机器都可以看成是一个镜像的实例。你只需要构建一个环境就可以
轻松复制出无数个。他具有继承，重用的概念。如果不是很了解，请自行百度。

### 构建基本单元

我们需要构建出主从数据库，我们需要的基本环境就是一台装着mysql的“机器”我采用了centos6（当然就可以选择自己熟悉的环境）,构建脚本Dockerfile：

    FROM  centos:centos6
    RUN yum install -y mysql-server mysql mysql-deve
    CMD ["/bin/bash"]

在文件目录下执行
    
    docker build -t centos6-mysql .

至此一个基本的mysql环境搭建完了。


### 构建主库

为了主从能够很好的沟通，我们需要各自给个ip，为此，我们规定：

    master：192.168.2.100
    slave ：192.168.2.101

首先，启动一个mysql环境的实例
    
    docker run -ti centos6-mysql 

编辑/etc/my.cnf
    
    server-id=1
    log_bin=/var/log/mysql/mysql-bin.log
    read-only=0
    binlog-do-db=test  # 你需要进行同步的数据库
    expire_logs_days=10  # 日志保存天数

保存，重启mysql。注意你要保证/var/log/mysql/这个文件夹存在，并且所属mysql:mysql

当然你还要新建一个用户，能让slave能够远程登陆

     grant replication slave, reload, super on *.* to 'slave'@'192.168.2.101' identified by '123';

ok，主库的任务完成了。
最后，为了以后方便，把这个实例保存下

    docker commit $contains_id  liuhuan/mysql_master


### 构建从库

同样，基本的mysql跑起来
编辑/etc/my.cnf


    server-id       = 2
    log_bin         = /var/log/mysql/mysql-bin.log
    master-host     =192.168.2.100
    master-user     =slave
    master-pass     =123456
    master-port     =3306
    master-connect-retry=60
    replicate-do-db =test
    read_only

重启mysql。注意你要保证/var/log/mysql/这个文件夹存在，并且所属mysql:mysql
同样保存这个实例：

    docker commit $contains_id liuhuan/mysql_slave

### 分配IP

我们利用桥接，首先保证你的宿主机器装了brtcl-util，没有自行安装

    brctl addbr br0
    ip link set dev br0 up
    ip addr add 192.168.2.1/24 dev br0
    MYSQL=$(docker run -d -p 3306:3306 -e MYSQL_PASS=admin tutum/mysql)
    pipework br0 $MYSQL 192.168.2.100/24 

具体请自己先好好尝试如何使用pipework

### 读写分离

读写分离要借助mysql proxy 或者 amoeba，我们下次讨论。
简单的方法，我们可以借助账号权限，在slave新建一个普通用户，由于我们配置文件是read_only，因此这个账号只能进行读。如果你是root账号还是可以写的。
在程序中我们新建slave链接实例时，用这个普通用户，这就从账号和程序角度实现了读写分离。


