## 编译环境问题

### 1.` git submodule update --init --recursive`后，会有一部分文件夹为空

```
root@Lithromantic:/maixpy3/R329-Tina-jishu/build# cd ..
root@Lithromantic:/maixpy3/R329-Tina-jishu# cd dl
root@Lithromantic:/maixpy3/R329-Tina-jishu/dl# ls
root@Lithromantic:/maixpy3/R329-Tina-jishu/dl# cd ..
```

#### 解决方法：删除所有空文件夹，执行` git submodule update --recursive --remote` 

```sh
root@Lithromantic:/maixpy3/R329-Tina-jishu# git submodule update  --recursive --remote
Submodule path 'build': checked out '9ac1d53f550113f67b1c2902bc5049cf7bd48474'
Submodule path 'config': checked out '703ca1b44135c36aeec2a7ae315188f06aa1ea8e'
Submodule path 'dl': checked out '4b3d47f66c400612604125d582602b82e9b2d30b'
Submodule path 'scripts': checked out '18c02081caef2a4f9b5491b7fe4d866aeabd51b6'
Submodule path 'target': checked out '3ce2fa0f91cce7ba8de7134ed3879ad15908d0cb'
Submodule path 'toolchain': checked out '5ee02ba23449478aa9e2b605095fb2b9b880fb9f'
```

### 2.`make -j32`后 ` No such file or directory`

```sh
===This's tina environment.===
find: ‘/maixpy3/R329-Tina-jishu/lichee/brandy-2.0/spl’: No such file or directory
r329_evb5 r329 r329-evb5
build_boot platform:sun50iw11p1 o_option:spl-pub
grep: /maixpy3/R329-Tina-jishu/lichee/brandy-2.0/spl/Makefile: No such file or directory
Prepare toolchain ...
ls: cannot access '/maixpy3/R329-Tina-jishu/lichee/brandy-2.0/spl-pub/board': No such file or directory
mboot0 success!
find: ‘/maixpy3/R329-Tina-jishu/lichee/brandy-2.0/spl’: No such file or directory
touch: cannot touch '/maixpy3/R329-Tina-jishu/lichee/brandy-2.0/spl/.newest-68b329da9893e34099c7d8ad5cb9c940.patch': No such file or directory
r329_evb5 r329 r329-evb5
build_boot platform:sun50iw11p1 o_option:uboot
grep: /maixpy3/R329-Tina-jishu/lichee/brandy-2.0/spl/Makefile: No such file or directory
Prepare toolchain ...
build for sun50iw11p1_defconfig ...
Prepare riscv toolchain ...
fatal: No names found, cannot describe anything.
cat: .tmp_config_from_defconfig.o.md5sum: No such file or directory
md5sum: .config: No such file or directory
```

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

#### 解决办法

