#!/bin/sh
select=$1                                                                                                  
select=${select:-begin}

detele_udisk()
{
if [ -e /dev/by-name/UDISK  ]; then
	echo "Warning, UDISK already exists, do you want to delete it?"
	read -p "Y(es) or N(o),defult: Y" del_yn
	del_yn=${del_yn:-y}
	if [ $del_yn = "Y" -o $del_yn = "y" ];then
		echo -e "d\n5\nw\n"|fdisk /dev/mmcblk0
	else
		echo "now stop task"
		exit 0
	fi
fi
}

create_UDISK()
{
echo -e "n\n5\n\n\nx\nn\n5\nUDISK\nr\nw\n" | fdisk /dev/mmcblk0
cd /etc/init.d
cp rc.final rc.final.bak
chmod -x rc.final.bak
echo "sh /resize.sh mkfs" >> /etc/init.d/rc.final
reboot
}

mkfs_udisk()
{
mkfs.vfat /dev/mmcblk0p5
cd /etc/init.d
rm rc.final
mv rc.final.bak rc.final
chmod +x rc.final
echo "all ok"
}

resize_root()
{
echo -e "d\n4\nn\n4\n225792\n$size\nx\nn\n4\nrootfs\nu\n4\nA0085546-4166-744A-A353-FCA9272B8E49\nr\nw\n"|fdisk /dev/mmcblk0
cd /etc/init.d
cp rc.final rc.final.bak
chmod -x rc.final.bak
echo "sh /resize.sh resize" >> /etc/init.d/rc.final
reboot
}
resize2fs_root()
{
#tune2fs -O ^has_journal /dev/root
resize2fs /dev/root
cd /etc/init.d
rm rc.final
mv rc.final.bak rc.final
chmod +x rc.final
echo "change root size ok"
}
menu()
{
echo "your input $select"
if [ "$select" = "begin" ];then
	echo "choose you want do:
	1):UDISK
	2):root
	If you want to view your disks on different platforms,you should do 1
	IF you just want expand your root filesystem,do 2
	maybe you all want,then do 2 before do 1
	You will can't change the size of your root filesystem after you get UDISK
	"
	read -p "defult 1):" task
	task=${task:-1}
	echo "You choose $task;"
	if [ "$task" = "2" ];then
		read -p "+size{K,M,G,T,P} , such as: +1G
	default all size:" size
		detele_udisk
		resize_root
	else
		detele_udisk
		create_UDISK
	fi
elif [ "$select" = "mkfs" ];then
	mkfs_udisk
elif [ "$select" = "resize" ];then
	resize2fs_root
fi
}

menu
