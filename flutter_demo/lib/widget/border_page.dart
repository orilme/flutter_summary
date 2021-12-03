import 'package:flutter/material.dart';

class BorderPage extends StatefulWidget {
  @override
  _BorderPageState createState() => _BorderPageState();
}

class _BorderPageState extends State<BorderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Border"),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            children: [
              RaisedButton(
                shape: BeveledRectangleBorder(
                    side: BorderSide(width: 1, color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                child: Text('ShapeBorder'),
                onPressed: () {},
              ),
              SizedBox(height: 10),
              RaisedButton(
                shape: BeveledRectangleBorder(
                    side: BorderSide(width: 1, color: Colors.red),
                    borderRadius: BorderRadius.circular(100)),
                child: Text('ShapeBorder'),
                onPressed: () {},
              ),
              SizedBox(height: 10),
              RaisedButton(
                shape: BeveledRectangleBorder(
                    side: BorderSide(width: 1, color: Colors.red),
                    borderRadius: BorderRadius.circular(0)),
                child: Text('ShapeBorder'),
                onPressed: () {},
              ),
              SizedBox(height: 10),
              RaisedButton(
                shape: Border(
                    top: BorderSide(color: Colors.red, width: 2)
                ),
                child: Text('单边 Border'),
                onPressed: () {},
              ),
              SizedBox(height: 10),
              RaisedButton(
                shape: Border(
                  top: BorderSide(color: Colors.red,width: 10),
                  right: BorderSide(color: Colors.blue,width: 10),
                  bottom: BorderSide(color: Colors.yellow,width: 10),
                  left: BorderSide(color: Colors.green,width: 10),
                ),
                child: Text('Border'),
                onPressed: () {},
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 10),
                  RaisedButton(
                    /// BorderDirectional和Border基本一样，区别就是BorderDirectional带有阅读方向，大部分国家阅读是从左到右，但有的国家是从右到左的，比如阿拉伯等。
                    shape: BorderDirectional(
                      start: BorderSide(color: Colors.red,width: 2),
                      end: BorderSide(color: Colors.blue,width: 2),
                    ),
                    child: Text('中国'),
                    onPressed: () {},
                  ),
                  SizedBox(width: 10),
                  RaisedButton(
                    /// BorderDirectional和Border基本一样，区别就是BorderDirectional带有阅读方向，大部分国家阅读是从左到右，但有的国家是从右到左的，比如阿拉伯等。
                    shape: BorderDirectional(
                      start: BorderSide(color: Colors.red,width: 2),
                      end: BorderSide(color: Colors.blue,width: 2),
                    ),
                    child: Text('123'),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 10),
              RaisedButton(
                shape: CircleBorder(side: BorderSide(color: Colors.red)),
                child: Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  child: Text('CircleBorder'),
                ),
                onPressed: () {},
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 10),
                  RaisedButton(
                    shape: ContinuousRectangleBorder(
                        side: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text('平滑'),
                    onPressed: () {},
                  ),
                  SizedBox(width: 10),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('圆角矩形'),
                    onPressed: () {},
                  ),
                  SizedBox(width: 10),
                  RaisedButton(
                    shape: StadiumBorder(
                      side: BorderSide(color: Colors.red),),
                    child: Text('哈哈'),
                    onPressed: () {},
                  ),
                  SizedBox(width: 10),
                  RaisedButton(
                    shape: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('OutlineInput'),
                    onPressed: () {},
                  )
                ],
              ),
              SizedBox(height: 10),
              RaisedButton(
                shape: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                child: Text('UnderlineInputBorder'),
                onPressed: () {},
              ),
            ],
          ),
        )
    );
  }
}
