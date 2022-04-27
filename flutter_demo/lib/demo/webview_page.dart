import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:riki_uikit/riki_uikit.dart';
// import 'package:riki_webview/riki_webview.dart';
// import 'package:riki_webview/entity/riki_webview_config.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Webview")),
        body: Center(
          child: Column(
            children: [
              RikiTextButton(
                onPressed: () {
                  print('跳转 webview-----');
                  // RikiWebView.instance.enter(
                  //   context!,
                  //   RikiWebViewConfig('http://news.baidu.com', statusBar: false, appBar: false),
                  // );
                },
                child: Text('跳转 webview'),
              ),
            ],
          ),
        ));
  }
}
