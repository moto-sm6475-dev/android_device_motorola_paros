#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# API levels
BOARD_API_LEVEL := 31
PRODUCT_SHIPPING_API_LEVEL := 34

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# Init
# Copy fstab.qcom to the vendor ramdisk first stage directory
$(foreach f,$(wildcard $(LOCAL_PATH)/rootdir/etc/fstab.qcom),\
    $(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/$(notdir $(f))))

# Product characteristics
PRODUCT_CHARACTERISTICS := nosdcard

# Recovery
$(foreach f,$(wildcard $(LOCAL_PATH)/recovery/root/init.recovery.qcom.rc),\
    $(eval PRODUCT_COPY_FILES += $(f):recovery/root/init/$(notdir $(f))))

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit the proprietary files
$(call inherit-product, vendor/motorola/paros/paros-vendor.mk)
