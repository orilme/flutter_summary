import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PreferredSizePage extends StatefulWidget {
  @override
  _PreferredSizePageState createState() => _PreferredSizePageState();
}

class _PreferredSizePageState extends State<PreferredSizePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(200),
      //   child: Container(
      //     color: Colors.blue,
      //   ),
      // ),
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            height: 48,
            color: Colors.blue,
          ),
        ),
      ),
      body: Container(
        color: Colors.purple,
      ),
    );
  }
}
