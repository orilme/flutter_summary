import 'package:flutter/material.dart';

class PerformanceListOnePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PerformanceListOnePage"),
      ),
      body: ListView.separated(
        itemCount: 100,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: index % 2 == 0 ? Colors.white : Colors.grey,
            child: Row(
               children: [
                 FlatButton(
                   textColor: Colors.blueGrey,
                   color: Colors.blue,
                   child: Text('哈哈1'),
                   onPressed:() => print('click'),
                 ),
                 FlatButton(
                   textColor: Colors.blueGrey,
                   color: Colors.blue,
                   child: Text('哈哈2'),
                   onPressed:() => print('click'),
                 ),
                 FlatButton(
                   textColor: Colors.blueGrey,
                   color: Colors.blue,
                   child: Text('哈哈3'),
                   onPressed:() => print('click'),
                 ),
               ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return index % 2 == 0 ? Divider(color: Colors.green) : Divider(color: Colors.blue);
        },
      ),
    );
  }
}