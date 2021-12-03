import 'package:flutter/material.dart';
import 'package:flutter_demo/index.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {

  final Map<String, Widget> pageMap = {
    'Menu': MenuPage(),
    'flutter_slidable': SlidablePage(),
    'ScrollAnimationTo': ScrollAnimationToPage(),
    'scroll_to_index': ScrollToIndexPage(),
    'audioplayers': AudioplayersPage(),
    'flustars': FlustarsPage(),
    '二维码': QrCodePage(),
    '相册选择照片': ImagePickerPage(),
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      // 设置滚动方向
      scrollDirection: Axis.vertical,
      // 设置列数
      crossAxisCount: 2,
      // 设置内边距
      padding: EdgeInsets.all(20),
      // 设置横向间距
      crossAxisSpacing: 15,
      // 设置主轴间距
      mainAxisSpacing: 10,
      // 宽高比
      childAspectRatio: 10 / 3,
      children: _addBtton(),
    );
  }

  List<Widget> _addBtton() {
    List<Widget> list = [];
    pageMap.forEach((key, value) {
      list.add(
        OutlineButton(
          child: Text("$key"),
          onPressed: () {
            _itemClick(value);
          },
        ),
      );
    });
    return list;
  }

  void _itemClick(Widget page) {
    Navigator.of(context).push(
        MaterialPageRoute(builder:(BuildContext context){
          return page;
        })
    );
  }
}