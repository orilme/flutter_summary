import 'package:flutter/material.dart';

/// InheritedWidget是 Flutter 中非常重要的一个功能型组件，
/// 它提供了一种在 widget 树中从上到下共享数据的方式，
/// 比如我们在应用的根 widget 中通过InheritedWidget共享了一个数据，那么我们便可以在任意子widget 中来获取该共享的数据

class InheritedPage extends StatefulWidget {
  @override
  _InheritedPageState createState() => _InheritedPageState();
}

class _InheritedPageState extends State<InheritedPage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inherited')),
      body: Center(
        child: ShareDataWidget(
          //使用ShareDataWidget
          data: count,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 300,
                color: Colors.red,
                padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                child: _TestWidget(), //子widget中依赖ShareDataWidget
              ),
              SizedBox(width: 20),
              Container(
                width: 300,
                color: Colors.green,
                padding: const EdgeInsets.all(20),
                child: TextWidget(num: count),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                child: Text("Increment"),
                //每点击一次，将count自增，然后重新build,ShareDataWidget的data将被更新
                onPressed: () => setState(() => ++count),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// InheritedWidget 传值
class ShareDataWidget extends InheritedWidget {
  ShareDataWidget({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final int data; //需要在子树中共享的数据，保存点击次数

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static ShareDataWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShareDataWidget>();
    //context.getElementForInheritedWidgetOfExactType<ShareDataWidget>().widget;
  }

  //该回调决定当data发生变化时，是否通知子树中依赖data的Widget
  @override
  bool updateShouldNotify(ShareDataWidget old) {
    return old.data != data;
  }
}

class _TestWidget extends StatefulWidget {
  @override
  __TestWidgetState createState() => __TestWidgetState();
}

class __TestWidgetState extends State<_TestWidget> {
  @override
  Widget build(BuildContext context) {
    print("InheritedWidget 传值---build");
    //使用InheritedWidget中的共享数据
    return Text(
      "InheritedWidget 传值: ${ShareDataWidget.of(context)!.data}",
      // "text",
      textAlign: TextAlign.center,
      textScaleFactor: 1.5,
      style: TextStyle(
          color: Colors.blue,
          fontSize: 15.0,
          height: 1.2,
          fontFamily: "Courier",
          background: Paint()..color = Colors.yellow,
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.dashed),
    );
  }

  /// StatefulWidget时，我们提到State对象有一个didChangeDependencies回调，
  /// 它会在“依赖”发生变化时被Flutter 框架调用。
  /// 而这个“依赖”指的就是子 widget 是否使用了父 widget 中InheritedWidget的数据！
  /// 如果使用了，则代表子 widget 有依赖；如果没有使用则代表没有依赖。
  /// 这种机制可以使子组件在所依赖的InheritedWidget变化时来更新自身！
  /// 比如当主题、locale(语言)等发生变化时，依赖其的子 widget 的didChangeDependencies方法将会被调用。
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // widget树中，若节点的父级结构中的层级 或 父级结构中的任一节点的widget类型有变化，节点会调用didChangeDependencies；
    // 若仅仅是父级结构某一节点的widget的某些属性值变化，节点不会调用didChangeDependencies
    // 父或祖先widget中的InheritedWidget改变(updateShouldNotify返回true)时会被调用。
    // 如果build中没有依赖InheritedWidget，则此回调不会被调用。
    print("InheritedWidget 传值---Dependencies change");
  }
}

/// num 传值
class TextWidget extends StatefulWidget {
  const TextWidget({Key? key, this.num = 0}) : super(key: key);

  final int num;
  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    print("num 传值---build");
    //使用InheritedWidget中的共享数据
    return Text(
      "num 传值: ${widget.num}",
      textAlign: TextAlign.center,
      textScaleFactor: 1.5,
      style: TextStyle(
          color: Colors.blue,
          fontSize: 15.0,
          height: 1.2,
          fontFamily: "Courier",
          background: Paint()..color = Colors.yellow,
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.dashed),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("num 传值---Dependencies change");
  }
}
