import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_demo/api/base_api.dart';
import 'package:flutter_demo/base/network/api/riki_base_api.dart';

class NetworkTestPage extends StatefulWidget {
  @override
  _NetworkTestPageState createState() => _NetworkTestPageState();
}

class _NetworkTestPageState extends State<NetworkTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("网络请求")),
      body: Center(
        child: OutlinedButton(
          child: Text('开始请求'),
          onPressed: () {
            print('object---');
            fetchDeviceIp();
          },
        ),
      ),
    );
  }

  void fetchDeviceIp() {
    final FetchUserDeviceInfoApi deviceInfoApi = FetchUserDeviceInfoApi(context);
    deviceInfoApi.start(params: {}).then((value) {
      if (value.success!) {
        String ip = value.result!['ipAddress'];
        print('网络请求成功---$ip');
      }
    });
  }
}

class FetchUserDeviceInfoApi extends BaseApi<Map<String, dynamic>> {
  FetchUserDeviceInfoApi(BuildContext context) : super(context);

  @override
  HttpMethod get httpMethod => HttpMethod.get;

  @override
  String apiMethod(params) {
    return 'app/common/open/deviceInfo';
  }

  @override
  FutureOr<Map<String, dynamic>> onExtractResult(resultData, HttpData<Map<String, dynamic>> data) {
    return resultData;
  }
}
