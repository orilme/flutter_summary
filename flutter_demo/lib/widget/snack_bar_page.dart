import 'package:flutter/material.dart';

class SnackBarPage extends StatefulWidget {
  @override
  _SnackBarPageState createState() => _SnackBarPageState();
}

class _SnackBarPageState extends State<SnackBarPage> {
  Color _draggableColor = Colors.grey;

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
              ElevatedButton(
                child: Text("SnackBar"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('哈哈哈哈，SnackBar'),
                  ));
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text("自定义 SnackBar"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    content: Text('哈哈哈哈，自定义 SnackBar'),
                  ));
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text("自定义 SnackBar 2"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(
                      children: <Widget>[
                        Icon(Icons.check,color: Colors.green,),
                        Text('下载成功')],
                    ),
                    duration: Duration(seconds: 1),
                  ));
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text("SnackBar floating"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(
                      children: <Widget>[
                        Icon(Icons.check,color: Colors.green,),
                        Text('下载成功')],
                    ),
                    behavior: SnackBarBehavior.floating,
                  ));
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text("SnackBarAction"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    action: SnackBarAction(
                      label: '确定',
                      onPressed: () {
                        print('确定');
                      },
                    ),
                    content: Text('SnackBarAction'),
                  ));
                },
              ),
            ],
          ),
        ),
    );
  }
}
