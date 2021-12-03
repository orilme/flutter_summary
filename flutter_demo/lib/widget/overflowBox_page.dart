import 'package:flutter/material.dart';

/*
OverflowBox，允许child超出parent的范围显示，当然不用这个控件，也有很多种方式实现类似的效果。
当OverflowBox的最大尺寸大于child的时候，child可以完整显示，
当其小于child的时候，则以最大尺寸为基准，当然，这个尺寸都是可以突破父节点的。。
当最小以及最大宽高度，如果为null的时候，就取父节点的constraint代替。
 */

class OverflowBoxPage extends StatefulWidget {
  @override
  _OverflowBoxPageState createState() => _OverflowBoxPageState();
}

class _OverflowBoxPageState extends State<OverflowBoxPage> {
  Color _draggableColor = Colors.grey;

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OverflowBox"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Container(
            color: Colors.green,
            width: 50.0,
            height: 50.0,
            padding: const EdgeInsets.all(5.0),
            child: OverflowBox(
              alignment: Alignment.topLeft,
              maxWidth:70.0,
              maxHeight: 100.0,
              child: Container(
                color: Color(0x33FF00FF),
                width: 100.0,
                height: 100.0,
              ),
            ),
          ),
          SizedBox(height: 100),
          Container(
            color: Colors.green,
            width: 50.0,
            height: 50.0,
            padding: const EdgeInsets.all(5.0),
            child: OverflowBox(
              alignment: Alignment.topLeft,
              maxWidth: 100.0,
              maxHeight: 100.0,
              child: Container(
                color: Color(0x33FF00FF),
                width: 100.0,
                height: 200.0,
              ),
            ),
          ),
          SizedBox(height: 100),
          Container(
            color: Colors.blue[50],
            /// SizedOverflowBox主要的布局行为有两点：
            /// 尺寸部分。通过将自身的固定尺寸，传递给child，来达到控制child尺寸的目的；
            /// 超出部分。可以突破父节点尺寸的限制，超出部分也可以被渲染显示，与OverflowBox类似。
            child: SizedOverflowBox(
              size: const Size(120.0, 100.0),
              alignment: AlignmentDirectional.bottomStart,
              child: Container(height: 50.0, width: 150.0, color: Colors.blue,),
            ),
          ),
        ],
      ),
    );
  }
}
