import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:riki_http/riki_http.dart' as JvtdHttp;

///
/// 抓包代理
///
/// Created by Jack Zhang on 2/8/21 .
///
class FiddlerProxy {
  /// 设置代理
  /// [clientIp] 设备IP地址
  static void setFiddlerProxy(String clientIp) {
    /// Fiddler抓包代理配置 https://www.jianshu.com/p/d831b1f7c45b
    (JvtdHttp.dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.findProxy = (uri) {
        //proxy all request to localhost:8888
        return 'PROXY $clientIp:8888';
      };
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    };
  }
}
