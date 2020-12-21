mkfile_path := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

all:

ARCH := arm

TOOLCHAIN_LINARO := ~/my_repos/emb-linux-common/gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc

# toolchain builder crosstool ng
CT-NG-DIR := ~/my_repos/emb-linux-common/crosstool-ng/
CT-NG := $(CT-NG-DIR)/ct-ng

$(CT-NG):
	bash -c $(mkfile_path)crosstoolng_compile.sh

crosstool-ng: $(CT-NG)

TOOLCHAIN_NG := ~/x-tools/arm-cortex_a8-linux-gnueabihf/bin/arm-cortex_a8-linux-gnueabihf-gcc

$(TOOLCHAIN_NG): $(CT-NG)
	$(CT-NG) arm-cortex_a8-linux-gnueabi
	$(CT-NG) menuconfig
	$(CT-NG) build

# pick toolchain here, ng or linaro
TOOLCHAIN := $(TOOLCHAIN_LINARO)

CROSS_COMPILE := $(subst gcc,,$(notdir $(TOOLCHAIN)))
export PATH := $(dir $(TOOLCHAIN)):$(PATH)

toolchain: $(TOOLCHAIN)

# u-boot compile
UBOOT_DIR := $(mkfile_path)u-boot
UBOOT_BOARD_CONFIG := am335x_evm_defconfig
UBOOT_IMG := $(UBOOT_DIR)/u-boot.img
UBOOT_MLO := $(UBOOT_DIR)/MLO

u-boot: $(UBOOT_IMG) $(UBOOT_MLO)

$(UBOOT_IMG) $(UBOOT_MLO): $(TOOLCHAIN)
	PATH=$(PATH) make -C $(UBOOT_DIR) CROSS_COMPILE=$(CROSS_COMPILE) $(UBOOT_BOARD_CONFIG)
	PATH=$(PATH) make -C $(UBOOT_DIR) CROSS_COMPILE=$(CROSS_COMPILE)


# KERNEL
#
KERNEL_DIR := $(mkfile_path)linux
KERNEL_ZIMAGE := $(KERNEL_DIR)/arch/$(ARCH)/boot/zImage

KERNEL_MAKE := cd $(KERNEL_DIR); PATH=$(PATH) make -j4 ARCH=$(ARCH)

kernel_clean:
	$(KERNEL_MAKE) CROSS_COMPILE=$(CROSS_COMPILE) mrproper

kernel_config:
	$(KERNEL_MAKE) multi_v7_defconfig

$(KERNEL_ZIMAGE): $(TOOLCHAIN)
	$(KERNEL_MAKE) CROSS_COMPILE=$(CROSS_COMPILE) vmlinux
	$(KERNEL_MAKE) CROSS_COMPILE=$(CROSS_COMPILE) zImage
	$(KERNEL_MAKE) dtbs
	$(KERNEL_MAKE) CROSS_COMPILE=$(CROSS_COMPILE) modules

kernel_clean_rebuild: kernel_clean kernel_config $(KERNEL_ZIMAGE)
kernel: $(KERNEL_ZIMAGE)

# Format sd card
MELP := $(mkfile_path)Mastering-Embedded-Linux-Programming-Second-Edition

format-sdcard:
	@echo formatting SDCARD_NAME=$(SDCARD_NAME)
	$(MELP)/format-sdcard.sh $(SDCARD_NAME)

load_u-boot: $(UBOOT_IMG) $(UBOOT_MLO)
	sudo cp $(UBOOT_MLO) $(UBOOT_IMG) /media/$$USER/boot
	sudo cp $(mkfile_path)uEnv.txt /media/$$USER/boot

	sudo umount /media/$$USER/boot


load_kernel:



.PHONY: u-boot toolchain format-sdcard kernel
