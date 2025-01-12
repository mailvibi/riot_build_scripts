export ARCH=arm
export CROSS_COMPILE=arm-none-linux-gnueabihf-
export CROSS_COMPILE_BIN_LOCATION="/home/sa/p/cc/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-linux-gnueabihf/bin"
export RIOT_UBOOT_SRC_LOCATION="/home/sa/p/riot/u-boot"
export PATH=${CROSS_COMPILE_BIN_LOCATION}:$PATH

cd ${RIOT_UBOOT_SRC_LOCATION}
make riotboard_defconfig 
make -j4 u-boot.imx

