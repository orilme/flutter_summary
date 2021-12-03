import 'package:flutter/material.dart';

/// 通知（Notification）是Flutter中一个重要的机制，在widget树中，每一个节点都可以分发通知，
/// 通知会沿着当前节点向上传递，所有父节点都可以通过NotificationListener来监听通知。
/// Flutter中将这种由子向父的传递通知的机制称为通知冒泡（Notification Bubbling）。
/// 通知冒泡和用户触摸事件冒泡是相似的，但有一点不同：通知冒泡可以中止，但用户触摸事件不行。

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification 使用'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _onNotification,
        child: ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
              return ListTile(title: Text("$index"),);
            }
        ),
      ),
    );
  }

  bool _onNotification(ScrollNotification notification) {
    switch (notification.runtimeType) {
      case ScrollStartNotification: print("开始滚动"); break;
      case ScrollUpdateNotification: print("正在滚动"); break;
      case ScrollEndNotification: print("滚动停止"); break;
      case OverscrollNotification: print("滚动到边界"); break;
    }
    /// 子NotificationListener的onNotification回调返回了false，表示不阻止冒泡，所以父NotificationListener仍然会受到通知，所以控制台会打印出通知信息；
    /// 如果将子NotificationListener的onNotification回调的返回值改为true，则父NotificationListener便不会再打印通知了，因为子NotificationListener已经终止通知冒泡了。
    return false;
  }
}