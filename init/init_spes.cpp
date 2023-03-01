/*
 * Copyright (C) 2022 Paranoid Android
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <cstdlib>
#include <fstream>
#include <string.h>
#include <unistd.h>
#include <vector>
#include <android-base/logging.h>

#include <android-base/properties.h>
#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>
#include <sys/sysinfo.h>

#include "property_service.h"
#include "vendor_init.h"

using android::base::GetProperty;
using std::string;

std::vector<std::string> ro_props_default_source_order = {
    "",
    "odm.",
    "odm_dlkm.",
    "product.",
    "system.",
    "system_ext.",
    "vendor.",
    "vendor_dlkm.",
};

void property_override(string prop, string value)
{
    auto pi = (prop_info*) __system_property_find(prop.c_str());

    if (pi != nullptr)
        __system_property_update(pi, value.c_str(), value.size());
    else
        __system_property_add(prop.c_str(), prop.size(), value.c_str(), value.size());
}

void load_redmi_spes() {
    property_override("bluetooth.device.default_name", "Redmi Note 11");
    property_override("ro.product.brand", "Redmi");
    property_override("ro.product.device", "spes");
    property_override("ro.product.manufacturer", "Xiaomi");
    property_override("ro.product.marketname", "Redmi Note 11");
    property_override("ro.product.model", "2201117TG");
    property_override("ro.product.mod_device", "spes_global");
    property_override("ro.product.name", "spes_global");
    property_override("vendor.usb.product_string", "Redmi Note 11");
}

void load_redmi_spes_in() {
    property_override("bluetooth.device.default_name", "Redmi Note 11");
    property_override("ro.product.brand", "Redmi");
    property_override("ro.product.device", "spes");
    property_override("ro.product.manufacturer", "Xiaomi");
    property_override("ro.product.marketname", "Redmi Note 11");
    property_override("ro.product.model", "2201117TI");
    property_override("ro.product.mod_device", "spes_in");
    property_override("ro.product.name", "spes_in");
    property_override("vendor.usb.product_string", "Redmi Note 11");
}

void load_redmi_spesn() {
    property_override("bluetooth.device.default_name", "Redmi Note 11 NFC");
    property_override("ro.product.brand", "Redmi");
    property_override("ro.product.device", "spesn");
    property_override("ro.product.manufacturer", "Xiaomi");
    property_override("ro.product.marketname", "Redmi Note 11 NFC");
    property_override("ro.product.model", "2201117TY");
    property_override("ro.product.mod_device", "spesn_gobal");
    property_override("ro.product.name", "spesn");
    property_override("vendor.usb.product_string", "Redmi Note 11 NFC");
}

void vendor_load_properties() {
    std::string region = GetProperty("ro.boot.hwc", "");
    if (access("/system/bin/recovery", F_OK) != 0) {
        if (region.find("India") != std::string::npos) {
           load_redmi_spes_in();
        } else if (region.find("Global") != std::string::npos) {
           load_redmi_spes();
        } else {
           load_redmi_spesn();
        }
    }

    // Set hardware revision
    property_override("ro.boot.hardware.revision", GetProperty("ro.boot.hwversion", "").c_str());

    // Set dalvik heap configuration
    std::string heapstartsize, heapgrowthlimit, heapsize, heapminfree,
			heapmaxfree, heaptargetutilization;

    struct sysinfo sys;
    sysinfo(&sys);

    if (sys.totalram > 5072ull * 1024 * 1024) {
        // from - phone-xhdpi-6144-dalvik-heap.mk
        heapstartsize = "16m";
        heapgrowthlimit = "256m";
        heapsize = "512m";
        heaptargetutilization = "0.5";
        heapminfree = "8m";
        heapmaxfree = "32m";
    } else if (sys.totalram > 3072ull * 1024 * 1024) {
        // from - phone-xhdpi-4096-dalvik-heap.mk
        heapstartsize = "8m";
        heapgrowthlimit = "192m";
        heapsize = "512m";
        heaptargetutilization = "0.6";
        heapminfree = "8m";
        heapmaxfree = "16m";
    } else {
        // from - phone-xhdpi-2048-dalvik-heap.mk
        heapstartsize = "8m";
        heapgrowthlimit = "192m";
        heapsize = "512m";
        heaptargetutilization = "0.75";
        heapminfree = "512k";
        heapmaxfree = "8m";
    }

    property_override("dalvik.vm.heapstartsize", heapstartsize);
    property_override("dalvik.vm.heapgrowthlimit", heapgrowthlimit);
    property_override("dalvik.vm.heapsize", heapsize);
    property_override("dalvik.vm.heaptargetutilization", heaptargetutilization);
    property_override("dalvik.vm.heapminfree", heapminfree);
    property_override("dalvik.vm.heapmaxfree", heapmaxfree);
}
