## Windows使用dd烧录

[下载dd镜像](https://dl.sipeed.com/shareURL/MaixII/SDK/release)带有xx-dd文件即可

下载[Etcher](https://www.balena.io/etcher/ "Etcher")

下载[SD Card Formatter](https://www.sdcard.org/downloads/formatter/eula_windows/SDCardFormatterv5_WinEN.zip "SDCardFormatter")

首先使用SD Card Formatter[格式化](#-2)sd卡，然后打开软件，点击`Flash from file`,选中dd镜像包，然后点击Select target选中sd卡，最后点击Flash烧录。

![image-20210803140304732](https://raw.githubusercontent.com/USTHzhanglu/picture/main/img/image-20210803140304732.png) 

烧录完毕后，即可放入M2 dock中运行。

## 分区扩容（dd）

使用dd镜像后，会有部分储存空间未被使用，这时候需要扩容分区进行使用。

linux下可以用fdisk或者GParted扩容，windows下可以使用磁盘管理或者Diskgenus扩容（不推荐使用windows，可能会造成一些问题）

### linux系统下的扩容

这里以fdisk示例，其他方法请自行摸索。

将sd卡插入电脑，执行`sudo fdisk -l`，查看sd卡分区位置，如下即为/dev/sdb；

```
/dev/sdb1   49152  49663     512  256K Microsoft basic data
/dev/sdb2   49664  61951   12288    6M Microsoft basic data
/dev/sdb3   61952 324095  262144  128M Microsoft basic data
/dev/sdb4  324096 487935  163840   80M Microsoft basic data
```

然后执行以下命令：

```
##使用fdisk更改/dev/sdb分区；
sudo fdisk /dev/sdb 

Welcome to fdisk (util-linux 2.36.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

##d删除分区，，一路回车即可；
Command (m for help): d
Partition number (1-5, default 5): 

Partition 5 has been deleted.
##创建分区，一路回车即可；
Command (m for help): n
Selected partition 5
First sector (487936-7744508, default 489472): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (489472-7744508, default 7744508): 

Created a new partition 5 of type 'Linux filesystem' and of size 3.5 GiB.

##专家模式
Command (m for help): x

##创建分区名称
Expert command (m for help): n
Partition number (1-5, default 5): 

New name: UDISK

Partition name changed from '' to 'UDISK'.

##退出专家模式
Expert command (m for help): r

##保存分区；
Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

```

插入M2dock，验证：

```
root@sipeed:/# fdisk -l
Found valid GPT with protective MBR; using GPT

Disk /dev/mmcblk0: 7626752 sectors, 3724M
Logical sector size: 512
Disk identifier (GUID): ab6f3888-569a-4926-9668-80941dcb40bc
Partition table holds up to 8 entries
First usable sector is 49152, last usable sector is 7626748

Number  Start (sector)    End (sector)  Size Name
     1           49152           49663  256K env
     2           49664           61951 6144K boot
     3           61952          717311  320M rootfs
     4          717312          881151 80.0M swap
     5          882688         7626748 3292M UDISK
```

### windows下的系统扩容

烧录完镜像后，按下win+X键，打开磁盘管理，找到可移动磁盘，选中磁盘分区5，删除

![image-20210804173620185](https://raw.githubusercontent.com/USTHzhanglu/picture/main/img/image-20210804173620185.png)

然后重新插入sd卡，选中未分配空间，右键添加简单卷，点击下一步直到完成。

![](https://raw.githubusercontent.com/USTHzhanglu/picture/main/img/%E5%8A%A8%E7%94%BB.gif)

插入M2dock，验证：

![20210804](https://raw.githubusercontent.com/USTHzhanglu/picture/main/img/20210804.gif)

然后就可以通过该分区快捷的在M2dock和各平台之间复制文件了。