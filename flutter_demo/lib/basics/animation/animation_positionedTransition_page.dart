import 'package:flutter/material.dart';

class AnimationPositionedTransitionPage extends StatefulWidget {
  _AnimationPositionedTransitionPageState createState() => _AnimationPositionedTransitionPageState();
}

class _AnimationPositionedTransitionPageState extends State<AnimationPositionedTransitionPage> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<RelativeRect> _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    _animation = RelativeRectTween(
        begin: RelativeRect.fromLTRB(10.0, 10.0, 10.0, 10.0),
        end: RelativeRect.fromLTRB(100.0, 100.0, 100.0, 100.0))
        .animate(_animationController);

    //开始动画
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Border"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        height: 300,
        width: 300,
        color: Colors.blue,
        child: Stack(
          children: <Widget>[
            PositionedTransition(
              rect: _animation,
              child: Container(
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }

}