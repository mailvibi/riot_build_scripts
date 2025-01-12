#!/bin/bash

export MMC_DEVICE=/dev/sdc2
export TMP_MMC_MNT_DIR=tmp_mmc_mnt
export BUILDROOT_TAR_RFS="/home/sa/p/riot/buildroot/buildroot-2024.02.9/output/images/rootfs.tar"


if [ ! -f ${BUILDROOT_TAR_RFS} ] ; then
	echo "${BUILDROOT_TAR_RFS} does not exist.Exiting..."
	exit -1
fi

if [ ! -b ${MMC_DEVICE} ] ; then
	echo "${MMC_DEVICE} does not exist.Exiting..."
	exit -1
fi

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
cd ${WORKING_DIR}
sudo umount ${TMP_MMC_MNT_DIR}

rm -rf ${TMP_MMC_MNT_DIR}

