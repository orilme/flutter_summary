import 'package:flutter/material.dart';
import 'package:flutter_demo/index.dart';
import 'package:flutter_demo/basics/event_bus.dart';

class BasicPage extends StatefulWidget {
  @override
  _BasicPageState createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage> {

  final Map<String, Widget> pageMap = {
    'Map 使用': MapPage(),
    'FindRenderObject': FindRenderObjectPage(),

    'inherited': InheritedPage(),
    'ChangeNotifier': ChangeNotifierPage(),
    'basics.provider': ProviderPage(),
    'ProviderSelector': ProviderSelectorPage(),
    'StreamProvider': StreamProviderPage(),
    'Stream': StreamPage(),
    'StreamSubscription': StreamSubscriptionPage(),
    'EventBus': EventBusPage(),
    'Notification': NotificationPage(),
    'Builder和Notification': BuilderPage(),
    'CatchError': CatchErrorPage(),

    /// 自定义绘制
    'CanvasPage': CanvasPage(),
    '自定义绘制-Checkbox': CustomWidgetPage(),
    '自定义绘制-Circle': CustomCircularPage(),

    'Gesture/Listener/IgnorePointer/AbsorbPointer': GesturePage(),
    'Hero': HeroPage(),
    'Animation': AnimationPage(),
    'AnimatedBuilder': AnimatedBuilderPage(),
    'PositionedTransition': AnimationPositionedTransitionPage(),
    'SVGAPlayer': SVGAPlayerPage(),
    'Color': ColorPage(),
    'ColorTheme': ColorThemePage(),
    'LifeCycle': LifeCycleAPage(),
    'LifeCycle2': LifeCycleBPage(),
    'path_provider ': PathProviderPage(),
  };

  @override
  void dispose() {
    bus.off("login");
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("BasicPage---GesturePage---initState");
    bus.on("login", (arg) {
      print("BasicPage---GesturePage---bus---login---$arg");
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      // 设置滚动方向
      scrollDirection: Axis.vertical,
      // 设置列数
      crossAxisCount: 2,
      // 设置内边距
      padding: EdgeInsets.all(20),
      // 设置横向间距
      crossAxisSpacing: 15,
      // 设置主轴间距
      mainAxisSpacing: 10,
      // 宽高比
      childAspectRatio: 10 / 3,
      children: _addBtton(),
    );
  }

  List<Widget> _addBtton() {
    List<Widget> list = [];
    pageMap.forEach((key, value) {
      list.add(
        OutlineButton(
          child: Text("$key"),
          onPressed: () {
            _itemClick(value);
          },
        ),
      );
    });
    return list;
  }

  void _itemClick(Widget page) {
    Navigator.of(context).push(
        MaterialPageRoute(builder:(BuildContext context){
          return page;
        })
    );
  }
}