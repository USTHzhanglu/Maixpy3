# PhoenixCard烧录镜像

PhoenixSuit和PhoenixCard是全志芯片常用的两种烧录工具，一个是USB烧录，另一个是sd卡烧录。对于需要烧录到flash中的，常用PhoenixSuit，而使用sd卡的在用PhoenixSuit需要安装USB驱动等一系列的麻烦操作，就可以使用PhoenixCard进行烧录。

# 获取资源

PhoenixCard下载站连接：[下载站 - Sipeed](https://dl.sipeed.com/shareURL/MaixII/SDK/tools)

系统镜像下载站连接：[下载站 - Sipeed](https://dl.sipeed.com/shareURL/MaixII/SDK/release)

SD Card Formatter下载连接：[SD Card Formatter](https://www.sdcard.org/downloads/formatter/eula_windows/SDCardFormatterv5_WinEN.zip)

# 系统烧录

插入sd卡，打开SD Card Formatter

![image-20210802102810041](https://raw.githubusercontent.com/USTHzhanglu/picture/main/img/image-20210802102810041.png)

Refresh后点击Format后格式化，注意选中对应的sd卡；

打开PhoenixSuit,固件处选择对应镜像包（下载镜像后需要先解压），然后刷新盘符，如果未找到可以尝试重新插拔下SD卡，勾选启动卡，点击烧卡。

![image-20210802104155132](https://raw.githubusercontent.com/USTHzhanglu/picture/main/img/image-20210802104155132.png)

大概30s后，烧录完成。

![image-20210802104608721](https://raw.githubusercontent.com/USTHzhanglu/picture/main/img/image-20210802104608721.png)