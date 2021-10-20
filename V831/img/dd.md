# 如何为V831制作自己的DD镜像

## 获取官方镜像

从下载站获取最新的 V831 系统镜像 [SDK_MaixII/release](http://dl.sipeed.com/shareURL/MAIX/SDK_MaixII/release) ，找不到就搜索 V831 获取最新的镜像。

## 烧录设备

[MaixII M2dock 烧录系统 - MaixPy (sipeed.com)](https://cn.maixpy.sipeed.com/maixpy3/zh/install/maixii_m2dock/flash.html)

## dd克隆

`dd if=/dev/sdb bs=1M count=512 status=progress| gzip > /root/image.gz`

if指定克隆前设备位置，sd卡挂载到sdb即sdb，可以使用fdisk -l查看，status=progress显示dd状态，dd文件过大时使用此命令可以有效缓解焦虑

## dd烧录

`gzip -dc image.gz |sudo dd of=/dev/sdb bs=1M status=progress oflag=direct` 

bs=1M指输入输出块大小为1024k ,速度达不到实际读写时可以尝试改为2M 4M等；

oflag:表示读写磁盘的方式。`direct`代表不使用系统的缓存，直接对磁盘进行读写；`dsync`代表使用同步io对磁盘进行读写（会更慢）。

更多内容参考[maix2dock(V831) 系统烧录 - Sipeed 开源社区](https://bbs.sipeed.com/thread/755)

