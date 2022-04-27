package com.rioapp.demo.imeiplugin.utils;

import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.net.NetworkInterface;
import java.util.Collections;
import java.util.List;
import java.util.Locale;

/**
 * Description:
 * Author: 宋佳宾
 * create on: 2021/4/25 18:01
 */
public class MacUtils {
    /**
     * 获取MAC 地址
     *
     * @param context
     * @return
     */
    public static String getMacAddress(Context context) {
        String macAddress = null;
        try {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
                // Android  6.0 之前（不包括6.0）
                macAddress = getMacDefault(context);
                if (!TextUtils.isEmpty(macAddress)) {
//                    macAddress = macAddress.replaceAll(":", "");
                    if (macAddress.equalsIgnoreCase("020000000000") == false) {
                        return macAddress;
                    }
                }
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
                // Android 6.0（包括） - Android 7.0（不包括）
                macAddress = getMacBelowSeven();
                if (!TextUtils.isEmpty(macAddress)) {
//                    macAddress = macAddress.replaceAll(":", "");
                    if (macAddress.equalsIgnoreCase("020000000000") == false) {
                        return macAddress;
                    }
                }
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                // 高于7.0
                macAddress = getMacAboveSeven();
                if (!TextUtils.isEmpty(macAddress)) {
//                    macAddress = macAddress.replaceAll(":", "");
                    if (macAddress.equalsIgnoreCase("020000000000") == false) {
                        return macAddress;
                    }
                }
            }

        } catch (Exception e) {

        }
        return macAddress;
    }


    /**
     * 获取MAC  Android  6.0 之前（不包括6.0）
     * 必须的权限  <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
     *
     * @param context
     * @return
     */
    private static String getMacDefault(Context context) {
        String mac = null;
        if (context == null) {
            return mac;
        }

        WifiManager wifi = (WifiManager) context.getApplicationContext()
                .getSystemService(Context.WIFI_SERVICE);
        if (wifi == null) {
            return mac;
        }
        WifiInfo info = null;
        try {
            info = wifi.getConnectionInfo();
        } catch (Exception e) {

        }
        if (info == null) {
            return null;
        }
        mac = info.getMacAddress();
        if (!TextUtils.isEmpty(mac)) {
            mac = mac.toUpperCase(Locale.ENGLISH);
        }
        return mac;
    }

    /**
     * 获取MAC  Android  6.0 之前（不包括6.0）
     * Android 6.0（包括） - Android 7.0（不包括）
     *
     * @return
     */
    private static String getMacBelowSeven() {
        String WifiAddress = null;
        try {
            WifiAddress = new BufferedReader(new FileReader(new File("/sys/class/net/wlan0/address"))).readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return WifiAddress;
    }

    /**
     * 遍历循环所有的网络接口，找到接口是 wlan0
     * 必须的权限 <uses-permission android:name="android.permission.INTERNET" />
     *
     * @return
     */
    private static String getMacAboveSeven() {
        try {
            List<NetworkInterface> all = Collections.list(NetworkInterface.getNetworkInterfaces());
            Log.d("Utils", "all:" + all.size());
            for (NetworkInterface nif : all) {
                if (!nif.getName().equalsIgnoreCase("wlan0")) {
                    continue;
                }

                byte[] macBytes = nif.getHardwareAddress();
                if (macBytes == null) {
                    return null;
                }
                Log.d("Utils", "macBytes:" + macBytes.length + "," + nif.getName());

                StringBuilder res1 = new StringBuilder();
                for (byte b : macBytes) {
                    res1.append(String.format("%02X:", b));
                }

                if (res1.length() > 0) {
                    res1.deleteCharAt(res1.length() - 1);
                }
                return res1.toString();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
