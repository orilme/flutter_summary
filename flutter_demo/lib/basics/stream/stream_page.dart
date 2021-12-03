import 'package:flutter/material.dart';
import 'dart:async';

/// Stream 也是用于接收异步事件数据，和 Future 不同的是，它可以接收多个异步操作的结果（成功或失败）。
/// 也就是说，在执行异步任务时，可以通过多次触发成功或失败事件来传递结果数据或错误异常。
/// Stream 常用于会多次读取数据的异步任务场景，如网络内容下载、文件读写等

class StreamPage extends StatefulWidget {
  @override
  _StreamPageState createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  /// 流事件控制器
  // ignore: close_sinks
  StreamController<int> _streamController = StreamController(
      onListen: () {
        print("onListen");
      },
      onCancel: () {
        print("onCancel");
      }
  );
  late Stream _stream;
  late StreamSink _sink;
  int _count = 0;

  void _incrementCounter() {
    if (_count > 9) {
      _sink.close();
      return;
    }
    _count++;
    _sink.add(_count);
  }

  void _closeStream() {
    print('closeStream---');
    _streamController.close();
    _sink.close();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamController.close();
    _sink.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /// 流事件
    _stream = _streamController.stream;
    /// 事件入口
    _sink = _streamController.sink;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stream"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You have pushed the button this many times:'),
            SizedBox(height: 10),
            StreamBuilder(
              stream: _stream,
              initialData: _count,
              builder: (context , AsyncSnapshot snapshot) {
                // snapshot携带事件入口处闯进来的数据，用snapshot.data获取数据进行处理
                if(snapshot.connectionState == ConnectionState.done){
                  return Text('Done', style: TextStyle(fontSize: 14, color: Colors.blue));
                }
                int number = snapshot.data;
                return Text("$number", style: TextStyle(fontSize: 14, color: Colors.blue));
              },
            ),
            SizedBox(height: 100),
            OutlinedButton(
              child:  Icon(Icons.add),
              onPressed: ()=>_incrementCounter(),
            ),
            SizedBox(width: 20,),
            OutlinedButton(
              child:  Icon(Icons.close),
              onPressed: ()=>_closeStream(),
            ),
          ],
        ),
      ),
    );
  }
}