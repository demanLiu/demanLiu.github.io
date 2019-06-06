---
layout: post
title:  "archlinux性能调优"
date:   2019-01-12  21:11
categories: 基础运维
tags:   linux
---


### cpu

安装cpupower，设置performance模式,重启可能恢复，可以加在启动项

    cpupower frequency-set -g performance
### io

这里主要是io调度算法的选择

1.  noop  
最简单的算法，就是请求放入队列中，逐个执行，也叫电梯算法
2. deadline  
保证一定时间内请求都能被服务，避免请求饥饿
这里具体不做讲述，自行了解，通常多线程下效果好
3. cfq  
绝对公平算法，给进程分配一个请求队列和一个时间片，时间片结束，请求挂起等待调度。通用服务默认

### 内存

开大页，关交换空间

    vm.dirty_ratio = 3
    vm.dirty_background_ratio = 2
    vm.nr_hugepages=100
    vm.swappiness=0



### 预读

preload

    pacman -Ss prelo  加入开机启动




