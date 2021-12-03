import 'package:flutter/material.dart';

/// Expanded、Flexible和Spacer都是具有权重属性的组件，可以控制Row、Column、Flex的子控件如何布局的控件。
/// Expanded的源代码
/*
class Expanded extends Flexible {
  /// Creates a widget that expands a child of a [Row], [Column], or [Flex]
  /// so that the child fills the available space along the flex widget's
  /// main axis.
  const Expanded({
    Key key,
    int flex = 1,
    @required Widget child,
  }) : super(key: key, flex: flex, fit: FlexFit.tight, child: child);
}
 */
/// Expanded继承字Flexible，fit参数固定为FlexFit.tight，也就是说Expanded必须（强制）填满剩余空间。
/// Spacer
/*
@override
Widget build(BuildContext context) {
  return Expanded(
    flex: flex,
    child: const SizedBox.shrink(),
  );
}
 */
/// Spacer的通过Expanded的实现的，和Expanded的区别是：Expanded可以设置子控件，而Spacer的子控件尺寸是0，因此Spacer适用于撑开Row、Column、Flex的子控件的空隙

/// 总结：
/// Spacer是通过Expanded来实现的，Expanded继承自Flexible。
/// 填满剩余空间直接使用Expanded更方便。
/// Spacer用于撑开Row、Column、Flex的子控件的空隙。

class FlexiblePage extends StatefulWidget {
  @override
  _FlexiblePageState createState() => _FlexiblePageState();
}

class _FlexiblePageState extends State<FlexiblePage> {
  Color _draggableColor = Colors.grey;

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SnackBar"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            /// Row中有3个子控件，2边的固定宽，中间的占满剩余的空间
            Row(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  height: 50,
                  width: 100,
                ),
                Flexible(
                    child: Container(
                      color: Colors.red,
                      height: 50,
                    )
                ),
                Container(
                  color: Colors.blue,
                  height: 50,
                  width: 100,
                ),
              ],
            ),
            SizedBox(height: 10),
            /// 和上面比，此时红色Container就不在充满空间
            Row(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  height: 50,
                  width: 100,
                ),
                Flexible(
                    child: Container(
                      color: Colors.red,
                      height: 50,
                      child: Text('Container',style: TextStyle(color: Colors.white),),
                    )
                ),
                Container(
                  color: Colors.blue,
                  height: 50,
                  width: 100,
                ),
              ],
            ),
            SizedBox(height: 10),
            /// 给Container添加对齐方式，此时红色 Container 又充满空间
            /// Container控件的大小是怎么调整的？Container默认是适配子控件大小的，但当设置对齐方式时Container将会填满父控件。
            Row(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  height: 50,
                  width: 100,
                ),
                Flexible(
                    child: Container(
                      color: Colors.red,
                      height: 50,
                      alignment: Alignment.center,
                      child: Text('Container',style: TextStyle(color: Colors.white),),
                    )
                ),
                Container(
                  color: Colors.blue,
                  height: 50,
                  width: 100,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: Text('1 Flex/ 6 Total',style: TextStyle(color: Colors.white),),
                    height: 50,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: Text('2 Flex/ 6 Total',style: TextStyle(color: Colors.white),),
                    height: 50,
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Container(
                    color: Colors.green,
                    alignment: Alignment.center,
                    child: Text('3 Flex/ 6 Total',style: TextStyle(color: Colors.white),),
                    height: 50,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  height: 50,
                  width: 100,
                ),
                Flexible(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text('OutlineButton'),
                  ),
                ),
                Container(
                  color: Colors.blue,
                  height: 50,
                  width: 100,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  height: 50,
                  width: 100,
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text('OutlineButton'),
                  ),
                ),
                Container(
                  color: Colors.blue,
                  height: 50,
                  width: 100,
                ),
              ],
            ),
            SizedBox(height: 70),
            Row(
              children: <Widget>[
                Container(width: 100,height: 50,color: Colors.green,),
                Spacer(flex: 2,),
                Container(width: 100,height: 50,color: Colors.blue,),
                Spacer(),
                Container(width: 100,height: 50,color: Colors.red,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
