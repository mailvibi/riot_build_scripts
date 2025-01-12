#!/bin/bash

export ARCH=arm
export CROSS_COMPILE=arm-none-linux-gnueabihf-
export PATH=/home/sa/p/cc/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-linux-gnueabihf/bin:$PATH
export MMC_DEVICE=/dev/sdc2
export TMP_MMC_MNT_DIR=tmp_mmc_mnt
export RIOT_BUILD_DIR="/home/sa/p/linux/linux/build_riot"
export BUILD_CONFIG=""

if [ ! -d ${RIOT_BUILD_DIR} ] ; then
	echo "Creating Build Dir ${RIOT_BUILD_DIR}"
	mkdir ${RIOT_BUILD_DIR}
fi

if [ x"${BUILD_CONFIG}" != x ] ; then
	echo "Building configuration required"	
	make -j4 O=${RIOT_BUILD_DIR} imx_v6_v7_defconfig
	make -j4 O=${RIOT_BUILD_DIR} menuconfig
fi
make -j16 O=${RIOT_BUILD_DIR} bzImage
#make -j16 O=${RIOT_BUILD_DIR} uImage
make -j16 O=${RIOT_BUILD_DIR} dtbs

cd  ${RIOT_BUILD_DIR}
mkdir ${TMP_MMC_MNT_DIR}
sudo mount ${MMC_DEVICE} ${TMP_MMC_MNT_DIR}
if [ ! -d "${TMP_MMC_MNT_DIR}/boot" ] ; then
	sudo mkdir "${TMP_MMC_MNT_DIR}/boot"
fi
sudo cp arch/arm/boot/dts/nxp/imx/imx6dl-riotboard.dtb ${TMP_MMC_MNT_DIR}/boot/
sudo cp arch/arm/boot/zImage ${TMP_MMC_MNT_DIR}/boot/
sync
sudo umount ${TMP_MMC_MNT_DIR}
rm -rf ${TMP_MMC_MNT_DIR}


#sudo mount -o loop rootfs.ext2 o

sudo mount /dev/sdc2 o
if [ ! -d "o/boot" ] ; then
	sudo mkdir "o/boot"
fi
sudo cp /home/sa/p/linux/linux/build_riot/arch/arm/boot/dts/nxp/imx/imx6dl-riotboard.dtb o/boot/
sudo cp /home/sa/p/linux/linux/build_riot/arch/arm/boot/zImage o/boot/
sync
sudo umount o





##############################################################################

setenv bootargs console=ttymxc1,115200 root=/dev/mmcblk1p2 init=/bin/ash debug=7
ext4load mmc 0:2 10800000 /boot/zImage;ext4load mmc 0:2 16800000 /boot/imx6dl-riotboard.dtb;bootz 10800000 - 16800000


setenv bootargs console=ttymxc1,115200 root=/dev/mmcblk1p2 init=/sbin/init debug=7
ext4load mmc 0:2 10800000 /boot/zImage;ext4load mmc 0:2 16800000 /boot/imx6dl-riotboard.dtb;bootz 10800000 - 16800000
