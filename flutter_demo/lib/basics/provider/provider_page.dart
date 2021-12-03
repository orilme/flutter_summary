import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider_model.dart';
import './provider_consumer_page.dart';

/// Provider 获取数据状态有两种方式：
/// 使用 Provider.of<T>(context)//导致调用的 context 页面范围的刷新
/// 使用 Consumer//刷新了 Consumer 的部分
/// 不过这两种方式都需要在顶层套上 ChangeNotifierProvider():
///
/// 区别：
/// Consumer 就是通过 Provider.of<T>(context) 来实现的
/// 实际上 Consumer 非常有用，它的经典之处在于能够在复杂项目中，极大地缩小你的控件刷新范围。
/// Provider.of<T>(context) 将会把调用了该方法的 context 作为听众，并在 notifyListeners的时候通知其刷新。


/// 关于原则
// 1.不要所有状态都放在全局，严格区分你的全局数据与局部数据，资源不用了就要释放！
// 2.尽量在 Model 中使用私有变量"_"
// 3.控制刷新范围:组合大于继承的特性随处可见。常见的 Widget 实际上都是由更小的 Widget 组合而成，直到基本组件为止。为了使我们的应用拥有更高的性能，控制 Widget 的刷新范围便显得至关重要。

/// 应该在哪里进行数据初始化
/// 1.全局数据
// 当我们需要获取全局顶层数据并需要做一些会产生额外结果的时候，main 函数是一个很好的选择。
// 我们可以在 main 方法中创建 Model 并进行初始化的工作，这样就只会执行一次。
/// 2.单页面
// 页面级别的 Model 数据都在页面顶层 Widget 创建并初始化即可。

class ProviderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _counter = Provider.of<CounterModel>(context);
    final textSize = Provider.of<int>(context).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text('FirstPage'),
      ),
      body: Center(
        child: Text(
          'Value: ${_counter.value}',
          style: TextStyle(fontSize: textSize),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ProviderConsumerPage())),
        child: Icon(Icons.navigate_next),
      ),
    );
  }

}