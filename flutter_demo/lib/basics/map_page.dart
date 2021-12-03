import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('map 使用'),
      ),
      body: Column(
        children: [
          Text("map 使用"),
          Container(
            width: 300,
            height: 50,
            child: Row(
              children: <Widget>[
                Container(
                  color: Colors.red,
                ),
                Container(
                  color: Colors.blue,
                ),
                Container(
                  color: Colors.grey,
                ),
              ]
              .map<Widget>((Widget widget){
                return Expanded(
                  flex: 1,
                  child: widget,
                );
              }).toList(),
            ),
          ),
          Text("map 个别特殊使用"),
          Container(
            width: 300,
            height: 50,
            child: Row(
              children: <Widget>[
                Container(
                  key: Key('1'),
                  color: Colors.red,
                ),
                Container(
                  color: Colors.blue,
                ),
                Container(
                  color: Colors.grey,
                ),
              ]
              //.map((Widget widget){ 也是可以的
              .map<Widget>((Widget widget){
                print(widget.key);
                int flex = 1;
                if (widget.key == Key('1')) {
                  flex = 2;
                }
                return Expanded(
                  flex: flex,
                  child: widget,
                );
              }).toList(),
            ),
          ),
          Text("基础使用"),
          Container(
            width: 300,
            height: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}