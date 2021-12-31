#!/bin/sh
input_addr=$1
output_addr=$2
name=$3
input_addr=${input_addr:-dd.img}
output_addr=${output_addr:-./}
name=${name:-sipeed.img}
echo "input_addr=$input_addr,output_addr=$output_addr, name is $name

you can run xx.sh <intputaddr> <outputaddr> <name> to specify them or use defult
Such as 
dd.sh ./dd.img /root test.img 
or
dd.sh ./dd.img"
sudo cp $input_addr /tmp/$name
sudo losetup -d /dev/loop404 
sudo losetup -P /dev/loop404 /tmp/$name &&\
echo -e "\n\nx\nn\n4\nrootfs\nu\n4\nA0085546-4166-744A-A353-FCA9272B8E48\nr\nw\n"|sudo fdisk /dev/loop404 
sudo e2fsck -fyC 0 /dev/loop404p4 &&\
sleep 2
sudo resize2fs -p /dev/loop404p4 
sleep 2
sudo losetup -d /dev/loop404 

addr=$(pwd) &&\
cd /tmp &&\
echo "Compressing the mirror takes some time, and you can use <progress -m> at other terminals to see progress" &&\
sudo xz -z -k $name --threads=0 &&\
cd $addr &&\
sudo mv /tmp/$name.xz $output_addr &&\
sudo rm /tmp/$name
echo "all ok,use xz -dc $name.xz |sudo dd of=/dev/sdb bs=1M status=progress oflag=direct to create a tf Startup Disk"
