import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
应用程序中通常会包含一些贯穿APP生命周期的变量信息，
这些信息在APP大多数地方可能都会被用到，比如当前用户信息、Local信息等。
在Flutter中我们把需要全局共享的信息分为两类：全局变量和共享状态。
全局变量就是单纯指会贯穿整个APP生命周期的变量，用于单纯的保存一些信息，或者封装一些全局工具和方法的对象。
而共享状态则是指哪些需要跨组件或跨路由共享的信息，这些信息通常也是全局变量，
而共享状态和全局变量的不同在于前者发生改变时需要通知所有使用该状态的组件，而后者不需要。
为此，我们将全局变量和共享状态分开单独管理。
*/

// 提供五套可选主题色
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

// class Global {
//   static SharedPreferences _prefs;
//   static Profile profile = Profile();
//   // 网络缓存对象
//   static NetCache netCache = NetCache();
//
//   // 可选的主题列表
//   static List<MaterialColor> get themes => _themes;
//
//   // 是否为release版
//   static bool get isRelease => bool.fromEnvironment("dart.vm.product");
//
//   //初始化全局信息，会在APP启动时执行
//   static Future init() async {
//     _prefs = await SharedPreferences.getInstance();
//     var _profile = _prefs.getString("profile");
//     if (_profile != null) {
//       try {
//         profile = Profile.fromJson(jsonDecode(_profile));
//       } catch (e) {
//         print(e);
//       }
//     }
//
//     // 如果没有缓存策略，设置默认缓存策略
//     profile.cache = profile.cache ?? CacheConfig()
//       ..enable = true
//       ..maxAge = 3600
//       ..maxCount = 100;
//
//     //初始化网络请求相关配置
//     Git.init();
//   }
//
//   // 持久化Profile信息
//   static saveProfile() =>
//       _prefs.setString("profile", jsonEncode(profile.toJson()));
// }