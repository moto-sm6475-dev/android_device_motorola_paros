#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# API levels
BOARD_API_LEVEL := 31
PRODUCT_SHIPPING_API_LEVEL := 34

# Product characteristics
PRODUCT_CHARACTERISTICS := nosdcard

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit the proprietary files
$(call inherit-product, vendor/motorola/paros/paros-vendor.mk)
