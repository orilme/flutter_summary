import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconPage extends StatefulWidget {
  @override
  _IconPageState createState() => _IconPageState();
}

class _IconPageState extends State<IconPage> {
  var _dropValue = '语文';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("button")),
        body: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(10), child: Text('Icon')),
              Icon(Icons.add),
              Padding(padding: EdgeInsets.all(10),
                  child: Text('建议大家多使用图标，不仅包体会小很多，而且图标都是矢量的，不存在失真的问题')
              ),
              Icon(
                Icons.add,
                size: 28,
                color: Colors.red,
              ),
              Padding(padding: EdgeInsets.all(10), child: Text('IconButton')),
              IconButton(
                icon: Icon(Icons.person),
                iconSize: 30,
                color: Colors.red,
                onPressed: () {},
              ),
              Padding(padding: EdgeInsets.all(10), child: Text('IconButton - 设置提示属性，当长按时显示提示')),
              IconButton(
                tooltip: '这是一个图标按钮',
                icon: Icon(Icons.person),
                iconSize: 30,
                color: Colors.red,
                onPressed: () {},
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('AssetImage \n AssetImage控件是根据图片绘制图标，就是图片上的透明通道不绘制，而不透明的地方使用设置的颜色绘制')),
              ImageIcon(
                AssetImage('assets/images/name.png'),
                size: 100,
                color: Colors.blue,
              )
            ],
          ),
        )
    );
  }
}
