import 'package:flutter/material.dart';

class CatchErrorPage extends StatefulWidget {
  @override
  _CatchErrorPageState createState() => _CatchErrorPageState();
}

class _CatchErrorPageState extends State<CatchErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text("CatchError")),
        backgroundColor: Colors.black12,
        body: Builder(
          builder: (context) =>
              Center(
                child: Column(
                  children: [
                    RaisedButton(
                      color: Colors.pink,
                      textColor: Colors.white,
                      onPressed: () => _testCatchError(),
                      child: Text('CatchError'),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }

  _testCatchError() {
    try {
      _testFuture().then((value) {
        print('then---');
      }).catchError((e) {
        print('catchError---${e.toString()}');
      });
    } catch(e) {
      print('try-catch---${e.toString()}');
    }
  }

  /// try-catch---Exception: 123
  Future<bool> _testFuture() {
    throw Exception('123');
  }

  /// catchError---Exception: 123
  // Future<bool> _testFuture() async {
  //   throw Exception('123');
  // }
}
