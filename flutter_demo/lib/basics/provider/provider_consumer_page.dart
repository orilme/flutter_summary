import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider_model.dart';

/// 仅仅只有Consumer包裹的内容进行了重新构建

class ProviderConsumerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProviderConsumer'),
      ),
      body: Column(
        children: [
          Consumer2<CounterModel, int>(
            builder: (context, CounterModel counter, int textSize, _) {
              print("Consumer2 刷新");
              return Center(
                child: Text(
                  'Value: ${counter.value}',
                  style: TextStyle(
                    fontSize: textSize.toDouble(),
                  ),
                ),
              );
            }
          ),
          SizedBox(height: 20),
          Text("其他地方不刷新"),
        ],
      ),
      floatingActionButton: Consumer<CounterModel>(
        ///三个参数：(BuildContext context, T model, Widget child)
        ///context： context 就是 build 方法传进来的 BuildContext
        ///T：获取到的最近一个祖先节点中的数据模型。
        ///child：它用来构建那些与 Model 无关的部分，在多次运行 builder 中，child 不会进行重建
        ///=>返回一个通过这三个参数映射的 Widget 用于构建自身
        builder: (context, CounterModel counter, child) => FloatingActionButton(
          onPressed: counter.increment,
          child: child,
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}