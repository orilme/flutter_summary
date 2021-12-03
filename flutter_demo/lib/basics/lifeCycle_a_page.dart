import 'package:flutter/material.dart';

/// 生命周期 - didChangeDependencies
/// widget树中，若节点的父级结构中的层级 或 父级结构中的任一节点的widget类型有变化，节点会调用didChangeDependencies；
/// 若仅仅是父级结构某一节点的widget的某些属性值变化，节点不会调用didChangeDependencies

class LifeCycleAPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LifeCycleAPageState();
}

class _LifeCycleAPageState extends State<LifeCycleAPage> {
  bool bDependenciesShouldChange = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      bDependenciesShouldChange = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    /// A2`父级结构中的层级`发生变化时(`Scaffold`、`Container`、`A3`、`A2` => `Scaffold`、`Container`、`A3`、`SizedBox`、`A2`)， A2会执行didChangeDependencies
    return bDependenciesShouldChange
        ? Scaffold(
        body: Container(
          height: 500,
          alignment: Alignment.centerLeft,
          child: LifeCycleA3Page(child: LifeCycleA2Page()),
        ))
        : Scaffold(
        body: Container(
          height: 400,
          alignment: Alignment.centerLeft,
          child: LifeCycleA3Page(child: SizedBox(width: 20, height: 50, child: LifeCycleA2Page())),
        ));

    /// A2`父级结构中的任一节点的widget类型`发生变化时(`Container` => `Center`)， A2 会执行didChangeDependencies
    // return bDependenciesShouldChange
    //     ? Scaffold(body: Center(child: LifeCycleA3Page(child: LifeCycleA2Page())))
    //     : Scaffold(
    //         body: Container(
    //         height: 500,
    //         alignment: Alignment.centerLeft,
    //         child: LifeCycleA3Page(child: LifeCycleA2Page()),
    //       ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("LifeCycleAPage --- didChangeDependencies");
  }
}

class LifeCycleA2Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LifeCycleA2PageState();
}

class _LifeCycleA2PageState extends State<LifeCycleA2Page> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("LifeCycleA2Page"));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("LifeCycleA2Page---didChangeDependencies");
  }
}

class LifeCycleA3Page extends StatefulWidget {
  final Widget child;
  LifeCycleA3Page({Key? key, required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LifeCycleA3PageState();
}

class _LifeCycleA3PageState extends State<LifeCycleA3Page> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("LifeCycleA3Page --- didChangeDependencies");
  }
}