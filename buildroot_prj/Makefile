
.PHONY: build load custom_config save_config clean_build clean_config mount_sdcard umount_sdcard 


mkfile_path := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

BUILDROOT := $(mkfile_path)/buildroot
MAKE := cd $(BUILDROOT); make

clean_config:
	$(make) distclean

clean_build:
	$(make) clean

default_config:
	$(MAKE) raspberrypi4_defconfig
	echo $(BUILDROOT)/.config overwritten with default rpi4 config

custom_config:
	$(MAKE) menuconfig
	echo 'Config saved under $(BUILDROOT)/.config (Full verbose config)'
	cp $(BUILDROOT)/.config  ./custom_config_full
	echo 'Config (full version) saved under ./custom_config_full'

save_config:
	$(MAKE) savedefconfig
	cp $(BUILDROOT)/configs/raspberrypi4_defconfig ./custom_config
	echo 'Config (compressed version) saved under ./custom_config'

build:
	$(MAKE)

mount_sdcard:
	sudo mount $(SD_CARD_DEV_PATH_BOOT) $(SD_CARD_MOUNT_DIR)/boot

umount_sdcard:
	sudo umount $(SD_CARD_DEV_PATH_BOOT)

load:
	sudo dd if=$(BUILDROOT)/output/images/sdcard.img of=/dev/$(SDCARD_NAME) bs=1M


