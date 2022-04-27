import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

class RikiUniqueCode {
  static const MethodChannel _channel = const MethodChannel('unique_code');

  /// 获取渠道安装名称
  static Future<String?> getInstallChannelName() async {
    return await _channel.invokeMethod('getChannelName');
  }

  /// 获取 imei
  /// 当Android版本>10的时候返回null
  /// 当Android版本>=6的需要动态申请权限，权限拒绝的话返回为null
  static Future<String?> getImei() async {
    final String? imei = await _channel.invokeMethod('getImei');
    return imei;
  }

  /// 获取 imei
  /// 如果是双卡的话 以数组的方式返回
  /// 当Android版本>10的时候返回null
  /// 当Android版本>=6的需要动态申请权限，权限拒绝的话返回为null
  static Future<List<String>?> getImeiMulti() async {
    final List<String>? imeis = await _channel.invokeListMethod('getImeiMulti');
    return imeis;
  }

  /// 获取 MAC 地址
  /// 没有返回null
  static Future<String?> getMac() async {
    final String? macAddress = await _channel.invokeMethod('getMac');
    return macAddress;
  }

  /// 获取Android id
  static Future<String> getAndroidId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    }
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.androidId;
  }

  /// 获取IpAddress 地址
  static Future<String?> getIpAddress() async {
    final String? ipAddress = await _channel.invokeMethod('getIp');
    return ipAddress;
  }

  /// 获取 Ua 地址
  static Future<String?> getUaInfo() async {
    final String? uaInfo = await _channel.invokeMethod('getUa');
    return uaInfo;
  }

  /// 获取 OAID
  static Future<String?> getOAID() async {
    final String? oaidInfo = await _channel.invokeMethod('getOAID');
    return oaidInfo;
  }

  ///iOS的广告标识符IDFA的获得
  static Future<String?> getAdvertisingId() async {
    final String? advertisingId = await _channel.invokeMethod("getIDFA");
    return advertisingId;
  }
}
