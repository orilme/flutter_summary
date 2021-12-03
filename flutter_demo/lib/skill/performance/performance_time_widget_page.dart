import 'package:flutter/material.dart';

class PerformanceTimeWidgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PerformanceTimeWidgetPage"),
      ),
      body: Container(
        color: Colors.tealAccent,
        child: Center(
          child: ListView(
            children: [
              for(var i=0;i<100000;i++) _buildItemWidget(i),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildItemWidget(int i) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12,horizontal: 18),
      child: Row(
        children: [
          Container(
            color: Colors.black,
            child: SizedBox(
              width: 30,
              height: 30,
              child: Center(
                child: Text(
                  '哈哈--${i}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(width: 10,),
          Expanded(child: Text(
            '哈哈--${i}',
            softWrap: false,
          ))
        ],
      ),
    );
  }
}
