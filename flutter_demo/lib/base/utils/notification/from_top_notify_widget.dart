import 'package:flutter/material.dart';

typedef NotifyDone = void Function(bool notifyDone);

/// 通知显示类型的widget（包裹层） 建议都在这个文件夹下创建

class FromTopNotifyWidget extends StatefulWidget {
  final Widget child;

  ///通知滑出所需时间
  final Duration animationDuration;

  ///通知停滞时间
  final Duration notifyDwellTime;

  ///通知结束
  final NotifyDone notifyDone;

  FromTopNotifyWidget(
    this.child,
    this.animationDuration,
    this.notifyDwellTime,
    this.notifyDone, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FromTopNotifyWidgetState();
  }
}

class FromTopNotifyWidgetState extends State<FromTopNotifyWidget> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.animationDuration);
    animation = Tween<Offset>(begin: Offset(0, -1), end: Offset.zero).animate(controller!);
    controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(widget.notifyDwellTime).whenComplete(() => controller?.reverse().whenComplete(() => widget.notifyDone(true)));
      }
    });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      controller!.forward();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: animation,
          builder: (ctx, c) {
            return SlideTransition(
              position: animation as Animation<Offset>,
              child: widget.child,
            );
          },
        )
      ],
    );
  }
}
