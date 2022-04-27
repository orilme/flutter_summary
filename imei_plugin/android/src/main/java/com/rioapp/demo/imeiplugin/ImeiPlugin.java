package com.rioapp.demo.imeiplugin;

import android.Manifest;
import android.app.Activity;
import android.content.ContentResolver;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.telephony.TelephonyManager;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;


import com.github.gzuliyujiang.oaid.DeviceID;
import com.github.gzuliyujiang.oaid.IGetter;
import com.rioapp.demo.imeiplugin.utils.IpAddressUtils;
import com.rioapp.demo.imeiplugin.utils.MacUtils;
import com.rioapp.demo.imeiplugin.utils.UaUtils;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.UUID;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * ImeiPlugin
 */
public class ImeiPlugin implements MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {

    private final Activity activity;
    private final ContentResolver contentResolver;

    private static final int MY_PERMISSIONS_REQUEST_READ_PHONE_STATE = 1995;
    private static final int MY_PERMISSIONS_REQUEST_READ_PHONE_STATE_IMEI_MULTI = 1997;
    private static final String PREF_UNIQUE_ID = "PREF_UNIQUE_ID_99599";
    private ResultWrapper mResult;
    private static boolean ssrpr = false;
    private static final String metaTagChannelName = "riki_gio_channel_name";
    private static final String ERCODE_PERMISSIONS_DENIED = "2000";
    private static android.content.Context context;

    static class ResultWrapper implements Result{
        final WeakReference<Result> result;

        ResultWrapper(Result result) {
            this.result = new WeakReference<>(result);
        }

        @Override
        public void success(@Nullable Object o) {
            try {
                result.get().success(o);
            }catch (Exception e){
                e.printStackTrace();
            }
        }

        @Override
        public void error(String s, @Nullable String s1, @Nullable Object o) {
            try {
                result.get().error(s, s1, o);
            }catch (Exception e){
                e.printStackTrace();
            }

        }

        @Override
        public void notImplemented() {
            try {
                result.get().notImplemented();
            }catch (Exception e){
                e.printStackTrace();
            }

        }
    }

    /**
     * Plugin registration.
     * add Listener Request permission
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "unique_code");
        context = registrar.activeContext();
        registrar.activity().getPackageName();
        ImeiPlugin imeiPlugin = new ImeiPlugin(registrar.activity(), registrar.context().getContentResolver());
        channel.setMethodCallHandler(imeiPlugin);
        registrar.addRequestPermissionsResultListener(imeiPlugin);
    }


    private ImeiPlugin(Activity activity, ContentResolver contentResolver) {
        this.activity = activity;
        this.contentResolver = contentResolver;
    }

    private void getImei(Activity activity, Result result) {
        try {
            //如果大于Android9.0那么就返回空吧

            if (android.os.Build.VERSION.SDK_INT > Build.VERSION_CODES.P) {
                result.success(null);
            } else if (ContextCompat.checkSelfPermission((activity), Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
                TelephonyManager telephonyManager = (TelephonyManager) activity.getSystemService(Context.TELEPHONY_SERVICE);
                // 如果大于等于Android 8
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                    result.success(telephonyManager.getImei());
                else
                    result.success(telephonyManager.getDeviceId());

            } else {
                if (ssrpr && ActivityCompat.shouldShowRequestPermissionRationale(activity, Manifest.permission.READ_PHONE_STATE))
                    result.error(ERCODE_PERMISSIONS_DENIED, "Permission Denied", null);
                else
                    ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.READ_PHONE_STATE}, MY_PERMISSIONS_REQUEST_READ_PHONE_STATE);
            }

        } catch (Exception ex) {
            result.success("unknown");
        }
    }

    private void getImeiMulti(Activity activity, Result result) {
        try {

            if (android.os.Build.VERSION.SDK_INT > Build.VERSION_CODES.P) {
                result.success(null);
            } else if (ContextCompat.checkSelfPermission((activity), Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
                TelephonyManager telephonyManager = (TelephonyManager) activity.getSystemService(Context.TELEPHONY_SERVICE);

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    int phoneCount = telephonyManager.getPhoneCount();

                    ArrayList<String> imeis = new ArrayList<>();
                    for (int i = 0; i < phoneCount; i++) {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                            imeis.add(telephonyManager.getImei(i));
                        else
                            imeis.add(telephonyManager.getDeviceId(i));
                    }
                    result.success(imeis);
                } else {
                    result.success(Arrays.asList(telephonyManager.getDeviceId()));
                }

            } else {
                if (ssrpr && ActivityCompat.shouldShowRequestPermissionRationale(activity, Manifest.permission.READ_PHONE_STATE))
                    result.error(ERCODE_PERMISSIONS_DENIED, "Permission Denied", null);
                else
                    ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.READ_PHONE_STATE}, MY_PERMISSIONS_REQUEST_READ_PHONE_STATE_IMEI_MULTI);

            }

        } catch (Exception ex) {
            result.success("unknown");
        }
    }

    private synchronized String getUUID(Context context) {

        SharedPreferences sharedPrefs = context.getSharedPreferences(
                PREF_UNIQUE_ID, Context.MODE_PRIVATE);
        String uniqueID = sharedPrefs.getString(PREF_UNIQUE_ID, null);
        if (uniqueID == null) {
            uniqueID = UUID.randomUUID().toString();
            SharedPreferences.Editor editor = sharedPrefs.edit();
            editor.putString(PREF_UNIQUE_ID, uniqueID);
            editor.commit();
        }

        return uniqueID;
    }

    private void getID(Context context, Result result) {
        result.success(getUUID(context));
    }


    private void getChannelName(Activity activity, Result result) {
        try {
            ApplicationInfo info = activity.getPackageManager()
                    .getApplicationInfo(activity.getPackageName(), PackageManager.GET_META_DATA);
            String channelName = info.metaData.getString(metaTagChannelName);
            result.success(channelName);
        } catch (Exception e) {
            e.printStackTrace();
            result.success(null);
        }

    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull Result result) {
        mResult = new ResultWrapper(result);

        if (call.method.equals("getChannelName")) {
            getChannelName(activity, mResult);
        } else if (call.method.equals("getImei"))
            getImei(activity, mResult);
        else if (call.method.equals("getImeiMulti"))
            getImeiMulti(activity, result);
        else if (call.method.equals("getId"))
            getID(activity, result);
        else if (call.method.equals("getMac"))
            getMac(activity, result);
        else if (call.method.equals("getIp"))
            getIp(result);
        else if (call.method.equals("getUa"))
            getUa(activity, result);
        else if (call.method.equals("getIDFA"))
            getIDFA(activity, result);
        else if (call.method.equals("getOAID")) {
            getOAID(activity, result);
        } else
            mResult.notImplemented();

    }

    /**
     * 获取mac地址
     *
     * @param activity
     * @param result
     */
    private void getMac(Activity activity, Result result) {
        String macAdress = MacUtils.getMacAddress(activity);
        result.success(macAdress);
    }


