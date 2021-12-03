import 'dart:async';
import 'dart:core';
import 'dart:io' show Platform;

import 'package:device_info/device_info.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

import 'package:flutter_demo/utils/md5_util.dart';
import 'package:flutter_demo/utils/sp_util.dart';
import 'package:flutter_demo/utils/text_util.dart';
import 'package:flutter_demo/utils/uuid_util.dart';
import 'package:flutter_demo/common/riki_unique_code.dart';

// import 'package:device_info/device_info.dart';
// import 'package:flutter_keychain/flutter_keychain.dart';
// import 'package:imei_plugin/riki_unique_code.dart';
// import 'package:riki_base_flutter/riki_base_flutter.dart';

class DeviceInfoHelper {
  static final DeviceInfoHelper _singleton = DeviceInfoHelper._internal();

  static final String ios_device_id_key = Md5Util.generateMd5('com.dabanjia.rikiuser');
  static final String _android_uuid_key = Md5Util.generateMd5('com.dabanjia.rikiuser');

  static const String error_code = '-1';

  factory DeviceInfoHelper() {
    return _singleton;
  }

  DeviceInfoHelper._internal();

  String _idfa = DeviceInfoHelper.error_code;

  String get idfa => _idfa;

  //安卓0  ios1  其他3
  String _os = Platform.isAndroid ? '0' : (Platform.isIOS ? '1' : '2');

  String get os => _os;

  String _uuid = DeviceInfoHelper.error_code;

  String get uuid => _uuid;

  String _imei = DeviceInfoHelper.error_code;

  String get imei => _imei;

  String _androidId = DeviceInfoHelper.error_code;

  String get androidId => _androidId;

  String _oaId = DeviceInfoHelper.error_code;

  String get oaId => _oaId;

  String _androidUuid = DeviceInfoHelper.error_code;

  String _getAndroidUuid() {
    String androidUuid = SpUtil.getString(_android_uuid_key, defValue: '');
    if (TextUtil.isEmpty(androidUuid)) {
      androidUuid = Md5Util.generateMd5(UuidUtil.instance.getUUid());
      SpUtil.putString(_android_uuid_key, androidUuid);
    }
    _androidUuid = androidUuid;
    return _androidUuid;
  }

  /// 获取iOS和Android的deviceID 32位
  Future<Map<String, String>> getUuidPacket() async {
    Completer<Map<String, String>> completer = Completer();
    Map<String, String> uuidPacket = {};
    List<Future<String>> futures = [];
    if (Platform.isAndroid) {
      futures.add(DeviceInfoHelper().getAndroidId());
      futures.add(DeviceInfoHelper().getAndroidIOAID());
      Future.wait<String>(futures).then((value) {
        if (value.length == 2) {
          uuidPacket['androidId'] = value[0];
          uuidPacket['oaid'] = value[1];
        }
        completer.complete(uuidPacket);
      });
    } else if (Platform.isIOS) {
      String deviceId = await DeviceInfoHelper().getIOSDeviceID();
      uuidPacket['deviceId'] = deviceId;
      completer.complete(uuidPacket);
    }
    return completer.future;
  }

  /// ios  idfa
  Future<void> getAdvertisingId() async {
    _idfa = (await RikiUniqueCode.getAdvertisingId())!;
  }

  Future<void> getMethodChannelTestStr() async {
    String _idfa = (await RikiUniqueCode.getMethodChannelTestStr())!;
    print('测试 methodchannel --- ${_idfa}');
  }

  /// android imei
  Future<String> getAndroidImei() async {
    String? imei = await RikiUniqueCode.getImei();
    if (TextUtil.isEmpty(imei)) {
      return error_code;
    }
    _imei = Md5Util.generateMd5(imei!);
    return _imei;
  }

  /// android Id
  Future<String> getAndroidId() async {
    String androidId = await RikiUniqueCode.getAndroidId();
    if (TextUtil.isEmpty(androidId)) {
      return error_code;
    }
    _androidId = Md5Util.generateMd5(androidId);
    return _androidId;
  }

  /// OAID
  Future<String> getAndroidIOAID() async {
    String? oaid = await RikiUniqueCode.getOAID();
    if (TextUtil.isEmpty(oaid)) {
      return error_code;
    }

    _oaId = oaId;
    return _oaId;
  }

  /// 设备ID
  Future<String> getIOSDeviceID() async {
    String? uuid = await FlutterKeychain.get(key: ios_device_id_key);
    if (TextUtil.isEmpty(uuid)) {
      _uuid = await _getUUID();
      FlutterKeychain.put(key: ios_device_id_key, value: _uuid);
      return _uuid;
    } else {
      _uuid = uuid!;
    }
    return _uuid;
  }

  /// 获取渠道名称
  Future<String> getChannelName() async {
    String? channelName = await RikiUniqueCode.getInstallChannelName();
    if (!TextUtil.isEmpty(channelName)) {
      return channelName!;
    }
    return '';
  }

  //获取iOS的UUID
  Future<String> _getUUID() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor.replaceAll('-', '');
  }

  static String getEquipmentId() {
    String equipmentId;
    if (Platform.isAndroid) {
      equipmentId = DeviceInfoHelper().imei;
      if (equipmentId == DeviceInfoHelper.error_code) {
        equipmentId = DeviceInfoHelper().androidId;
        if (equipmentId == DeviceInfoHelper.error_code) {
          equipmentId = DeviceInfoHelper().oaId;
          equipmentId = Md5Util.generateMd5(equipmentId);
        }
      }
    } else {
      equipmentId = DeviceInfoHelper().uuid;
    }
    return equipmentId;
  }

  /// 添加获取mqttClientId方法
  static String getMqttClientId() {
    String equipmentId;
    if (Platform.isAndroid) {
      equipmentId = DeviceInfoHelper().imei;
      if (equipmentId == DeviceInfoHelper.error_code) {
        equipmentId = DeviceInfoHelper().androidId;
        if (equipmentId == DeviceInfoHelper.error_code) {
          equipmentId = DeviceInfoHelper().oaId;
          if (TextUtil.isEmpty(equipmentId) || equipmentId == DeviceInfoHelper.error_code) {
            equipmentId = DeviceInfoHelper()._getAndroidUuid();
          } else {
            equipmentId = Md5Util.generateMd5(equipmentId);
          }
        }
      }
    } else {
      equipmentId = DeviceInfoHelper().uuid;
    }
    return equipmentId;
  }
}
