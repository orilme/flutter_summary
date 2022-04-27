import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_demo/index.dart';
import 'package:flutter_demo/basics/event_bus.dart';
import 'package:riki_router/riki_router.dart';

/// GestureDetector 嵌套只会执行最上层的 widget
/// Listener 嵌套只会执行最上层的 widget
/// Listener 的behavior: HitTestBehavior.opaque, 只会执行最上层
/// Listener behavior: HitTestBehavior.translucent, 会透传，同时执行
///

/// GestureDetector是一个用于手势识别的功能性组件。GestureDetector 内部封装了 Listener，用以识别语义化的手势。
/// GestureDetector内部是使用一个或多个GestureRecognizer来识别各种手势的，
/// 而GestureRecognizer的作用就是通过Listener来将原始指针事件转换为语义手势，GestureDetector直接可以接收一个子widget。
/// GestureRecognizer是一个抽象类，一种手势的识别器对应一个GestureRecognizer的子类。
/// 注意：使用GestureRecognizer后一定要调用其dispose()方法来释放资源（主要是取消内部的计时器）。

/// Flutter 事件处理流程
/// 命中测试 -> 事件分发 -> 事件清理

/// 命中测试
/// hitTestChildren() 功能是判断是否有子节点通过了命中测试，如果有，则会将子组件添加到 HitTestResult 中同时返回 true；如果没有则直接返回false。该方法中会递归调用子组件的 hitTest 方法。
/// hitTestSelf() 决定自身是否通过命中测试，如果节点需要确保自身一定能响应事件可以重写此函数并返回true ，相当于“强行声明”自己通过了命中测试。
/// 整体逻辑就是：
/// 先判断事件的触发位置是否位于组件范围内，如果不是则不会通过命中测试，此时 hitTest 返回 false，如果是则到第二步。
/// 会先调用 hitTestChildren() 判断是否有子节点通过命中测试，如果是，则将当前节点添加到 HitTestResult 列表，此时 hitTest 返回 true。即只要有子节点通过了命中测试，那么它的父节点（当前节点）也会通过命中测试。
/// 如果没有子节点通过命中测试，则会取 hitTestSelf 方法的返回值，如果返回值为 true，则当前节点通过命中测试，反之则否。
///
/// 如果当前节点有子节点通过了命中测试或者当前节点自己通过了命中测试，则将当前节点添加到 HitTestResult 中。
/// 又因为 hitTestChildren()中会递归调用子组件的 hitTest 方法，所以组件树的命中测试顺序深度优先的，
/// 即如果通过命中测试，子组件会比父组件会先被加入HitTestResult 中。
///
///
/// 为什么要制定这个中断呢？
/// 因为一般情况下兄弟节点占用的布局空间是不重合的，因此当用户点击的坐标位置只会有一个节点，
/// 所以一旦找到它后（通过了命中测试，hitTest 返回true），就没有必要再判断其它兄弟节点了。
/// 但是也有例外情况，比如在 Stack 布局中，兄弟组件的布局空间会重叠，如果我们想让位于底部的组件也能响应事件，
/// 就得有一种机制，能让我们确保：即使找到了一个节点，也不应该终止遍历，也就是说所有的子组件的 hitTest 方法都必须返回 false！
/// 为此，Flutter 中通过 HitTestBehavior 来定制这个过程，这个我们会在本节后面介绍。
///
/// 为什么兄弟节点的遍历要倒序？
/// 同 1 中所述，兄弟节点一般不会重叠，而一旦发生重叠的话，往往是后面的组件会在前面组件之上，点击时应该是后面的组件会响应事件，
/// 而前面被遮住的组件不能响应，所以命中测试应该优先对后面的节点进行测试，因为一旦通过测试，就不会再继续遍历了。
/// 如果我们按照正向遍历，则会出现被遮住的组件能响应事件，而位于上面的组件反而不能，这明显不符合预期。
///
///
/// 忽略指针事件
/// 假如我们不想让某个子树响应PointerEvent的话，我们可以使用IgnorePointer和AbsorbPointer，
/// 这两个组件都能阻止子树接收指针事件，不同之处在于AbsorbPointer本身会参与命中测试，而IgnorePointer本身不会参与，
/// 这就意味着AbsorbPointer本身是可以接收指针事件的(但其子树不行)，而IgnorePointer不可以
///
/// 我们回到 hitTestChildren 上，如果不重写 hitTestChildren，则默认直接返回 false，这也就意味着后代节点将无法参与命中测试，相当于事件被拦截了，
/// 这也正是 IgnorePointer 和 AbsorbPointer 可以拦截事件下发的原理。
///
/// 如果 hitTestSelf 返回 true，则无论子节点中是否有通过命中测试的节点，当前节点自身都会被添加到 HitTestResult 中。
/// 而 IgnorePointer 和 AbsorbPointer 的区别就是，前者的 hitTestSelf 返回了 false，而后者返回了 true。

