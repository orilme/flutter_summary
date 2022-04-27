import 'package:flutter/material.dart';
import 'riki_base_api.dart';
// ignore: implementation_imports
import 'package:riki_project_config/src/riki_default_server.dart';

/// 获取小程序码的截图base64
class GetMPScreenShotApi extends RikiBaseApi<String> {
  GetMPScreenShotApi(BuildContext context) : super(context);

  @override
  String apiUrl() => RikiReleaseServer().apiUrl;

  @override
  HttpMethod get httpMethod => HttpMethod.get;

  @override
  String apiMethod(params) => 'app/applet/getWxacodeUnlimit';

  Map<String, dynamic> params(String page) => {'page': page};

  @override
  String? onExtractResult(resultData, HttpData<String> data) {
    return resultData;
  }
}
