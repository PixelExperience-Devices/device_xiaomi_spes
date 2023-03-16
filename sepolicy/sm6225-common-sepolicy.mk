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
    device/xiaomi/sm6225-common/sepolicy/public

# Private Sepolicy
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    device/xiaomi/sm6225-common/sepolicy/private

# QCOM Sepolicy
BOARD_VENDOR_SEPOLICY_DIRS += \
    device/xiaomi/sm6225-common/sepolicy/vendor/qcom

# Xiaomi and (Device specific) Sepolicy
BOARD_VENDOR_SEPOLICY_DIRS += \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/audio-sensors \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/battery \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/bluetooth \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/camera \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/charger \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/common \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/fingerprint \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/ir \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/last_kmsg \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/light \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/modem \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/nfc \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/power \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/power_supply \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/thermald \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/usb \
    device/xiaomi/sm6225-common/sepolicy/vendor/xiaomi/vibrator
