# Copyright (C) 2022 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
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

#power/perf tunings for khaje
# Core control parameters on big
echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/enable
echo 2 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
echo 40 > /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres
echo 60 > /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres
echo 100 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms
echo 4 > /sys/devices/system/cpu/cpu4/core_ctl/task_thres

# cpuset settings
echo 0-3 > /dev/cpuset/background/cpus
echo 0-3 > /dev/cpuset/system-background/cpus
echo 0-3 > /dev/cpuset/restricted/cpus
echo 0-7 > /dev/cpuset/top-app/cpus

# Setting b.L scheduler parameters
echo 85 > /proc/sys/kernel/sched_downmigrate
echo 95 > /proc/sys/kernel/sched_upmigrate
echo 85 > /proc/sys/kernel/sched_group_downmigrate
echo 100 > /proc/sys/kernel/sched_group_upmigrate

# configure governor settings for little cluster
echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 500 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us
echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us
echo 1804800 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_freq
echo 940800 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/rtg_boost_freq

# configure governor settings for big cluster
echo "schedutil" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo 500 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/up_rate_limit_us
echo 20000 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/down_rate_limit_us
echo 2208000 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/hispeed_freq
echo 1056000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/rtg_boost_freq

echo "0:1190000" > /sys/devices/system/cpu/cpu_boost/input_boost_freq
echo 120 > /sys/devices/system/cpu/cpu_boost/input_boost_ms
echo "0:1900800 1:0 2:0 3:0 4:2400000 5:0 6:0 7:0" > /sys/devices/system/cpu/cpu_boost/powerkey_input_boost_freq
echo 400 > /sys/devices/system/cpu/cpu_boost/powerkey_input_boost_ms

echo 1 > /proc/sys/kernel/sched_walt_rotate_big_tasks

# sched_load_boost as -6 is equivalent to target load as 85. It is per cpu tunable.
echo -6 >  /sys/devices/system/cpu/cpu0/sched_load_boost
echo -6 >  /sys/devices/system/cpu/cpu1/sched_load_boost
echo -6 >  /sys/devices/system/cpu/cpu2/sched_load_boost
echo -6 >  /sys/devices/system/cpu/cpu3/sched_load_boost
echo -6 >  /sys/devices/system/cpu/cpu4/sched_load_boost
echo -6 >  /sys/devices/system/cpu/cpu5/sched_load_boost
echo -6 >  /sys/devices/system/cpu/cpu6/sched_load_boost
echo -6 >  /sys/devices/system/cpu/cpu7/sched_load_boost
echo 85 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_load
echo 85 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/hispeed_load

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

echo N > /sys/module/lpm_levels/system/pwr/pwr-l2-gdhs/idle_enabled
echo N > /sys/module/lpm_levels/system/perf/perf-l2-gdhs/idle_enabled
echo N > /sys/module/lpm_levels/system/pwr/pwr-l2-gdhs/suspend_enabled
echo N > /sys/module/lpm_levels/system/perf/perf-l2-gdhs/suspend_enabled
# Turn on sleep modes
echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled

setprop vendor.post_boot.parsed 1
