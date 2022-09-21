# Copyright (C) 2022 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Public Sepolicy
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += \
    device/xiaomi/spes/sepolicy/public

# Private Sepolicy
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    device/xiaomi/spes/sepolicy/private

# QCOM Sepolicy
BOARD_VENDOR_SEPOLICY_DIRS += \
    device/xiaomi/spes/sepolicy/vendor/qcom

# Xiaomi and (Device specific) Sepolicy
BOARD_VENDOR_SEPOLICY_DIRS += \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/audio-sensors \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/battery \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/bluetooth \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/camera \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/charger \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/common \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/fingerprint \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/ir \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/last_kmsg \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/light \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/modem \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/nfc \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/power \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/power_supply \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/thermald \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/usb \
    device/xiaomi/spes/sepolicy/vendor/xiaomi/vibrator
