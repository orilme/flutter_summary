import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './base_page_status_factory.dart';
import './view_state_model.dart';

/// Provider封装类
/// 方便数据初始化
class ProviderWidget<T extends ViewStateModel> extends StatefulWidget {
  final ValueWidgetBuilder<T> builder;

  ///根据model状态构建页面
  final T model;

  ///你的model
  final Widget? child;

  ///此child 为stateless 可以视具体情况使用（一般用不到）
  /// model创建好后会调用此方法，根据需要传入
  /// * 一般请求页面数据时会在此方法内调用
  final Function(T) onModelReady;

  ///页面多状态工厂
  /// * 不同状态所显示的Widget
  /// * 如果非页面使用[ProviderWidget] 可以传入[null]，child将不会应用页面状态
  final BasePageStatusFactory? pageStatusFactory;

  ProviderWidget({Key? key, required this.builder, required this.model, this.child, required this.onModelReady, this.pageStatusFactory})
      : super(key: key);

  _ProviderWidgetState<T> createState() => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends ViewStateModel> extends State<ProviderWidget<T>> {
  late T model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) {
        //与当前页面的context进行绑定
        model.bindContext(context);
        widget.onModelReady(model);
        return model;
      },
      child: Selector<T,int>(
        selector: (ctx,model) => model.refreshFlag,
        //shouldRebuild: (p,n) => p != n,
        builder: (ctx, v, child) {
          if (widget.pageStatusFactory != null) {
            if (model.busy) {
              return widget.pageStatusFactory!.fetchBusyStatusWidget();
            }
            if (model.noNet) {
              return widget.pageStatusFactory!.fetchNetExceptionStatusWidget();
            }
            if (model.empty) {
              return widget.pageStatusFactory!.fetchEmptyStatusWidget();
            }
            if (model.error) {
              return widget.pageStatusFactory!.fetchErrorStatusWidget();
            }
          }
          return widget.builder(ctx, model, child);
        },
        child: widget.child,
      ),
    );
  }
}

/// 单页面多Model下，页面状态只能由开发人员自行决定根据哪个model来切换

class ProviderWidget2<A extends ViewStateModel, B extends ViewStateModel> extends StatefulWidget {
  final Widget Function(BuildContext context, A model1, B model2, Widget? child) builder;
  final A model1;
  final B model2;
  final Widget? child;
  final Function(A, B)? onModelReady;

  ProviderWidget2({
    Key? key,
    required this.builder,
    required this.model1,
    required this.model2,
    this.child,
    this.onModelReady,
  }) : super(key: key);

  _ProviderWidgetState2<A, B> createState() => _ProviderWidgetState2<A, B>();
}

class _ProviderWidgetState2<A extends ViewStateModel, B extends ViewStateModel>
    extends State<ProviderWidget2<A, B>> {
  late A model1;
  late B model2;

  @override
  void initState() {
    model1 = widget.model1;
    model2 = widget.model2;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<A>(
            create: (context) {
              //与当前页面的context进行绑定
              model1.bindContext(context);
              if (widget.onModelReady != null) {
                widget.onModelReady!(model1, model2);
              }
              return model1;
            },
          ),
          ChangeNotifierProvider<B>(
            create: (context) {
              //与当前页面的context进行绑定
              model2.bindContext(context);
              return model2;
            },
          )
        ],
        child: Consumer2<A, B>(
          builder: widget.builder,
          child: widget.child,
        ));
  }
}

class ProviderWidget4<A extends ViewStateModel, B extends ViewStateModel,
C extends ViewStateModel, D extends ViewStateModel> extends StatefulWidget {
  final Widget Function(BuildContext context, A model_1, B model_2,
      C model_3, D model_4, Widget? child) builder;

  final A model_1;
  final B model_2;
  final C model_3;
  final D model_4;
  final Widget? child;
  final Function(A, B, C, D)? onModelReady;

  ProviderWidget4({Key? key, required this.builder,required  this.model_1,
    required this.model_2, required this.model_3, required this.model_4,
    this.child, this.onModelReady}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProviderWidgetState4<A, B, C, D>();
  }
}

class ProviderWidgetState4<A extends ViewStateModel, B extends ViewStateModel,
C extends ViewStateModel, D extends ViewStateModel>
    extends State<ProviderWidget4<A, B, C, D>> {
  late A model_1;
  late B model_2;
  late C model_3;
  late D model_4;

  @override
  void initState() {
    model_1 = widget.model_1;
    model_2 = widget.model_2;
    model_3 = widget.model_3;
    model_4 = widget.model_4;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<A>(
          create: (context) {
            model_1.bindContext(context);
            if (widget.onModelReady != null) {
              widget.onModelReady!(model_1, model_2, model_3, model_4);
            }
            return model_1;
          },
        ),
        ChangeNotifierProvider<B>(
          create: (context) {
            model_2.bindContext(context);
            return model_2;
          },
        ),
        ChangeNotifierProvider<C>(
          create: (context) {
            model_3.bindContext(context);
            return model_3;
          },
        ),
        ChangeNotifierProvider<D>(
          create: (context) {
            model_4.bindContext(context);
            return model_4;
          },
        ),
      ],
      child: Consumer4<A, B, C, D>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
