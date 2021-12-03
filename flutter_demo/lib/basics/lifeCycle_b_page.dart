import 'package:flutter/material.dart';

/// widget树中，若节点调用setState方法，节点本身不会触发didUpdateWidget，此节点的子节点 会 调用didUpdateWidget

class LifeCycleBPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LifeCycleBPageState();
}

class _LifeCycleBPageState extends State {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 100),
          LifeCycleB2Page(),
          Container(
            width: 100,
            height: 100,
            color: Colors.red,
            child: OutlinedButton(
              onPressed: () => _reload(),
              child: Text("setState"),
            ),
          )
        ],
      ),
    );
  }

  /// B1 State调用此方法后，[B1 State.didUpdateWidget]不会调用, [B2 State.didUpdateWidget]会调用
  void _reload() {
    print("setState---");
    setState(() {});
  }

  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("B1---didUpdateWidget");
  }
}

class LifeCycleB2Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LifeCycleB2PageState();
}

class _LifeCycleB2PageState extends State {
  @override
  Widget build(BuildContext context) {
    return Text("LifeCycleB2Page");
  }

  /// B1 State调用[B1 State.reload]后，[B1 State.didUpdateWidget]不会调用, [B2 State.didUpdateWidget]会调用
  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("B2---didUpdateWidget");
  }
}