    /**
     * 获取IDFA
     */
    private void getIDFA(Activity activity, Result result) {
        result.success("-1");
    }

    /**
     * 获取ip地址
     *
     * @param result
     */
    private void getIp(Result result) {
        String macAdress = IpAddressUtils.getLocalIpAddress();
        result.success(macAdress);
    }


    /**
     * 获取 ua 信息
     *
     * @param activity
     * @param result
     */
    private void getUa(Activity activity, Result result) {
        String uaInfo = UaUtils.getUserAgent(activity);
        result.success(uaInfo);
    }

    /**
     * 获取OAID
     *
     * @param activity
     * @param result
     */
    private void getOAID(Activity activity, final Result result) {
//        final StringBuilder builder = new StringBuilder();
//        builder.append("UniqueID: ");
//        // 获取设备唯一标识，只支持Android 10之前的系统，需要READ_PHONE_STATE权限，可能为空
//        String uniqueID = DeviceID.getUniqueID(context);
//        if (TextUtils.isEmpty(uniqueID)) {
//            builder.append("DID/IMEI/MEID获取失败");
//        } else {
//            builder.append(uniqueID);
//        }
//        builder.append("\n");
//        builder.append("AndroidID: ");
//        // 获取安卓ID，可能为空
//        String androidID = DeviceID.getAndroidID(context);
//        if (TextUtils.isEmpty(androidID)) {
//            builder.append("AndroidID获取失败");
//        } else {
//            builder.append(androidID);
//        }
//        builder.append("\n");
//        builder.append("WidevineID: ");
//        // 获取数字版权管理ID，可能为空
//        String widevineID = DeviceID.getWidevineID(context);
//        if (TextUtils.isEmpty(widevineID)) {
//            builder.append("WidevineID获取失败");
//        } else {
//            builder.append(widevineID);
//        }
//        builder.append("\n");
//        builder.append("PseudoID: ");
//        // 获取伪造ID，根据硬件信息生成，不会为空，有大概率会重复
//        builder.append(DeviceID.getPseudoID());
//        builder.append("\n");
//        builder.append("GUID: ");
//        // 获取GUID，随机生成，不会为空
//        builder.append(DeviceID.getGUID(context));
//        builder.append("\n");
//        // 是否支持OAID
//        builder.append("supportedOAID:").append(DeviceID.supportedOAID(context));
//        builder.append("\n");
        // 获取OAID，异步回调
        DeviceID.getOAID(context, new IGetter() {
            @Override
            public void onOAIDGetComplete(@NonNull String re) {
                // 不同厂商的OAID格式是不一样的，可进行MD5、SHA1之类的哈希运算统一
//                builder.append("OAID: ").append(re);
                Log.v("------------>", re.toString());
                result.success(re);
            }

            @Override
            public void onOAIDGetError(@NonNull Throwable error) {
                // 获取OAID失败
//                builder.append("OAID: ").append(error);
                Log.v("------------>", error.toString());
                result.success("");
            }
        });
    }


    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] results) {
        if (requestCode == MY_PERMISSIONS_REQUEST_READ_PHONE_STATE || requestCode == MY_PERMISSIONS_REQUEST_READ_PHONE_STATE_IMEI_MULTI) {
            if (results[0] == PackageManager.PERMISSION_GRANTED) {
                if (requestCode == MY_PERMISSIONS_REQUEST_READ_PHONE_STATE) {
                    getImei(activity, mResult);
                } else {
                    getImeiMulti(activity, mResult);
                }
            } else {
                mResult.success(null);
            }
            return true;
        }

        return false;
    }


}
