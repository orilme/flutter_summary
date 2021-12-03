import 'package:flutter/material.dart';

class ListViewSeparatedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ListViewSeparatedPage"),
      ),
      body: ListView.separated(
        itemCount: 30,
        itemBuilder: (BuildContext context, int index) {
          String title = "哈哈哈";
          return ListTile(
            title: Text("$title"),
            onTap: () {
              _itemClick(index);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return index % 2 == 0 ? Divider(color: Colors.green) : Divider(color: Colors.blue);
        },
      ),
    );
  }

  void _itemClick(int index) {
    print("item click  $index");
  }

}