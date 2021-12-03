import 'package:flutter/material.dart';

class FindRenderObjectPage extends StatefulWidget {
  @override
  _FindRenderObjectPageState createState() => _FindRenderObjectPageState();
}

/// GlobalKey 是 Flutter 提供的一种在整个 App 中引用 element 的机制。
/// 如果一个 widget 设置了GlobalKey，那么我们便可以通过 globalKey.currentWidget 获得该 widget 对象、
/// globalKey.currentElement来获得 widget 对应的element对象，
/// 如果当前 widget 是StatefulWidget，则可以通过 globalKey.currentState 来获得该 widget 对应的state对象。
/// 
/// 注意：使用 GlobalKey 开销较大，如果有其他可选方案，应尽量避免使用它。另外，同一个 GlobalKey 在整个 widget 树中必须是唯一的，不能重复。

class _FindRenderObjectPageState extends State<FindRenderObjectPage> {
  late GlobalKey globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FindRenderObjectPage'),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Center(
          child: GlobalText(key: globalKey),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("currentContext---${globalKey.currentContext?.findRenderObject()}");
          print("currentWidget---${globalKey.currentWidget}");
          print("currentState---${globalKey.currentState}");
        },
      ),
    );
  }
}

class GlobalText extends StatefulWidget {
  GlobalText({Key? key}) : super(key: key);
  @override
  _GlobalTextState createState() => _GlobalTextState();
}

class _GlobalTextState extends State<GlobalText> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Text("哈哈哈哈"),
    );
  }
}