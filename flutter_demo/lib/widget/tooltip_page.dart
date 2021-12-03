import 'package:flutter/material.dart';

/*

 */

class TooltipPage extends StatefulWidget {
  @override
  _TooltipPageState createState() => _TooltipPageState();
}

class _TooltipPageState extends State<TooltipPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OverflowBox"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Tooltip(
            message: '这是提示',
            child: Icon(Icons.storage),
          ),
          SizedBox(height: 20),
          Tooltip(
            message: '这是提示',
            child: Text("哈哈哈"),
          ),
          SizedBox(height: 20),
          Tooltip(
            padding: EdgeInsets.all(2.0),
            margin: EdgeInsets.all(5.0),
            verticalOffset: 2,
            message: '这是提示',
            child: Icon(Icons.storage),
          ),
          SizedBox(height: 20),
          /// 设置样式及字体样式
          Tooltip(
            textStyle: TextStyle(color: Colors.blue),
            decoration: BoxDecoration(
                color: Colors.red
            ),
            message: '这是提示',
            child: Icon(Icons.storage),
          ),
          SizedBox(height: 20),
          /// 设置显示和等待时长
          Tooltip(
            waitDuration: Duration(seconds: 1),
            showDuration: Duration(seconds: 2),
            message: '这是提示',
            child: Icon(Icons.storage),
          ),
        ],
      ),
    );
  }
}
