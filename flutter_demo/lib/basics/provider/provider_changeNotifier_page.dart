import 'package:flutter/material.dart';

class ChangeNotifierPage extends StatefulWidget {
  @override
  _ChangeNotifierPageState createState() => _ChangeNotifierPageState();
}

class _ChangeNotifierPageState extends State<ChangeNotifierPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Provider-ChangeNotifier')),
      body: Center(
        child: BaoChangeNotifierProvider<CartModel>(
          data: CartModel(),
          child: Builder(builder: (context) {
            return Column(
              children: <Widget>[
                SizedBox(height: 50),
                Builder(builder: (context) {
                  var cart = BaoChangeNotifierProvider.of<CartModel>(context);
                  return Text("总价: ${cart.totalPrice}");
                }),
                Builder(builder: (context) {
                  print("RaisedButton build"); //在后面优化部分会用到
                  return ElevatedButton(
                    child: Text("添加商品"),
                    onPressed: () {
                      // 给购物车中添加商品，添加后总价会更新
                      BaoChangeNotifierProvider.of<CartModel>(context).add(Item(20.0, 1));
                    },
                  );
                }),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class Item {
  Item(this.price, this.count);
  // 商品单价
  double price;
  // 商品份数
  int count;
}

class CartModel extends ChangeNotifier {
  // 用于保存购物车中商品列表
  final List<Item> _items = [];

  // 购物车中商品的总价
  double get totalPrice => _items.fold(0, (value, item) => value + item.count * item.price);

  // 将 [item] 添加到购物车。这是唯一一种能从外部改变购物车的方法。
  void add(Item item) {
    _items.add(item);
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }
}

// 一个通用的InheritedWidget，保存需要跨组件共享的状态
class InheritedProvider<T> extends InheritedWidget {
  InheritedProvider({
    required this.data,
    required Widget child,
  }) : super(child: child);

  final T data;

  @override
  bool updateShouldNotify(InheritedProvider<T> old) {
    //在此简单返回true，则每次更新都会调用依赖其的子孙节点的`didChangeDependencies`。
    return true;
  }
}

class BaoChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
  BaoChangeNotifierProvider({
    Key? key,
    required this.data,
    required this.child,
  });

  final Widget child;
  final T data;

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static T of<T>(BuildContext context) {
    // final type = _typeOf<InheritedProvider<T>>();
    final provider = context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>>();
    return provider!.data;
  }

  @override
  _BaoChangeNotifierProviderState<T> createState() => _BaoChangeNotifierProviderState<T>();
}

class _BaoChangeNotifierProviderState<T extends ChangeNotifier> extends State<BaoChangeNotifierProvider<T>> {
  void update() {
    // 如果数据发生变化（model类调用了notifyListeners），重新构建InheritedProvider
    setState(() => {});
  }

  @override
  void didUpdateWidget(BaoChangeNotifierProvider<T> oldWidget) {
    //当Provider更新时，如果新旧数据不"=="，则解绑旧数据监听，同时添加新数据监听
    if (widget.data != oldWidget.data) {
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // 给model添加监听器
    widget.data.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    // 移除model的监听器
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<T>(
      data: widget.data,
      child: widget.child,
    );
  }
}