/// 命中测试是在 PointerDownEvent 事件触发时进行的，一个完成的事件流是 down > move > up (cancle)。
/// 如果父子组件都监听了同一个事件，则子组件会比父组件先响应事件。
/// 这是因为命中测试过程是按照深度优先规则遍历的，所以子渲染对象会比父渲染对象先加入 HitTestResult 列表，
/// 又因为在事件分发时是从前到后遍历 HitTestResult 列表的，所以子组件比父组件会更先被调用 handleEvent 。

/*
      //在命中测试过程中 Listener 组件如何表现。
      enum HitTestBehavior {
      // 组件是否通过命中测试取决于子组件是否通过命中测试
      deferToChild,
      // 组件必然会通过命中测试，同时其 hitTest 返回值始终为 true
      opaque,
      // 组件必然会通过命中测试，但其 hitTest 返回值可能为 true 也可能为 false
      translucent,
      }
     */
/// hitTest 实现来分析一下不同取值的作用：
/// behavior 为 deferToChild 时，hitTestSelf 返回 false，当前组件是否能通过命中测试完全取决于 hitTestChildren 的返回值。
/// 也就是说只要有一个子节点通过命中测试，则当前组件便会通过命中测试。

/// behavior 为 opaque 时，hitTestSelf 返回 true，hitTarget 值始终为 true，当前组件通过命中测试。

/// behavior 为 translucent 时，hitTestSelf 返回 false，hitTarget 值此时取决于 hitTestChildren 的返回值，
/// 但是无论 hitTarget 值是什么，当前节点都会被添加到 HitTestResult 中。

/// 注意，behavior 为 opaque 和 translucent 时当前组件都会通过命中测试，
/// 它们的区别是 hitTest() 的返回值（hitTarget ）可能不同，所以它们的区别就看 hitTest() 的返回值会影响什么

class GesturePage extends StatefulWidget {
  const GesturePage({Key? key}) : super(key: key);

  @override
  _GesturePageState createState() => _GesturePageState();
}

class _GesturePageState extends State<GesturePage> {
  String _operation = "No Gesture detected!"; //保存事件名

  TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();
  bool _toggle = false; //变色开关

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text("Gesture")),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(10), child: Text("手势 - GestureDetector")),
              Row(
                children: [
                  SizedBox(width: 20),
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.blue,
                      width: 150.0,
                      height: 80.0,
                      child: Text(
                        _operation,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () => updateText("Tap"), //点击
                    onDoubleTap: () => updateText("DoubleTap"), //双击
                    onLongPress: () => updateText("LongPress"), //长按
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    //GestureDetector2
                    onTapUp: (x) => print("监听父组件 tapUp 手势---2"),
                    child: Container(
                      width: 200,
                      height: 80,
                      color: Colors.red,
                      alignment: Alignment.center,

                      /// GestureDetector 嵌套只会执行最上层的 widget
                      child: GestureDetector(
                        //GestureDetector1
                        onTapUp: (x) => print("监听子组件 tapUp 手势---1"),
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(10), child: Text("指针事件 - Listener")),
              Row(
                children: [
                  SizedBox(width: 20),
                  Container(
                    width: 50,
                    height: 50,
                    color: Colors.red,
                    child: Stack(
                      children: [
                        /// Listener 嵌套只会执行最上层的 widget
                        wChild(1),
                        wChild(2),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 50,
                    height: 50,
                    color: Colors.blue,
                    child: Stack(
                      children: [
                        /// Listener 的behavior: HitTestBehavior.opaque, 只会执行最上层
                        /// Listener behavior: HitTestBehavior.translucent, 会透传，同时执行
                        wChild2(1, 50),
                        wChild2(2, 50),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 50,
                    height: 50,
                    color: Colors.yellow,
                    child: Stack(
                      children: [
                        IgnorePointer(child: wChild2(1, 50)),

                        /// IgnorePointer
                        IgnorePointer(child: wChild2(2, 50)),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 50,
                    height: 50,
                    color: Colors.yellow,
                    child: Stack(
                      children: [
                        /// HitTestBlocker 实现 Listener 的穿透
                        HitTestBlocker(child: wChild2(1, 50)),
                        HitTestBlocker(child: wChild2(2, 50)),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 50,
                    height: 50,
                    color: Colors.yellow,
                    child: Stack(
                      children: [
                        HitTestBlocker(child: wChild3(1, 50)),

                        /// GestureDetector
                        HitTestBlocker(child: wChild3(2, 50)),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 50,
                    height: 50,
                    color: Colors.yellow,
                    child: Stack(
                      children: [
                        wChild3(1, 50),

                        /// GestureDetector
                        wChild3(2, 50),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(10), child: Text("手势冲突 - Listener")),
              Listener(
                // 将 GestureDetector 换位 Listener 即可
                onPointerUp: (x) => print("2"),
                child: Container(
                  width: 200,
                  height: 50,
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () => print("1"),
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10), child: Text("手势冲突 - 自定义手势识别器")),
              CustomGestureDetector(
                // 替换 GestureDetector
                onTap: () => print("手势冲突 - 自定义手势识别器---2"),
                child: Container(
                  width: 200,
                  height: 50,
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () => print("手势冲突 - 自定义手势识别器---1"),
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10), child: Text("富文本添加手势-TextSpan")),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "哈哈，你好"),
                    TextSpan(
                      text: "点我变色",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: _toggle ? Colors.blue : Colors.red,
                      ),
                      recognizer: _tapGestureRecognizer
                        ..onTap = () {
                          setState(() {
                            _toggle = !_toggle;
                          });
                        },
                    ),
                    TextSpan(text: "世界"),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  RikiRouterDelegate.of(context).pushUri('/event_bus_page');
                  // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  //   return EventBusPage();
                  // }));
                },
                child: Text('跳转'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget wChild(int index) {
    return Listener(
      // behavior: HitTestBehavior.opaque, // 放开此行，点击只会输出 2
      behavior: HitTestBehavior.translucent, // 放开此行，点击会同时输出 2 和 1
      onPointerDown: (e) => print(index),
      child: SizedBox.expand(),
    );
  }

  Widget wChild2(int index, double size) {
    return Listener(
      onPointerDown: (e) => print(index),
      child: Container(
        width: size,
        height: size,
        color: Colors.blue,
      ),
    );
  }

  Widget wChild3(int index, double size) {
    return GestureDetector(
      onTap: () => print('$index'),
      child: Container(
        width: size,
        height: size,
        color: Colors.grey,
      ),
    );
  }

  @override
  void dispose() {
    //用到GestureRecognizer的话一定要调用其dispose方法释放资源
    _tapGestureRecognizer.dispose();
    bus.off("login");
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("GesturePage---initState");
    bus.on("login", (arg) {
      print("GesturePage---bus---login---$arg");
    });
  }

  void updateText(String text) {
    //更新显示的事件名
    setState(() {
      _operation = text;
    });
  }
}

class HitTestBlocker extends SingleChildRenderObjectWidget {
  HitTestBlocker({
    Key? key,
    this.up = true,
    this.down = false,
    this.self = false,
    Widget? child,
  }) : super(key: key, child: child);

  /// up 为 true 时 , `hitTest()` 将会一直返回 false.
  final bool up;

  /// down 为 true 时, 将不会调用 `hitTestChildren()`.
  final bool down;

  /// `hitTestSelf` 的返回值
  final bool self;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderHitTestBlocker(up: up, down: down, self: self);
  }

  @override
  void updateRenderObject(BuildContext context, RenderHitTestBlocker renderObject) {
    renderObject
      ..up = up
      ..down = down
      ..self = self;
  }
}

class RenderHitTestBlocker extends RenderProxyBox {
  RenderHitTestBlocker({this.up = true, this.down = true, this.self = true});

  bool up;
  bool down;
  bool self;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    bool hitTestDownResult = false;

    if (!down) {
      hitTestDownResult = hitTestChildren(result, position: position);
    }

    bool pass = hitTestSelf(position) || (hitTestDownResult && size.contains(position));

    if (pass) {
      result.add(BoxHitTestEntry(this, position));
    }

    return !up && pass;
  }

  @override
  bool hitTestSelf(Offset position) => self;
}

//创建一个新的GestureDetector，用我们自定义的 CustomTapGestureRecognizer 替换默认的
RawGestureDetector CustomGestureDetector({
  GestureTapCallback? onTap,
  GestureTapDownCallback? onTapDown,
  Widget? child,
}) {
  return RawGestureDetector(
    child: child,
    gestures: {
      CustomTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<CustomTapGestureRecognizer>(
        () => CustomTapGestureRecognizer(),
        (detector) {
          detector.onTap = onTap;
        },
      )
    },
  );
}

class CustomTapGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    //不，我不要失败，我要成功
    //super.rejectGesture(pointer);
    //宣布成功
    super.acceptGesture(pointer);
  }
}
