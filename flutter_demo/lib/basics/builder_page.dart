import 'package:flutter/material.dart';

class BuilderPage extends StatefulWidget {
  @override
  _BuilderPageState createState() => _BuilderPageState();
}

class _BuilderPageState extends State<BuilderPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text("Builder")),
        backgroundColor: Colors.black12,
        body: Builder(
          builder: (context) =>
            Center(
              child: Column(
                children: [
                  RaisedButton(
                    color: Colors.pink,
                    textColor: Colors.white,
                    onPressed: () => _displaySnackBar(context),
                    child: Text('Builder'),
                  ),
                  /// 下面报错：Scaffold.of() called with a context that does not contain a Scaffold.
                  // RaisedButton(
                  //   color: Colors.pink,
                  //   textColor: Colors.white,
                  //   onPressed: _displaySnackBar(context),
                  //   child: Text('show SnackBar'),
                  // ),
                  NotificationListener<CustomNotification>(
                    onNotification: (CustomNotification notification) {
                      print('Builder——NotificationListener---：${notification.value}');
                      return false;
                    },
                    child: Builder(
                      builder: (context) {
                        return RaisedButton(
                          child: Text('发送'),
                          onPressed: () {
                            CustomNotification('自定义事件').dispatch(context);
                          },
                        );
                      },
                    ),
                  ),
                  /// 下面点击按钮并不会分发事件
                  /// 因为没有Builder的context表示当前整个控件的context，其上并没有NotificationListener监听，
                  /// 而加上Builder后，context表示Builder控件，其上有NotificationListener监听
                  NotificationListener<CustomNotification>(
                    onNotification: (CustomNotification notification) {
                      print('Builder——NotificationListener---2---：${notification.value}');
                      return false;
                    },
                    child: RaisedButton(
                      child: Text('发送2'),
                      onPressed: () {
                        CustomNotification('自定义事件2').dispatch(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('builder'));
    Scaffold.of(context).showSnackBar(snackBar);
  }

}

class CustomNotification extends Notification {
  CustomNotification(this.value);
  final String value;
}

