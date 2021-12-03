import 'dart:io';
import 'package:flutter_demo/utils/device_info_util.dart';
import 'package:flutter_demo/utils/sp_util.dart';

// import 'package:fluwx/fluwx.dart';
// import 'package:mmkvflutter/mmkv.dart';
// import 'package:riki/config/config.dart';
// import 'package:riki/config/riki_dialog_setting.dart';
// import 'package:riki_base_flutter/riki_base_flutter.dart';

/// 各种插件等需要预初始化的

_AppPlugin appPlugin = _AppPlugin();

class _AppPlugin {
  ///========================= 全局对象 ====================================
  //final OneKeyLoginManager oneKeyLoginManager = OneKeyLoginManager();
  ///========================= 全局对象 ====================================

  /// 可用于初始化一些插件等
  Future init() async {
    print('AppPlugin---init');
    /// 初始化图片缓存器
    // ImageUtil.initCacheManager(CacheManager(Config(ImageUtil.key, maxNrOfCacheObjects: 200)));

    // await _initWx();

    if (Platform.isIOS) {
      await _initDeviceInfo();
      await _initIOSUUIDInfo();
      await _getMethodChannelTestStr();
      // print('测试 methodchannel --- ${_getMethodChannelTestStr()}');
      // print('测试 methodchannel --- ${_initDeviceInfo()}');
    } else {
      await DeviceInfoHelper().getAndroidImei();
      await DeviceInfoHelper().getAndroidId();
      await DeviceInfoHelper().getAndroidIOAID();
    }

    await _initSp();

    // await MMKV.initialize();

  //   //路由信息过滤器
  //   detectiveAgency.clueFilter = (routeInfo) {
  //     final String rn = routeInfo.routeName;
  //     return rn != loadingLayerRouteName &&
  //         rn != floatLayerRouteName &&
  //         rn != RikiDialogSetting.productSelectWidgetRouteName &&
  //         rn != RikiDialogSetting.shoppingTogetherDialog &&
  //         rn != RikiAlertDialog.name &&
  //         rn != RikiActionSheet.name;
  //   };
  }

  ///========================= 初始化区域 ====================================

  // ///初始化微信
  // Future _initWx() {
  //   return registerWxApi(appId: AppConfig.instance.wechatAppId, universalLink: AppConfig.instance.wechatUniversalLink);
  // }

  /// 初始化SpUtil
  Future _initSp() => SpUtil.getInstance();

  ///初始化设备信息
  Future _initDeviceInfo() => DeviceInfoHelper().getAdvertisingId();
  Future _initIOSUUIDInfo() => DeviceInfoHelper().getIOSDeviceID();
  /// 测试 methodchannel
  Future _getMethodChannelTestStr() => DeviceInfoHelper().getMethodChannelTestStr();

}
