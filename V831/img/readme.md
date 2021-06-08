# 前言
这里使用两种烧录方式，一种是PhoenixSuit官方烧录，参考[MaixII M2dock 烧录系统](https://cn.maixpy.sipeed.com/maixpy3/zh/install/maixii_m2dock/flash.html "MaixII M2dock 烧录系统")，第二种是类似树莓派直接烧写镜像的方式。官方的讲解很完善了，这里主要讲第二种。由于win10烧录会导致GPT分区表错误，并且涉及到调整分区，这里将在linux系统下进行。
# 资源获取
~~## 烧录程序~~
~~采用流行的[Etcher](https://www.balena.io/etcher/ "Etcher")~~
## 格式化软件
[SDCardFormatter](https://www.sdcard.org/downloads/formatter/eula_windows/SDCardFormatterv5_WinEN.zip "SDCardFormatter")，这里用的win10的软件，根据个人爱好自行选择
## 镜像获取

##  [v831.img.gz](v831.img.gz)

# 系统烧录
1. **格式化sd卡。**使用SDCardFormatter一键格式化，或者手动格式化为MBR分区，FAT32格式。
2. **挂载sd卡。**插入设备后，执行`sudo fdisk -l`，出现如下设备
```
/dev/sdb1        8192 7744511 7736320  3.7G  b W95 FAT32
```
即挂载成功。

3. **使用dd命令烧录程序。**先进入镜像所在文件夹，然后执行如下命令
```
gzip -dc v831.img.gz |sudo dd of=/dev/sdb bs=1M status=progress
```
烧录完毕后，执行执行`sudo fdisk -l`，出现如下设备
```
/dev/sdb1   49152  49663     512  256K Microsoft basic data
/dev/sdb2   49664  61951   12288    6M Microsoft basic data
/dev/sdb3   61952 324095  262144  128M Microsoft basic data
/dev/sdb4  324096 487935  163840   80M Microsoft basic data
```
即烧录完毕。

4. **扩展分区。**如下:（省时间版：`sudo fdisk /dev/sdb p n 回车 回车 w`)
```
lithromantic@ubuntu:~/Desktop$ sudo fdisk /dev/sdb

Welcome to fdisk (util-linux 2.36.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

GPT PMBR size mismatch (499711 != 7744511) will be corrected by write.
The backup GPT table is not on the end of the device. This problem will be corrected by write.

Command (m for help): p

Disk /dev/sdb: 3.69 GiB, 3965190144 bytes, 7744512 sectors
Disk model: Storage Device  
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: AB6F3888-569A-4926-9668-80941DCB40BC

Device      Start    End Sectors  Size Type
/dev/sdb1   49152  49663     512  256K Microsoft basic data
/dev/sdb2   49664  61951   12288    6M Microsoft basic data
/dev/sdb3   61952 324095  262144  128M Microsoft basic data
/dev/sdb4  324096 487935  163840   80M Microsoft basic data

Command (m for help): n
Selected partition 5
First sector (487936-7744508, default 489472): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (489472-7744508, default 7744508): 

Created a new partition 5 of type 'Linux filesystem' and of size 3.5 GiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

lithromantic@ubuntu:~/Desktop$ 
```

5. **格式化分区。** `sudo mkfs -t ext4 /dev/sdb5`
6. **挂载分区。**挂载分区要在v831上执行，所以在此之前我们先测试下系统能否使用。
插入sd卡至V831，连接USB UART口和电脑usb口，打开串口终端，出现
```
BusyBox v1.27.2 () built-in shell (ash)

------run profile file-----
   __  ___     _        __   _               
  /  |/  /__ _(_)_ __  / /  (_)__  __ ____ __
 / /|_/ / _ `/ /\ \ / / /__/ / _ \/ // /\ \ /
/_/  /_/\_,_/_//_\_\ /____/_/_//_/\_,_//_\_\ 
 ----------------------------------------------

root@sipeed:/# 
```
执行`fdisk -l`，出现
```
Number  Start (sector)    End (sector)  Size Name
     1           49152           49663  256K env
     2           49664           61951 6144K boot
     3           61952          324095  128M rootfs
     4          324096          487935 80.0M swap
     5          489472         7744508 3542M 
```


7. **挂载分区。** 
临时挂载:`mount /dev/mmcblk0p5 /home`
这里是挂载到`/home`路径下，可以自行修改。执行`df`查看效果：
```
root@sipeed:/home# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/root               125460     73284     49556  60% /
tmpfs                    29864        12     29852   0% /tmp
none                     29796         0     29796   0% /dev
/dev/mmcblk0p5         3504908     14172   3292980   0% /home
```
永久挂载：`echo /dev/mmcblk0p5 /home ext4 defaults 0 0 >> /etc/fstab`