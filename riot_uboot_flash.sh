export BOOT_DEVICE="sdc"
sudo dd if=u-boot.imx of=/dev/${BOOT_DEVICE} bs=512 seek=2 conv=notrunc  
