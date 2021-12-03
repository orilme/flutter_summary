import 'package:flutter/material.dart';

class AnimationPage extends StatefulWidget {
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Decoration> _animation;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(seconds: 2), vsync: this);

    _animation = DecorationTween(
      begin: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15)
      ),
      end: BoxDecoration(
        color: Colors.blue, 
          borderRadius: BorderRadius.circular(55)
      ),
    ).animate(_controller);

    //开始动画
    _controller.forward();

    /*动画事件监听器，
    它可以监听到动画的执行状态，
    我们这里只监听动画是否结束，
    如果结束则执行页面跳转动作。 */
    _animation.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        print("结束---");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animation"),
        backgroundColor: Colors.blue,
      ),
      body: DecoratedBoxTransition(
        decoration: _animation,
        child: Container(
          height: 100,
          width: 100,
        ),
      ),
    );
  }

}