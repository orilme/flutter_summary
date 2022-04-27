import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:imei_plugin/riki_unique_code.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei = await RikiUniqueCode.getImei();
      List<String> multiImei = await RikiUniqueCode.getImeiMulti();
      print(multiImei);
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        floatingActionButton: FloatingActionButton(
          child: GestureDetector(
            child: Text('click'),
            onTap: click,
          ),
        ),
        body: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  String text = '';

  void click() async {
    StringBuffer stringBuffer = StringBuffer();

    String channlName =  await RikiUniqueCode.getInstallChannelName();


    List<String> IMEI = await RikiUniqueCode.getImeiMulti();
    stringBuffer.writeln('IMEI地址:' + (IMEI == null ? '' : IMEI.map((e) => e).toString()));
    stringBuffer.writeln('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ');
    String mac = await RikiUniqueCode.getMac();
    stringBuffer.writeln('mac地址:' + (mac ?? ''));
    stringBuffer.writeln('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ');
    String androidId = await RikiUniqueCode.getAndroidId();
    stringBuffer.writeln('androidId:' + (androidId ?? ''));
    stringBuffer.writeln('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ');
    String ipAddress = await RikiUniqueCode.getIpAddress();
    stringBuffer.writeln('ipAddress:' + (ipAddress ?? ''));
    stringBuffer.writeln('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ');
    String uaInfo = await RikiUniqueCode.getUaInfo();
    stringBuffer.writeln('uaInfo:' + (uaInfo ?? ''));
    stringBuffer.writeln('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ');
    String idfa = await RikiUniqueCode.getAdvertisingId();
    stringBuffer.writeln('idfa:' + idfa == null ? '' : idfa);
    stringBuffer.writeln('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ');
    String oaid = await RikiUniqueCode.getOAID();
    stringBuffer.writeln('oaid:' + (oaid ?? 'oaid'));
    stringBuffer.writeln('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ');

    text = stringBuffer.toString();
    if (mounted) setState(() {});
  }
}
