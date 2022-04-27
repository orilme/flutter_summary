import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riki_uikit/riki_uikit.dart';

class UikitPage extends StatefulWidget {
  @override
  _UikitPageState createState() => _UikitPageState();
}

class _UikitPageState extends State<UikitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("uikit")),
        body: Center(
          child: Column(
            children: [
              RikiTextButton(
                onPressed: () {
                  print('点击初始化-----');
                },
                child: Text('初始化'),
              ),
            ],
          ),
        ));
  }
}
