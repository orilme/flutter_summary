import 'dart:convert';
import 'dart:io';

import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:package_info/package_info.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_demo/base/utils/text_util.dart';
import 'package:flutter_demo/base/utils/screen_util/flutter_screenutil.dart';
import 'package:flutter_demo/base/network/entity/DeviceInfoEntity.dart';

import 'md5_util.dart';

/// 设备信息工具类

class DeviceUtil {
  static final String ios_device_id_key = Md5Util.generateMd5('com.dabanjia.rikiuser');

  static String? deviceInfoStr;

  static Future<String?> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    DeviceInfoEntity deviceInfoEntity = DeviceInfoEntity();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String androidVersion = androidInfo.version.sdkInt.toString();
      String osType = 'android';
      String deviceName = androidInfo.device;
      deviceInfoEntity.osType = osType;
      deviceInfoEntity.deviceName = deviceName;
      deviceInfoEntity.systemVersion = androidVersion;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceInfoEntity.osType = 'ios';
      deviceInfoEntity.deviceName = iosInfo.name;
      deviceInfoEntity.systemVersion = iosInfo.systemVersion;
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    deviceInfoEntity.appVersion = appVersion;

    String netType = '';
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      netType = 'mobile';
    } else if (connectivityResult == ConnectivityResult.wifi) {
      netType = 'wifi';
    }
    deviceInfoEntity.netType = netType;

    double height = ScreenUtil().screenHeight;
    double width = ScreenUtil().screenWidth;
    deviceInfoEntity.screenRatio = height.toString() + "*" + width.toString();

    deviceInfoStr = jsonEncode(deviceInfoEntity);
    return deviceInfoStr;
  }

  /// 设备ID
  Future<String> getIOSDeviceID() async {
    String? uuid = await FlutterKeychain.get(key: ios_device_id_key);
    if (TextUtil.isEmpty(uuid)) {
      String _uuid = await _getUUID();
      FlutterKeychain.put(key: ios_device_id_key, value: _uuid);
      return _uuid;
    }

    return uuid ?? '';
  }

  //获取iOS的UUID
  Future<String> _getUUID() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor.replaceAll('-', '');
  }
}
