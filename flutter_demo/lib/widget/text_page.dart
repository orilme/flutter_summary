import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class TextPage extends StatefulWidget {
  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  Color _draggableColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("text page"),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            children: [
              _richTextWid01(),
              _richTextWid02(),
              _richTextWid03(),
              _richTextWid04(),
              _richTextWid05(),
              Container(
                height: 30,
                color: Colors.red,
              ),

            //   TextPainter(
            //       text: TextSpan(
            //           text: 'TextDirection.ltr 文字默认居左',
            //           style: TextStyle(fontSize: 16.0, color: Colors.black)
            //       ),
            //       textDirection: TextDirection.ltr),
            //       ..layout(maxWidth: Screen.width, minWidth: Screen.width)
            //         ..paint(canvas, Offset(0.0, 0.0)
            // ),
            ],
          ),
        ),
        // body: SingleChildScrollView(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     crossAxisAlignment: CrossAxisAlignment.stretch,
        //     children: [
        //       _richTextWid01(),
        //       _richTextWid02(),
        //       _richTextWid03(),
        //       _richTextWid04(),
        //     ],
        //   ),
        // ),
    );
  }

  Widget _richTextWid01() {
    return RichText(
        text: TextSpan(
            text: 'TextDirection.ltr 文字默认居左',
            style: TextStyle(fontSize: 16.0, color: Colors.black)),
        textDirection: TextDirection.ltr);
  }

  Widget _richTextWid02() {
    return RichText(
        text: TextSpan(
            text: 'TextDirection.rtl 文字默认居右',
            style: TextStyle(fontSize: 16.0, color: Colors.black)),
        textDirection: TextDirection.rtl);
  }

  Widget _richTextWid03() {
    return RichText(
        text: TextSpan(
            text: 'textDirection 与 textAlign 同时设置，优先看整体，文字居中',
            style: TextStyle(fontSize: 16.0, color: Colors.black)),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center);
  }

  Widget _richTextWid04() {
    return RichText(
        text: TextSpan(
            text: '多种样式，如：',
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                  text: '红色',
                  style: TextStyle(fontSize: 18.0, color: Colors.red)),
              TextSpan(
                  text: '绿色',
                  style: TextStyle(fontSize: 18.0, color: Colors.green)),
              TextSpan(
                  text: '蓝色',
                  style: TextStyle(fontSize: 18.0, color: Colors.blue)),
              TextSpan(
                  text: '白色',
                  style: TextStyle(fontSize: 18.0, color: Colors.white)),
              TextSpan(
                  text: '紫色',
                  style: TextStyle(fontSize: 18.0, color: Colors.purple)),
              TextSpan(
                  text: '黑色',
                  style: TextStyle(fontSize: 18.0, color: Colors.black))
            ]),
        textAlign: TextAlign.center);
  }

  final TapGestureRecognizer recognizer = TapGestureRecognizer();
  void initState() {
    super.initState();
    recognizer.onTap = () {
      print("点击了-----");
    };
  }

  Widget _richTextWid05() {
    return RichText(
        text: TextSpan(
            text: 'recognizer 为手势识别者，可设置点击事件，',
            style: TextStyle(fontSize: 17.0, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                  text: '点我试试',
                  style: TextStyle(fontSize: 17.0, color: Colors.blue),
                  recognizer: recognizer)
            ]));
  }
}
