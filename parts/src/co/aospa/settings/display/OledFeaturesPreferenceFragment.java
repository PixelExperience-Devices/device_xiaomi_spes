/*
 * Copyright (C) 2023 Paranoid Android
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

package co.aospa.settings.display;

import android.content.Context;
import android.os.Bundle;
import android.os.SystemProperties;

import androidx.preference.ListPreference;
import androidx.preference.Preference;
import androidx.preference.PreferenceFragment;
import androidx.preference.SwitchPreference;

import co.aospa.settings.R;
import co.aospa.settings.utils.FileUtils;

public class OledFeaturesPreferenceFragment extends PreferenceFragment
       implements Preference.OnPreferenceChangeListener {

    public static final String HBM_NODE = "/sys/devices/platform/soc/soc:qcom,dsi-display-primary/hbm";
    public static final String HBM_PROP = "persist.oled.hbm_mode";

    public static final int HBM_MODE_OFF = 0;
    public static final int HBM_MODE_ON = 1;

    private static final String KEY_HBM = "hbm_pref";

    private SwitchPreference mHbmPref;

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        getActivity().getActionBar().setDisplayHomeAsUpEnabled(true);
    }

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        addPreferencesFromResource(R.xml.oled_features_settings);
        mHbmPref = (SwitchPreference) findPreference(KEY_HBM);
        restorePreferenceState();
        mHbmPref.setOnPreferenceChangeListener(this);
        validateKernelSupport();
    }

    @Override
    public void onResume() {
        super.onResume();
        restorePreferenceState();
        validateKernelSupport();
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object newValue) {
        final String key = preference.getKey();

        if (key.equals(KEY_HBM)) {
            boolean isHbmEnabled = (Boolean) newValue;
            mHbmPref.setChecked(isHbmEnabled);
            SystemProperties.set(HBM_PROP,
                String.valueOf(isHbmEnabled ? HBM_MODE_ON : HBM_MODE_OFF));
        }

        return true;
    }

    private void restorePreferenceState() {
        boolean isHbmEnabled = SystemProperties.getInt(HBM_PROP, HBM_MODE_OFF) > HBM_MODE_OFF;
        mHbmPref.setChecked(isHbmEnabled);
    }

    private void validateKernelSupport() {
        if (!FileUtils.fileExists(HBM_NODE)) {
            mHbmPref.setSummary(getResources().getString(R.string.kernel_not_supported));
            mHbmPref.setEnabled(false);
        }
    }
}
