import 'package:flutter/material.dart';

/*
Stack未定位的子组件大小由fit参数决定，默认值是StackFit.loose，表示子组件自己决定，StackFit.expand表示尽可能的大，用法如下：
Stack(
fit: StackFit.expand,
...
)
Stack未定位的子组件的默认左上角对齐，通过alignment参数控制，用法如下：
Stack(
  alignment: Alignment.center,
  ...
)
有没有注意到fit和alignment参数控制的都是未定位的子组件，那什么样的组件叫做定位的子组件？使用Positioned包裹的子组件就是定位的子组件，用法如下：
如果子组件超过Stack边界由overflow控制，默认是裁剪，用法 overflow: Overflow.visible,
 */

class StackPage extends StatefulWidget {
  @override
  _StackPageState createState() => _StackPageState();
}

class _StackPageState extends State<StackPage> {
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
            /// Stack组件可以将子组件叠加显示，根据子组件的顺利依次向上叠加
            Row(
              children: [
                Stack(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      color: Colors.red,
                    ),
                    Container(
                      height: 70,
                      width: 70,
                      color: Colors.blue,
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      color: Colors.yellow,
                    )
                  ],
                ),
                SizedBox(width: 10),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      color: Colors.red,
                    ),
                    Container(
                      height: 70,
                      width: 70,
                      color: Colors.blue,
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      color: Colors.yellow,
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            /// Positioned用于定位Stack子组件，Positioned必须是Stack的子组件
            /// Positioned提供便捷的构建方式，比如Positioned.fromRect、Positioned.fill等，
            /// 这些便捷的构建方式万变不离其宗，只不过换了一种方式设置top、bottom、left、right四种定位属性。
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      color: Colors.red,
                    ),
                    Positioned(
                      left: 20,
                      right: 10,
                      bottom: 10,
                      top: 10,
                      child: Container(
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
                SizedBox(width: 10),
                Stack(
                  clipBehavior: Clip.none, children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    color: Colors.red,
                  ),
                  Positioned(
                    left: 50,
                    top: 50,
                    height: 100,
                    width: 100,
                    child: Container(
                      color: Colors.green,
                    ),
                  )
                ],
                ),
              ],
            ),
            SizedBox(height: 70),
            /// IndexedStack是Stack的子类，Stack是将所有的子组件叠加显示，而IndexedStack只显示指定的子组件
            IndexedStack(
              index: _index,
              children: <Widget>[
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.fastfood,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.green,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.cake,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.yellow,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.local_cafe,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.fastfood),
                  onPressed: () {
                    setState(() {
                      _index = 0;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.cake),
                  onPressed: () {
                    setState(() {
                      _index = 1;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.local_cafe),
                  onPressed: () {
                    setState(() {
                      _index = 2;
                    });
                  },
                ),
              ],
            ),
            Stack(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.blue,
                ),
                /// PositionedDirectional用于定位Stack子组件，PositionedDirectional必须是Stack的子组件
                /// PositionedDirectional的textDirection（文本）方向为系统默认方向，不受Stack组件控制。
                /// PositionedDirectional实际上是Positioned.directional封装的
                PositionedDirectional(
                  start: 10,
                  end: 10,
                  top: 10,
                  bottom: 10,
                  child: Container(color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
