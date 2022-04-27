import 'dart:async';
import 'package:dart_ipify/dart_ipify.dart';
import 'text_util.dart';

/// 备注：获取外网ip

class GetIpUtils {
  factory GetIpUtils() => _getInstance();

  GetIpUtils._internal();

  static GetIpUtils get instance => _getInstance();
  static GetIpUtils? _instance;

  static GetIpUtils _getInstance() {
    _instance ??= GetIpUtils._internal();
    return _instance!;
  }

  String? ipV4;

  Future<String?> getIpV4() {
    if (!TextUtil.isEmpty(ipV4)) return Future.value(ipV4);
    Completer<String?> ipV4Completer = Completer();
    Ipify.ipv4().then((value) {
      ipV4 = value;
      ipV4Completer.complete(value);
    }).catchError((error) {
      ipV4Completer.complete(null);
    }).timeout(Duration(seconds: 3), onTimeout: () {
      ipV4Completer.complete(null);
    });
    return ipV4Completer.future;
  }
}
