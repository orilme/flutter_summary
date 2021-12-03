import 'package:flutter/material.dart';
import 'package:flutter_demo/basics/event_bus.dart';

/// 事件总线通常用于组件之间状态共享
/// 事件总线通常实现了订阅者模式，订阅者模式包含发布者和订阅者两种角色，可以通过事件总线来触发事件和监听事件。

class EventBusPage extends StatefulWidget {
  const EventBusPage({Key? key}) : super(key: key);

  @override
  _EventBusPageState createState() => _EventBusPageState();
}

class _EventBusPageState extends State<EventBusPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text("event bus")),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  bus.emit("login", "哈哈哈 event bus");
                },
                child: Text('测试 event bus'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}