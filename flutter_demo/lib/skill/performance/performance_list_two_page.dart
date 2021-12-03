import 'package:flutter/material.dart';

class PerformanceListTwoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PerformanceListTwoPage"),
      ),
      body: ListView.separated(
        itemCount: 100,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: index % 2 == 0 ? Colors.white : Colors.grey,
            child: Row(
              children: [
                btnWidget('哈哈1'),
                btnWidget('哈哈2'),
                btnWidget('哈哈3'),
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

  Widget btnWidget(String text) {
    return GestureDetector(
      onTap: () => print('click'),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: Colors.blue,
        child: Text(text, style: TextStyle(color: Colors.blueGrey),),
      ),
    );
  }
}