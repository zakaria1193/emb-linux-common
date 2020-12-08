export PATH=./gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf/bin:$PATH
make -C u-boot CROSS_COMPILE=arm-linux-gnueabihf- am335x_evm_defconfig
make -C u-boot CROSS_COMPILE=arm-linux-gnueabihf-
