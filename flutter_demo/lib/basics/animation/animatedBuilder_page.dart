import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBuilderPage extends StatefulWidget {
  _AnimatedBuilderPageState createState() => _AnimatedBuilderPageState();
}

class _AnimatedBuilderPageState extends State<AnimatedBuilderPage> with TickerProviderStateMixin {

  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    animationController = AnimationController(duration: Duration(seconds: 2), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });
    animation = Tween(begin: 0.0, end: 2.0 * pi).animate(animationController);
    //开始动画
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animation"),
        backgroundColor: Colors.blue,
      ),
      body: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            angle: animation.value,
            child: child,
          );
        },
        child: FlutterLogo(size: 60,),
      ),
    );
  }

}
