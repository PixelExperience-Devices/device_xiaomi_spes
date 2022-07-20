# Copyright (C) 2022 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function configure_read_ahead_kb_values() {
    MemTotalStr=`cat /proc/meminfo | grep MemTotal`
    MemTotal=${MemTotalStr:16:8}

    dmpts=$(ls /sys/block/*/queue/read_ahead_kb | grep -e dm -e mmc)

    # Set 128 for <= 3GB &
    # set 512 for >= 4GB targets.
    if [ $MemTotal -le 3145728 ]; then
        echo 128 > /sys/block/mmcblk0/bdi/read_ahead_kb
        echo 128 > /sys/block/mmcblk0rpmb/bdi/read_ahead_kb
        for dm in $dmpts; do
            echo 128 > $dm
        done
    else
        echo 512 > /sys/block/mmcblk0/bdi/read_ahead_kb
        echo 512 > /sys/block/mmcblk0rpmb/bdi/read_ahead_kb
        for dm in $dmpts; do
            echo 512 > $dm
        done
    fi
}

function configure_memory_parameters() {
    # Set Memory parameters.
    #
    # Set per_process_reclaim tuning parameters
    # All targets will use vmpressure range 50-70,
    # All targets will use 512 pages swap size.
    #
    # Set Low memory killer minfree parameters
    # 32 bit Non-Go, all memory configurations will use 15K series
    # 32 bit Go, all memory configurations will use uLMK + Memcg
    # 64 bit will use Google default LMK series.
    #
    # Set ALMK parameters (usually above the highest minfree values)
    # vmpressure_file_min threshold is always set slightly higher
    # than LMK minfree's last bin value for all targets. It is calculated as
    # vmpressure_file_min = (last bin - second last bin ) + last bin
    #
    # Set allocstall_threshold to 0 for all targets.
    #

low_ram=`getprop ro.config.low_ram`

configure_read_ahead_kb_values

# Set parameters for 32-bit Go targets.
if [ "$low_ram" == "true" ]; then
    if [ -f /proc/sys/vm/reap_mem_on_sigkill ]; then
        echo 1 > /proc/sys/vm/reap_mem_on_sigkill
    fi
else
    #Set PPR nomap parameters for bengal targets
    echo 1 > /sys/module/process_reclaim/parameters/enable_process_reclaim
    echo 50 > /sys/module/process_reclaim/parameters/pressure_min
    echo 70 > /sys/module/process_reclaim/parameters/pressure_max
    echo 30 > /sys/module/process_reclaim/parameters/swap_opt_eff
    echo 0 > /sys/module/process_reclaim/parameters/per_swap_size
    echo 7680 > /sys/module/process_reclaim/parameters/tsk_nomap_swap_sz

    # Disable wsf for all targets beacause we are using efk.
    # wsf Range : 1..1000 So set to bare minimum value 1.
    echo 1 > /proc/sys/vm/watermark_scale_factor

    # Disable the feature of watermark boost
    MemTotalStr=`cat /proc/meminfo | grep MemTotal`
    MemTotal=${MemTotalStr:16:8}

    if [ $MemTotal -le 6291456 ]; then
        echo 0 > /proc/sys/vm/watermark_boost_factor
    fi
fi
}

# Apply Settings for bengal
# fix ECC Crash
echo N > /sys/module/lpm_levels/system/pwr/pwr-l2-gdhs/idle_enabled
echo N > /sys/module/lpm_levels/system/perf/perf-l2-gdhs/idle_enabled
echo N > /sys/module/lpm_levels/system/pwr/pwr-l2-gdhs/suspend_enabled
echo N > /sys/module/lpm_levels/system/perf/perf-l2-gdhs/suspend_enabled

setprop vendor.post_boot.parsed 1

# Set Memory parameters
configure_memory_parameters

# Enable bus-dcvs
for device in /sys/devices/platform/soc
do
    for cpubw in $device/*cpu-cpu-ddr-bw/devfreq/*cpu-cpu-ddr-bw
    do
        echo "bw_hwmon" > $cpubw/governor
        echo 50 > $cpubw/polling_interval
        echo 762 > $cpubw/min_freq
        echo "2288 3440 4173 5195 5859 7759 10322 11863 13763 15960" > $cpubw/bw_hwmon/mbps_zones
        echo 85 > $cpubw/bw_hwmon/io_percent
        echo 4 > $cpubw/bw_hwmon/sample_ms
        echo 90 > $cpubw/bw_hwmon/decay_rate
        echo 190 > $cpubw/bw_hwmon/bw_step
        echo 20 > $cpubw/bw_hwmon/hist_memory
        echo 0 > $cpubw/bw_hwmon/hyst_length
        echo 80 > $cpubw/bw_hwmon/down_thres
        echo 0 > $cpubw/bw_hwmon/guard_band_mbps
        echo 250 > $cpubw/bw_hwmon/up_scale
        echo 1600 > $cpubw/bw_hwmon/idle_mbps
    done
done

# memlat specific settings are moved to seperate file under
# device/target specific folder
setprop vendor.dcvs.prop 1

# colcoation v3 disabled
echo 0 > /proc/sys/kernel/sched_min_task_util_for_boost
echo 0 > /proc/sys/kernel/sched_min_task_util_for_colocation

# Turn off scheduler boost at the end
echo 0 > /proc/sys/kernel/sched_boost

# Turn on sleep modes
echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
