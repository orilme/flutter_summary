import 'package:flutter/material.dart';

class WarpPage extends StatefulWidget {
  @override
  _WarpPageState createState() => _WarpPageState();
}

class _WarpPageState extends State<WarpPage> {
  Color _draggableColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("warp page"),
          backgroundColor: Colors.blue,
        ),
        body: Wrap(
          spacing: 20.0, // 主轴(水平)方向间距
          runSpacing: 10.0, // 纵轴（垂直）方向间距
          alignment: WrapAlignment.center, //沿主轴方向居中
          children: <Widget>[
            Chip(
              avatar:
              CircleAvatar(backgroundColor: Colors.blue, child: Text('A')),
              label: Text('Hamilton'),
            ),
            Chip(
              avatar:
              CircleAvatar(backgroundColor: Colors.blue, child: Text('M')),
              label: Text('Lafayette'),
            ),
            Chip(
              avatar:
              CircleAvatar(backgroundColor: Colors.blue, child: Text('H')),
              label: Text('Mulligan'),
            ),
            Chip(
              avatar:
              CircleAvatar(backgroundColor: Colors.blue, child: Text('J')),
              label: Text('Laurens'),
            ),
          ],
        ));
  }
}
