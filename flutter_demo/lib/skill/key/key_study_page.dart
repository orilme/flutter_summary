import 'package:flutter/material.dart';
import 'dart:math';

class KeyStudyPage extends StatefulWidget {
  @override
  _KeyStudyPageState createState() => _KeyStudyPageState();
}

class _KeyStudyPageState extends State<KeyStudyPage> {
  // List<Widget> widgets = [
  //   ColorContainer(),
  //   ColorContainer(),
  // ];

  List<Widget> widgets = [
    ColorContainer(key: UniqueKey(),),
    ColorContainer(key: UniqueKey(),),
  ];

  // List<Widget> widgets = [
  //   Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: ColorContainer(key: UniqueKey(),),
  //   ),
  //   Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: ColorContainer(key: UniqueKey(),),
  //   ),
  // ];

  // List<Widget> widgets = [
  //   Padding(
  //     key: UniqueKey(),
  //     padding: const EdgeInsets.all(8.0),
  //     child: ColorContainer(),
  //   ),
  //   Padding(
  //     key: UniqueKey(),
  //     padding: const EdgeInsets.all(8.0),
  //     child: ColorContainer(),
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Key 使用')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgets,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: switchWidget,
        child: Icon(Icons.undo),
      ),
    );
  }

  switchWidget(){
    widgets.insert(0, widgets.removeAt(1));
    setState(() {});
  }
}

class ColorContainer extends StatefulWidget {
  ColorContainer({Key? key}) : super(key: key);
  @override
  _ColorContainerState createState() => _ColorContainerState();
}

class _ColorContainerState extends State<ColorContainer> {
  final Color color = Utils.randomColor();
  @override
  Widget build(BuildContext context) {
    print("ColorContainer---build");
    return Container(
      width: 100,
      height: 100,
      color: color,
    );
  }
}

// class ColorContainer extends StatelessWidget {
//   final Color color = Utils.randomColor();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       height: 100,
//       color: color,
//     );
//   }
// }

class Utils {
  static Color randomColor() {
    var red = Random.secure().nextInt(255);
    var greed = Random.secure().nextInt(255);
    var blue = Random.secure().nextInt(255);
    return Color.fromARGB(255, red, greed, blue);
  }
}
