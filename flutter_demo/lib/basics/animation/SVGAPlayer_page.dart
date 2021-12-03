import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

class SVGAPlayerPage extends StatefulWidget {
  const SVGAPlayerPage({Key? key}) : super(key: key);

  @override
  _SVGAPlayerPageState createState() => _SVGAPlayerPageState();
}

class _SVGAPlayerPageState extends State<SVGAPlayerPage> with SingleTickerProviderStateMixin  {
  late SVGAAnimationController animationController;

  @override
  void initState() {
    this.animationController = SVGAAnimationController(vsync: this);
    this.loadAnimation();
    super.initState();
  }

  @override
  void dispose() {
    this.animationController.dispose();
    super.dispose();
  }


  void loadAnimation() async {
    final videoItem = await SVGAParser.shared.decodeFromAssets("assets/kingset.svga");//assets/angel.svga
    this.animationController.videoItem = videoItem;
    //使用位图替换指定元素。
    this.animationController.videoItem?.dynamicItem.setImageWithUrl("https://github.com/PonyCui/resources/blob/master/svga_replace_avatar.png?raw=true", "99");
    //隐藏指定元素。
    // this.animationController.videoItem?.dynamicItem.setHidden(true, "banner");
    //在指定元素上绘制文本。
    // this.animationController.videoItem?.dynamicItem.setText(
    //     TextPainter(
    //         text: TextSpan(
    //             text: "Hello, World!",
    //             style: TextStyle(
    //               fontSize: 28,
    //               color: Colors.yellow,
    //               fontWeight: FontWeight.bold,
    //             ))),
    //     "banner");
    // 在指定元素上自由绘制。
    // this.animationController.videoItem?.dynamicItem.setDynamicDrawer((canvas, frameIndex) {
    //   canvas.drawRect(Rect.fromLTWH(0, 0, 88, 88), Paint()..color = Colors.red); // draw by yourself.
    // }, "banner");
    this
        .animationController
        .repeat()
        .whenComplete(() => this.animationController.videoItem = null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 100),
        Container(
          color: Colors.grey,
          width: 200,
          height: 300,
          child: SVGAImage(this.animationController),
        ),
        Padding(padding: EdgeInsets.only(top: 2)),
        Container(
          color: Colors.green,
          width: 300,
          height: 300,
          child: SVGASimpleImage(assetsName: "assets/angel.svga"),
        ),
        Padding(padding: EdgeInsets.only(top: 2)),
        Container(
          color: Colors.green,
          width: 200,
          height: 200,
          child: Image.asset(
            'assets/images/head.jpg',
            fit: BoxFit.cover,
          ),
        )
      ],
    );
  }
}
