import 'package:flutter/material.dart';

/*
这么多约束类的容器组件，到底要使用哪一个组件呢？总结如下：
ConstrainedBox：适用于需要设置最大/小宽高，组件大小以来子组件大小，但不能超过设置的界限。
UnconstrainedBox：用到情况不多，当作ConstrainedBox的子组件可以“突破”ConstrainedBox的限制，超出界限的部分会被截取。
SizedBox：适用于固定宽高的情况，常用于当作2个组件之间间隙组件。
AspectRatio：适用于固定宽高比的情况。
FractionallySizedBox：适用于占父组件百分比的情况。
LimitedBox：适用于没有父组件约束的情况。
Container：适用于不仅有尺寸的约束，还有装饰（颜色、边框、等）、内外边距等需求的情况。
 */

class SizeBoxPage extends StatefulWidget {
  @override
  _SizeBoxPageState createState() => _SizeBoxPageState();
}

class _SizeBoxPageState extends State<SizeBoxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SizeBox"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 60, maxWidth: 200),
            child: Container(height: 300, width: 300, color: Colors.red),
          ),
          SizedBox(height: 20),
          /// AspectRatio组件是固定宽高比的组件
          Container(
            width: 200,
            child: AspectRatio(
              aspectRatio: 2 / 1,
              child: Container(color: Colors.red),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 400,
            height: 60,
            color: Colors.green,
            /// 使用FractionallySizedBox包裹子控件，设置widthFactor宽度系数或者heightFactor高度系数，系数值的范围是0-1，0.7表示占父组件的70%，用法如下
            child: FractionallySizedBox(
              alignment: Alignment.center, /// 通过alignment参数控制子组件显示的位置，默认为center
              widthFactor: .6,
              heightFactor: 0.8,
              child: OutlinedButton(
                onPressed: (){},
                child: Text('button'),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 400,
            height: 60,
            color: Colors.purple,
            /// 如果想让2个控件之间的间隔是当前父控件的10%，可以使用无子控件的FractionallySizedBox
            child: Row(
              children: <Widget>[
                Container(
                  width: 50,
                  color: Colors.red,
                ),
                Flexible(
                  child: FractionallySizedBox(
                    widthFactor: .1,
                  ),
                ),
                Container(
                  width: 50,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            color: Colors.red,
            height: 100,
            width: 100,
            /// LimitedBox组件是当不受父组件约束时限制它的尺寸。没有约束的父组件有ListView、Row、Column等。
            /// 如果LimitedBox的父组件受到约束，此时LimitedBox将会不做任何操作，我们可以认为没有这个组件。
            child: LimitedBox( /// LimitedBox没有起作用
              maxHeight: 50,
              maxWidth: 00,
              child: Container(color: Colors.green,),
            ),
          ),
          SizedBox(height: 20),
          Container(
            color: Colors.purple,
            width: 200,
            height: 100,
            child: ListView(
              children: <Widget>[
                Container( /// 你会发现什么也没有，因为在容器不受约束时，大小将会设置0
                  color: Colors.green,
                ),
                Container(
                  color: Colors.red,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            color: Colors.purple,
            width: 200,
            height: 100,
            child: ListView(
              children: <Widget>[
                LimitedBox( /// 相比上面有东西
                  maxHeight: 50,
                  child: Container(
                    color: Colors.green,
                  ),
                ),
                LimitedBox(
                  maxHeight: 50,
                  child: Container(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
