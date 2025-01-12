#!/bin/bash

export MMC_DEVICE=/dev/sdc2
export TMP_MMC_MNT_DIR=tmp_mmc_mnt
export BUILDROOT_TAR_RFS="/home/sa/p/riot/buildroot/buildroot-2024.02.9/output/images/rootfs.tar"
export LINUX_KERNEL_BUILD_DIR="/home/sa/p/linux/linux/build_riot/"

export LINUX_KERNEL_FILE=${LINUX_KERNEL_BUILD_DIR}arch/arm/boot/zImage 
export LINUX_DTB_FILE=${LINUX_KERNEL_BUILD_DIR}arch/arm/boot/dts/nxp/imx/imx6dl-riotboard.dtb 

exit_if_file_not_found() {
	if [ ! -f $1 ] ; then
		echo "${1} does not exist.Exiting..."
		exit -1
	fi
}

exit_if_block_dev_not_found() {
	if [ ! -b $1 ] ; then
		echo "${1} does not exist.Exiting..."
		exit -1
	fi
}


exit_if_file_not_found "${BUILDROOT_TAR_RFS}"
exit_if_block_dev_not_found "${MMC_DEVICE}"
exit_if_file_not_found "${LINUX_KERNEL_FILE}"
exit_if_file_not_found "${LINUX_DTB_FILE}"

if [ ! -d ${TMP_MMC_MNT_DIR} ] ; then
	mkdir "${TMP_MMC_MNT_DIR}"
fi

WORKING_DIR=${PWD}

sudo mount ${MMC_DEVICE} ${TMP_MMC_MNT_DIR}
cd ${TMP_MMC_MNT_DIR}
sudo rm -rf *
sync
sudo tar -xvf ${BUILDROOT_TAR_RFS}
sync

# Copy LINUX KERNEL

if [ ! -d "boot" ] ; then
	sudo mkdir "boot"
fi

sudo cp ${LINUX_DTB_FILE} boot/
sudo cp ${LINUX_KERNEL_FILE} boot/

sync
# 

cd ${WORKING_DIR}
sudo umount ${TMP_MMC_MNT_DIR}

rm -rf ${TMP_MMC_MNT_DIR}

