#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/motorola/paros

# A/B
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    product \
    recovery \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_dlkm \
    vendor_boot

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := 400dpi
PRODUCT_AAPT_PREBUILT_DPI := xxxhdpi xxhdpi xhdpi hdpi

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := kryo300

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a75

# Boot animation
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := paros
TARGET_NO_BOOTLOADER := true

# Kernel
BOARD_BOOT_HEADER_VERSION := 4

BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x01000000
BOARD_DTB_OFFSET := 0x01f00000
BOARD_TAGS_OFFSET := 0x00000100

BOARD_KERNEL_IMAGE_NAME := Image
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_SEPARATED_DTBO := true

BOARD_RAMDISK_USE_LZ4 := true
TARGET_KERNEL_NO_GCC := true

BOARD_BOOTCONFIG := \
    androidboot.hardware=qcom \
    androidboot.memcg=1 \
    androidboot.usbcontroller=a600000.dwc3

BOARD_KERNEL_CMDLINE := \
    androidboot.selinux=permissive \
    video=vfb:640x400,bpp=32,memsize=3072000 \
    firmware_class.path=/data/vendor/firmware_mnt/image \
    printk.devkmsg=on

BOARD_MKBOOTIMG_ARGS += \
    --dtb_offset $(BOARD_DTB_OFFSET) \
    --header_version $(BOARD_BOOT_HEADER_VERSION) \
    --ramdisk_offset $(BOARD_RAMDISK_OFFSET)

# Kernel prebuilt
TARGET_FORCE_PREBUILT_KERNEL := true
TARGET_NO_KERNEL_OVERRIDE := true
TARGET_NO_KERNEL := false
BOARD_KERNEL_BINARIES := kernel
TARGET_KERNEL_VERSION := 5.10
TARGET_KERNEL_SOURCE := $(DEVICE_PATH)-kernel/kernel-headers
TARGET_PREBUILT_DTB := $(DEVICE_PATH)-kernel/dtb.img
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)-kernel/dtbo.img
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)-kernel/kernel
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)-kernel/dtb.img:$(TARGET_COPY_OUT)/dtb.img \
    $(DEVICE_PATH)-kernel/kernel:kernel

# Kernel modules
DLKM_MODULES_PATH := $(DEVICE_PATH)-kernel/vendor_dlkm
RAMDISK_MODULES_PATH := $(DEVICE_PATH)-kernel/vendor_boot

BOARD_VENDOR_KERNEL_MODULES := $(wildcard $(DLKM_MODULES_PATH)/*.ko)
BOARD_VENDOR_KERNEL_MODULES_LOAD := $(patsubst %,$(DLKM_MODULES_PATH)/%,$(shell cat $(DLKM_MODULES_PATH)/modules.load))
BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE := $(DLKM_MODULES_PATH)/modules.blocklist

BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(wildcard $(RAMDISK_MODULES_PATH)/*.ko)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(patsubst %,$(RAMDISK_MODULES_PATH)/%,$(shell cat $(RAMDISK_MODULES_PATH)/modules.load))
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD  := $(patsubst %,$(RAMDISK_MODULES_PATH)/%,$(shell cat $(RAMDISK_MODULES_PATH)/modules.load.recovery))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE := $(RAMDISK_MODULES_PATH)/modules.blocklist

# Metadata
BOARD_USES_METADATA_PARTITION := true

# Partitions
BOARD_BUILD_VENDOR_RAMDISK_IMAGE := true

BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_DTBOIMG_PARTITION_SIZE := 24117248
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 134217728
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 100663296

BOARD_MOT_DP_GROUP_SIZE := 12679380992 # (BOARD_SUPER_PARTITION_SIZE - 4MB)
BOARD_SUPER_PARTITION_SIZE := 12683575296

BOARD_SUPER_PARTITION_GROUPS := mot_dp_group
BOARD_MOT_DP_GROUP_PARTITION_LIST := product system system_ext vendor vendor_dlkm

$(foreach p, $(call to-upper, $(BOARD_MOT_DP_GROUP_PARTITION_LIST)), \
    $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := ext4) \
    $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))

# Platform
TARGET_BOARD_PLATFORM := parrot

# Recovery
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/init/fstab.qcom
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 90
TARGET_RECOVERY_WIPE := $(DEVICE_PATH)/init/recovery.wipe
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Vintf
DEVICE_FRAMEWORK_MANIFEST_FILE += $(DEVICE_PATH)/vintf/framework_manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
    $(DEVICE_PATH)/vintf/device_framework_matrix.xml \
    hardware/qcom-caf/common/vendor_framework_compatibility_matrix.xml \
    vendor/lineage/config/device_framework_matrix.xml
DEVICE_MATRIX_FILE := hardware/qcom-caf/common/compatibility_matrix.xml
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/vintf/manifest.xml

ODM_MANIFEST_SKUS += n dn ne dne
ODM_MANIFEST_N_FILES := $(DEVICE_PATH)/vintf/sku/manifest_n.xml
ODM_MANIFEST_DN_FILES := $(DEVICE_PATH)/vintf/sku/manifest_dn.xml
ODM_MANIFEST_NE_FILES := $(DEVICE_PATH)/vintf/sku/manifest_ne.xml
ODM_MANIFEST_DNE_FILES := $(DEVICE_PATH)/vintf/sku/manifest_dne.xml

# Inherit the proprietary files
include vendor/motorola/paros/BoardConfigVendor.mk
