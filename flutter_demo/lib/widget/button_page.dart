import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ButtonPage extends StatefulWidget {
  @override
  _ButtonPageState createState() => _ButtonPageState();
}

class _ButtonPageState extends State<ButtonPage> {
  var _dropValue = '语文';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("button")),
        body: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(10), child: Text('DropdownButton \n 默认语文，未选中时, var _dropValue = null; 即可')),
              DropdownButton(
                value: _dropValue,
                items: [
                  DropdownMenuItem(child: Text('语文'),value: '语文'),
                  DropdownMenuItem(child: Text('数学'),value: '数学'),
                  DropdownMenuItem(child: Text('英语'),value: '英语'),
                ],
                onChanged: (value){
                  setState(() {
                    _dropValue = value.toString();
                  });
                },
              ),
              Padding(padding: EdgeInsets.all(10), child: Text('调整样式')),
              DropdownButton(
                selectedItemBuilder: (context){
                  return [
                    Text('语文',style: TextStyle(color: Colors.red),),
                    Text('数学',style: TextStyle(color: Colors.red),),
                    Text('英语',style: TextStyle(color: Colors.red),)
                  ];
                },
                value: _dropValue,
                items: [
                  DropdownMenuItem(child: Text('语文'),value: '语文'),
                  DropdownMenuItem(child: Text('数学'),value: '数学'),
                  DropdownMenuItem(child: Text('英语'),value: '英语'),
                ],
                onChanged: (value){
                  setState(() {
                    _dropValue = value.toString();
                  });
                },
              ),
              Padding(padding: EdgeInsets.all(10),
                  child: Text('RawMaterialButton \n '
                      'RawMaterialButton是基于Semantics, Material和InkWell创建的组件，它不使用当前的系统主题和按钮主题，用于自定义按钮或者合并现有的样式')
              ),
              RawMaterialButton(
                onPressed: (){},
                fillColor: Colors.blue,
                child: Text('RawMaterialButton'),
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
              Padding(padding: EdgeInsets.all(10), child: Text('CloseButton,BackButton - 如果路由栈有上一页则返回到上一页')),
              Row(
                children: [
                  CloseButton(),
                  BackButton(),
                ],
              ),
              Padding(padding: EdgeInsets.all(10), child: Text('CupertinoButton -- ios 风格按钮')),
              Row(
                children: [
                  CupertinoButton(
                    child: Text('ios 风格按钮'),
                    onPressed: (){},
                  ),
                  CupertinoButton(
                    child: Text('ios'),
                    onPressed: (){},
                    color: Colors.blue,
                    pressedOpacity: .8,
                  ),
                  CupertinoButton(
                    child: Text('ios'),
                    onPressed: (){},
                    color: Colors.blue,
                    pressedOpacity: .5,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}
