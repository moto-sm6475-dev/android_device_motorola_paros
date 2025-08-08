#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.extract import extract_fns_user_type
from extract_utils.extract_star import extract_star_firmware

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)

from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups,
    lib_fixups_user_type,
)

from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/motorola/paros',
    'hardware/qcom-caf/sm8450',
    'hardware/qcom-caf/wlan',
    'hardware/motorola',
    'vendor/qcom/opensource/commonsys-intf/display',
    'vendor/qcom/opensource/commonsys/display',
    'vendor/qcom/opensource/dataservices',
    'vendor/qcom/opensource/display',
]

def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
    'vendor.qti.hardware.qccsyshal@1.0',
    'vendor.qti.hardware.qccsyshal@1.1',
    'vendor.qti.qspmhal@1.0',
    'vendor.qti.imsrtpservice@3.0',
    'vendor.qti.diaghal@1.0',
    'com.qualcomm.qti.dpm.api@1.0',
    ): lib_fixup_vendor_suffix,
    (
    'libar-pal',
    'libar-acdb',
    'liblx-osal',
    'libats',
    'libagm',
    'libpalclient',
    ): lib_fixup_remove,
}

blob_fixups: blob_fixups_user_type = {
    'system_ext/etc/permissions/moto-telephony.xml': blob_fixup()
        .regex_replace('/system/', '/system_ext/'),
    ('vendor/bin/hw/android.hardware.security.keymint-service-qti', 'vendor/lib64/libqtikeymint.so'): blob_fixup()
        .replace_needed('android.hardware.security.keymint-V1-ndk_platform.so', 'android.hardware.security.keymint-V1-ndk.so')
        .replace_needed('android.hardware.security.secureclock-V1-ndk_platform.so', 'android.hardware.security.secureclock-V1-ndk.so')
        .replace_needed('android.hardware.security.sharedsecret-V1-ndk_platform.so', 'android.hardware.security.sharedsecret-V1-ndk.so')
        .add_needed('android.hardware.security.rkp-V1-ndk.so'),
    'vendor/bin/qcc-trd': blob_fixup()
        .replace_needed('libgrpc++_unsecure.so', 'libgrpc++_unsecure_prebuilt.so'),
     ('vendor/bin/hw/android.hardware.gnss-aidl-service-qti', 'vendor/lib64/hw/android.hardware.gnss-aidl-impl-qti.so', 'vendor/lib64/libgarden.so', 'vendor/lib64/libgarden_haltests_e2e.so',): blob_fixup()
        .replace_needed('android.hardware.gnss-V1-ndk_platform.so', 'android.hardware.gnss-V1-ndk.so',),
    'vendor/lib64/libmotext_inf.so': blob_fixup()
        .remove_needed('libril.so'),
    'vendor/lib64/vendor.libdpmframework.so': blob_fixup()
        .add_needed('libhidlbase_shim.so'),
    'vendor/lib64/libqcodec2_core.so': blob_fixup()
        .add_needed('libcodec2_shim.so'),
    'vendor/lib64/sensors.moto.so': blob_fixup()
        .add_needed('libbase_shim.so'),
    ('vendor/etc/seccomp_policy/atfwd@2.0.policy', 'vendor/etc/seccomp_policy/modemManager.policy', 'vendor/etc/seccomp_policy/sensors-qesdk.policy'): blob_fixup()
        .add_line_if_missing('gettid: 1'),
    ('vendor/lib64/libqcrilNr.so', 'vendor/lib64/libril-db.so'): blob_fixup()
        .binary_regex_replace(rb'persist\.vendor\.radio\.poweron_opt', b'persist.vendor.radio.poweron_ign'),
    'vendor/lib64/libcamximageformatutils.so': blob_fixup()
        .replace_needed('vendor.qti.hardware.display.config-V2-ndk_platform.so', 'vendor.qti.hardware.display.config-V2-ndk.so'),
    'system_ext/lib64/libwfdmmsrc_system.so': blob_fixup()
        .add_needed('libgui_shim.so'),
    'system_ext/lib64/libwfdnative.so': blob_fixup()
        .add_needed('libbinder_shim.so')
        .add_needed('libinput_shim.so')
        .replace_needed('android.hidl.base@1.0.so', 'libhidlbase.so'),
    'system_ext/lib64/libwfdservice.so': blob_fixup()
        .replace_needed('android.media.audio.common.types-V2-cpp.so', 'android.media.audio.common.types-V4-cpp.so'),
    'vendor/etc/media_codecs_c2_audio.xml': blob_fixup()
        .regex_replace('.+media_codecs_dolby_audio.+\n', ''),
    ('vendor/etc/media_codecs_parrot_v0.xml', 'vendor/etc/media_codecs_parrot_v1.xml', 'vendor/etc/media_codecs_parrot_v2.xml', 'vendor/etc/media_codecs.xml', 'vendor/etc/media_codecs_ravelin.xml',): blob_fixup()
        .regex_replace('.+media_codecs_(google_audio|google_c2|google_telephony|vendor_audio).+\n', ''),
    'vendor/etc/seccomp_policy/c2audio.vendor.ext-arm64.policy': blob_fixup()
        .add_line_if_missing('setsockopt: 1'),
    'vendor/etc/vintf/manifest/c2_manifest_vendor.xml': blob_fixup()
        .regex_replace('.+dolby.+\n', ''),
}  # fmt: skip

extract_fns: extract_fns_user_type = {
    r'(bootloader|radio)\.img': extract_star_firmware,
}

module = ExtractUtilsModule(
    'paros',
    'motorola',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
    add_generated_carriersettings=True,
    add_firmware_proprietary_file=True,
    extract_fns=extract_fns,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
