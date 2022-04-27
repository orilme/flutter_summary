import 'package:flutter/material.dart';
import 'package:flutter_demo/base/utils/screen_util/flutter_screenutil.dart';
import 'package:flutter_demo/basic_page.dart';
import 'package:flutter_demo/basics/provider/provider_model.dart';
import 'package:flutter_demo/common/config.dart';
import 'package:flutter_demo/demo_page.dart';
import 'package:flutter_demo/route/flutter_demo_route.dart';
import 'package:flutter_demo/skill_page.dart';
import 'package:flutter_demo/widget_page.dart';
import 'package:provider/provider.dart';
import 'package:riki_project_config/riki_project_config.dart';
import 'package:riki_router/riki_router.dart';
import 'package:riki_router/route/riki_router_delegate.dart';

void main() {
  runMyApp();
}

void runMyApp() async {
  debugProfileBuildsEnabled = true;

  /*
   * Provider如果与Listenable/一起使用，现在抛出Stream。考虑使用ListenableProvider/ StreamProvider代替。
   * 或者，可以通过设置Provider.debugCheckInvalidValueType 为null这样来禁用此异常。
   */
  Provider.debugCheckInvalidValueType = null;

  /* 现象：不写下面这句报错 Unhandled Exception: Null check operator used on a null value
   * WidgetsFlutterBinding.ensureInitialized() 总体上来讲是把window提供的API分别封装到不同的Binding里。
   * GestureBinding 手势绑定、ServicesBinding 服务绑定、SchedulerBinding调度绑定、PaintingBinding 绘制绑定、
   * SemanticsBinding 辅助功能绑定、RendererBinding 渲染绑定、WidgetsBinding 组件绑定
   */
  WidgetsFlutterBinding.ensureInitialized();

  // await AppConfig.instance.init();
  // 提前初始化
  // await appPlugin.init();

  // 配置初始化
  RikiProjectConfig.initServer(
    envType: AppConfig.instance.envType,
    appType: RikiAppType.staff,
    log: AppConfig.is_debug,
  );

  // DoKit.runApp(
  //   app: DoKitApp(MyApp()),
  //   useInRelease: true,
  // );

  final CounterModel counter = CounterModel();
  final int textSize = 28;
  runApp(
    MultiProvider(
      providers: [Provider.value(value: textSize), ChangeNotifierProvider.value(value: counter)],
      child: MyApp(),
    ),
  );
}

// void runMyApp() async {
//   final CounterModel counter = CounterModel();
//   final int textSize = 28;
//
//   // DoKit.runApp(
//   //   app: DoKitApp(
//   //       MyApp()
//   //   ),
//   //   useInRelease: false,
//   // );
//
//   runApp(
//     MultiProvider(
//       providers: [
//         Provider.value(value: textSize),
//         ChangeNotifierProvider.value(value: counter)
//       ],
//       child: MyApp(),
//     ),
//   );
//
//   // runApp(
//   //   Provider<int>.value(
//   //     value: textSize,
//   //     child: ChangeNotifierProvider.value(
//   //       value: counter,
//   //       child: MyApp(),
//   //     ),
//   //   ),
//   // );
// }

GlobalKey<NavigatorState> globalKey = GlobalKey();

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key) {
    final RikiRouterDelegate _routerDelegate = RikiRouterDelegate(
      getRouteSettings: getRouteSettings,
      observers: [],
    );
    RikiRouter.instance.init(_routerDelegate);
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () {
        return MaterialApp.router(
          title: 'flutter demo',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          supportedLocales: [
            const Locale('zh', 'CN'),
            const Locale('en', 'US'),
          ],
          routeInformationParser: RikiRouter.instance.routeInformationParser,
          routerDelegate: RikiRouter.instance.routerDelegate,
        );
      },
      designSize: const Size(375, 667),
    );
  }
}

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       // debugShowCheckedModeBanner: false,
//       // showPerformanceOverlay: true,
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//       ),
//       home: ScreenUtilInit(
//         builder: () {
//           return BottomTabBarPage();
//         },
//         designSize: const Size(375, 667),
//       ),
//     );
//   }
// }

@RikiRoute(name: '/')
class BottomTabBarPage extends StatefulWidget {
  BottomTabBarPage({Key? key}) : super(key: key);

  @override
  _BottomTabBarPageState createState() => _BottomTabBarPageState();
}

class _BottomTabBarPageState extends State<BottomTabBarPage> {
  int _currentIndex = 0;
  List pages = [WidgetPage(), BasicPage(), DemoPage(), SkillPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter demo', style: TextStyle(letterSpacing: 4)),
        centerTitle: true,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'widget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'basic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inclusive_sharp),
            label: 'demo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.title),
            label: 'skill',
          )
        ],
        showUnselectedLabels: true,
        fixedColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
