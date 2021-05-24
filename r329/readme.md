



# 前言

没有前言。参考文献：[[Allwinner & Arm 中国 & Sipeed 开源硬件 R329 SDK 上手编译与烧录!](https://www.cnblogs.com/juwan/p/14650733.html)](https://www.cnblogs.com/juwan/p/14650733.html)

# 搭建编译环境

## 拉取仓库

```sh
git clone https://github.com/sipeed/R329-Tina-jishu
cd R329-Tina-jishu
git submodule update --init --recursive
```

仓库有些大，大概6G左右，保证网速稳定和空间足够

## 安装依赖

```sh
sudo apt-get -y install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3 python2.7 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf wget curl swig rsync
```

Ubuntu20 要增强一下，补一下下面两个包 libffi6 （python3 需要）。

```sh
wget http://mirrors.kernel.org/ubuntu/pool/main/libf/libffi/libffi6_3.2.1-8_amd64.deb
sudo apt install ./libffi6_3.2.1-8_amd64.deb

sudo apt-get install uuid-dev
```

## 开始编译

```
cd R329-Tina-jishu
source build/envsetup.sh
lunch r329_evb5-tina
make -j32
pack
```



# 编译环境问题

## 1.` git submodule update --init --recursive`后，会有一部分文件夹为空

```
root@Lithromantic:/maixpy3/R329-Tina-jishu/build# cd ..
root@Lithromantic:/maixpy3/R329-Tina-jishu# cd dl
root@Lithromantic:/maixpy3/R329-Tina-jishu/dl# ls
root@Lithromantic:/maixpy3/R329-Tina-jishu/dl# cd ..
```

### 解决方法：删除所有空文件夹，执行` git submodule update --recursive --remote` 

```sh
root@Lithromantic:/maixpy3/R329-Tina-jishu# git submodule update  --recursive --remote
Submodule path 'build': checked out '9ac1d53f550113f67b1c2902bc5049cf7bd48474'
Submodule path 'config': checked out '703ca1b44135c36aeec2a7ae315188f06aa1ea8e'
Submodule path 'dl': checked out '4b3d47f66c400612604125d582602b82e9b2d30b'
Submodule path 'scripts': checked out '18c02081caef2a4f9b5491b7fe4d866aeabd51b6'
Submodule path 'target': checked out '3ce2fa0f91cce7ba8de7134ed3879ad15908d0cb'
Submodule path 'toolchain': checked out '5ee02ba23449478aa9e2b605095fb2b9b880fb9f'
```

## 2.`make -j32`后 ` configure: error`

```sh
configure: error: you should not run configure as root (set FORCE_UNSAFE_CONFIGURE=1 in environment to bypass this check)
See `config.log' for more details
make[3]: *** [Makefile:31: /maixpy3/R329-Tina-jishu/out/r329-evb5/compile_dir/host/tar-1.28/.configured] Error 1
make[3]: Leaving directory '/maixpy3/R329-Tina-jishu/tools/tar'
make[2]: *** [tools/Makefile:135: tools/tar/compile] Error 2
make[2]: Leaving directory '/maixpy3/R329-Tina-jishu'
make[1]: *** [tools/Makefile:133: /maixpy3/R329-Tina-jishu/out/r329-evb5/staging_dir/target/stamp/.tools_install_yyyynyyynyyyyyyynnnyyyyyyyyyyynnyyyyyyyynyyynyyyyy] Error 2
make[1]: Leaving directory '/maixpy3/R329-Tina-jishu'
make: *** [/maixpy3/R329-Tina-jishu/build/toplevel.mk:306: world] Error 2

#### make failed to build some targets (04:52 (mm:ss)) ####
```

### 解决办法： `make`之前执行以下命令

```
export FORCE_UNSAFE_CONFIGURE=1
export FORCE=1
```

## 3.`make: ***.mk:306: world] Error 2`

`make[1]: *** [package/Makefile:189: /maixpy3/R329-Tina-jishu/out/r329-evb5/staging_dir/target/stamp/.package_compile] Error 2
make[1]: Leaving directory '/maixpy3/R329-Tina-jishu'
make: *** [/maixpy3/R329-Tina-jishu/build/toplevel.mk:306: world] Error 2`

### 解决办法：`make  -j1 V=s 2>&1|tee make.log`打印输出日志，cheak错误

定位到

```sh
make[3]: Leaving directory '/maixpy3/R329-Tina-jishu/package/libs/intltool'
make[2]: *** [package/Makefile:192: package/libs/intltool/host/compile] Error 2
```

执行` rm -rf /package/libs/intltool `

再次 `make  -j1 V=s 2>&1|tee make.log`后，定位到

```sh
checking for intltool >= 0.35.0...  found
configure: error: Your intltool is too old.  You need intltool 0.35.0 or later.
```

执行`apt-get install intltool`

再次`make  -j1 V=s 2>&1|tee make.log`

```sh
#### make completed successfully (26:27 (mm:ss)) ####

```

# 固件烧写

1.烧写时需连接插摄像头一侧typec口。

2.烧录参考[MaixII M2dock 烧录系统 - MaixPy (sipeed.com)。](https://cn.maixpy.sipeed.com/maixpy3/zh/install/maixii_m2dock/flash.html)

3.烧录前先全盘格式化SD卡为mbr格式，否则可能会造成烧录到85%时提示失败。

4.烧录大约耗时1分26秒，请勿着急。



