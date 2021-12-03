import 'package:flutter/material.dart';
import 'package:flutter_demo/basics/color_nav.dart';

class ColorPage extends StatefulWidget {
  const ColorPage({Key? key}) : super(key: key);

  @override
  _ColorPageState createState() => _ColorPageState();
}

class _ColorPageState extends State<ColorPage> {
  var c = "dc380d";
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text("Color")),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 2)),
              Container(
                height: 50,
                color: Colors.red,
              ),
              Padding(padding: EdgeInsets.only(top: 2)),
              Container(
                height: 50,
                color: Color(0xffdc380d),
              ),
              Padding(padding: EdgeInsets.only(top: 2)),
              Container(
                height: 50,
                color: Color(int.parse(c,radix:16)|0xFF000000),
              ),
              Padding(padding: EdgeInsets.only(top: 2)),
              Container(
                height: 50,
                color: Color(int.parse(c,radix:16)).withAlpha(255),
              ),
              Padding(padding: EdgeInsets.only(top: 2)),
              Container(
                height: 50,
                color: Colors.blue.shade50,
              ),
              Padding(padding: EdgeInsets.only(top: 2)),
              Container(
                height: 50,
                color: Colors.blue.shade100,
              ),
              Padding(padding: EdgeInsets.only(top: 2)),
              Container(
                height: 50,
                color: Colors.blue.shade200,
              ),
              Padding(padding: EdgeInsets.only(top: 2)),
              Container(
                height: 50,
                color: Colors.blue.shade500,
              ),
              Padding(padding: EdgeInsets.only(top: 2)),
              NavBar(color: Colors.blue, title: "标题"),
              Padding(padding: EdgeInsets.only(top: 2)),
              NavBar(color: Colors.white, title: "标题"),
            ],
          ),
        ),
      ),
    );
  }
}