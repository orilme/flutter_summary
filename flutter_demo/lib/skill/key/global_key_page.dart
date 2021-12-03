import 'package:flutter/material.dart';
import 'dart:math';

class GlobalKeyPage extends StatefulWidget {
  @override
  _GlobalKeyPageState createState() => _GlobalKeyPageState();
}

class _GlobalKeyPageState extends State<GlobalKeyPage> {
  final GlobalKey<SwitcherScreenState> key = GlobalKey<SwitcherScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GlobalKey 使用')),
      body: SwitcherScreen(
        key: key,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        key.currentState?.changeState();
      }),
    );
  }

}

class SwitcherScreen extends StatefulWidget {
  SwitcherScreen({Key? key}) : super(key: key);

  @override
  SwitcherScreenState createState() => SwitcherScreenState();
}

class SwitcherScreenState extends State<SwitcherScreen> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Switch.adaptive(
            value: isActive,
            onChanged: (bool currentStatus) {
              isActive = currentStatus;
              setState(() {});
            }),
      ),
    );
  }

  changeState() {
    isActive = !isActive;
    setState(() {});
  }

}
