import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:riki_project_config/riki_project_config.dart';

import 'package:flutter_demo/base/utils/device_util.dart';
import 'package:flutter_demo/base/utils/get_ip_utils.dart';
import 'package:flutter_demo/base/utils/text_util.dart';

class HeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    Map<String, dynamic> headers = options.headers;
    String? accessToken = 'token';
    String? deviceInfoStr = DeviceUtil.deviceInfoStr;
    if (TextUtil.isEmpty(deviceInfoStr)) {
      deviceInfoStr = await DeviceUtil.getDeviceInfo();
    }
    var bytes = utf8.encode(deviceInfoStr!);
    String base64Str = base64Encode(bytes);
    if (!TextUtil.isEmpty(accessToken)) {
      headers['accessToken'] = accessToken;
    }
    if (!TextUtil.isEmpty(base64Str)) {
      headers['devInfo'] = base64Str;
    }
    String requestId = Uuid().v1().replaceAll('-', '');
    headers['traceId'] = requestId;

    // 获取ip网络地址
    // 判断接口是user并且是登录接口(验证码登录|密码登录)
    if (RikiProjectConfig.appType == RikiAppType.user && (options.path.contains('app/sms/checkCode') || options.path.contains('app/oauth/login'))) {
      String? ipv4 = await GetIpUtils.instance.getIpV4();
      headers['user_real_ip'] = ipv4;
    }
    return super.onRequest(options, handler);
  }
}
