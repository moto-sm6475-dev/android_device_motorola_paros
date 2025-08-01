#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from paros device
$(call inherit-product, device/motorola/paros/device.mk)

PRODUCT_DEVICE := paros
PRODUCT_NAME := lineage_paros
PRODUCT_BRAND := motorola
PRODUCT_MODEL := moto g75 5G
PRODUCT_MANUFACTURER := motorola

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="paros_g-user 15 V1UQS35M-V1-ST14 0c79b release-keys"

BUILD_FINGERPRINT := motorola/paros_g/paros:15/V1UQS35M-V1-ST14/0c79b:user/release-keys
