#! /vendor/bin/sh
#
# Copyright (c) 2021 The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Changes from Qualcomm Innovation Center are provided under the following license:
# Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

soc_id=`cat /sys/devices/soc0/soc_id` 2> /dev/null

# Store soc_id in ro.vendor.qti.soc_id
setprop ro.vendor.qti.soc_id $soc_id

if [ "$soc_id" -eq 444 ]; then
    setprop ro.vendor.qti.soc_model SM6115
elif [ "$soc_id" -eq 417 ]; then
    setprop ro.vendor.qti.soc_model SM4250
elif [ "$soc_id" -eq 441 ]; then
    setprop ro.vendor.qti.soc_model SM4125
elif [ "$soc_id" -eq 518 ] || [ "$soc_id" -eq 561 ]; then
    setprop ro.vendor.qti.soc_model SM6225
elif [ "$soc_id" -eq 469 ]; then
    setprop ro.vendor.qti.soc_model QCM4290
elif [ "$soc_id" -eq 470 ]; then
    setprop ro.vendor.qti.soc_model QCS4290
elif [ "$soc_id" -eq 473 ]; then
    setprop ro.vendor.qti.soc_model QCM2290
elif [ "$soc_id" -eq 474 ]; then
    setprop ro.vendor.qti.soc_model QCS2290
elif [ "$soc_id" -eq 497 ]; then
    setprop ro.vendor.qti.soc_model QCM6490
elif [ "$soc_id" -eq 498 ]; then
    setprop ro.vendor.qti.soc_model QCS6490
elif [ "$soc_id" -eq 585 ]; then
    setprop ro.vendor.qti.soc_model SG4150P
fi
