import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StreamProviderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StreamProvider'),
      ),
      body: StreamWidget(),
    );
  }
}

class StreamWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<String>(
      create: (context) => Person().age,
      initialData: '数据初始化中...',
      catchError: (context,error)=>error.toString(),
      child: ChildWidget(),
    );
  }
}

class ChildWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('   ${Person().name}年龄:${context.watch<String>()}');
  }
}

class Person {
  Person({this.name = 'join', this.initialAge = 0});

  final String name;
  final int initialAge; // 默认值为null，注意下，要么给默认值，要么构造函数传递下，一定要在使用前赋值

  // 这里只是简单模拟Stream流，实际开发中，可以使用StreamControl进行控制流的输入和输出，详情参考上述链接
  Stream<String> get age async* {
    var i = initialAge;
    while (i < 85) {
      await Future.delayed(Duration(seconds: 1), () {
        i++;
      });
      yield i.toString();
    }
  }

}
