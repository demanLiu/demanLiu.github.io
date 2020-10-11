---
title:  "Memcached集群"
key:  "Memcached集群"
date:   2015-04-10  23:50
categories: 基础运维
tags:   docker
---

## 方案

memcached没有自带官方集群方案，需要使用第三方，主流keepalived+magent+memcache，

## magent

magent代理访问，他根据hash算法，得到key存储的后端机器，请求memcache得到数据，keepalived保证magent高可用

### 具体查找过程

　　采用的是一致性hash,首先求出memcached服务器（节点）的哈希值， 并将其配置到0～232的圆（continuum）上。 然后用同样的方法求出存储数据的键的哈希值，并映射到圆上。 然后从数据映射到的位置开始顺时针查找，将数据保存到找到的第一个服务器上。 如果超过232仍然找不到服务器，就会保存到第一台memcached服务器上。

## 实践

三步走安装好magent和memcached，ka， ka自行配置

在magent的机器上运行：


    magent -u root -n 51200 -l  xxx -s s1 s2 s3 -b  b1 b2
