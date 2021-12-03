import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import './refresh_list_view_state_model.dart';
import './single_view_state_model.dart';

import 'view_state.dart';

/// 项目中所有ViewModel的基类
/// * 通过[set***()]切换状态，将会导致页面UI的不同
/// * 你可以直接使用其子类[SingleViewStateModel]或[RefreshListViewStateModel]
/// * 也可以继承此类进行实现自己的ViewModel
/// * 如果你时自定义的ViewModel，那么你需要混入[NetStatusCheckBinding]类已增加网络检查的功能
/// * 例如，在无望的情况下进行页面的无网状态的显示
/// ```dart
///  ///假设这是你的页面数据请求的入口方法
///  initData() async {
///     setBusy();
///     //这里进行状态检查
///     if(await checkNet()){
///     // 状态的切换
///       setNoNet();
///       return;
///     }
///     // 请求你的页面数据
///     await fetchData(fetch: true);
///   }
///
/// ```

abstract class ViewStateModel with ChangeNotifier {

  /// 与当前VM绑定的Widget(一般是页面) context.
  BuildContext? context;
  void bindContext(BuildContext context) {
    assert(context != null,'context 不能为空');
    this.context = context;
  }

  /// 当前页面是否显示在前端（可见）
  /// * 如果是弹窗（基于[Route]），那么同样有效，如果是基于[Overlay]则可能无效。
  bool isCurrentShow(){
    assert(context != null,'context 不能为空。 引起此错误的原因可能是在initState()方法中调用了此方法');
    return ModalRoute.of(context!)!.isCurrent;
  }

  bool disposed = false;

  ViewState _viewState;

  /// 根据状态构造
  ///
  /// 子类可以在构造函数指定需要的页面状态
  ViewStateModel({ViewState? viewState}) : _viewState = viewState ?? ViewState.idle;

  ViewState get viewState => _viewState;

  void setViewState(ViewState viewState, {bool updateUI = true}) {
    _viewState = viewState;
    if (updateUI) {
      notifyListeners();
    }
  }

  /// 出错时的message
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool get busy => viewState == ViewState.busy;

  bool get idle => viewState == ViewState.idle;

  bool get empty => viewState == ViewState.empty;

  bool get error => viewState == ViewState.error;

  bool get noNet => viewState == ViewState.noNet;

  void setBusy({bool updateUI = true}) {
    _errorMessage = null;
    setViewState(ViewState.busy, updateUI: updateUI);
  }

  void setEmpty({bool updateUI = true}) {
    _errorMessage = null;
    setViewState(ViewState.empty, updateUI: updateUI);
  }

  void setError(String message, {bool updateUI = true}) {
    _errorMessage = message;
    setViewState(ViewState.error, updateUI: updateUI);
  }

  void setIdle({bool updateUI = true}) {
    _errorMessage = null;
    setViewState(ViewState.idle, updateUI: updateUI);
  }

  void setNoNet({String? toast, bool updateUI = true}) {
    _errorMessage = toast;
    setViewState(ViewState.noNet, updateUI: updateUI);
  }

  @override
  String toString() {
    return 'BaseModel{_viewState: $viewState, _errorMessage: $_errorMessage}';
  }

  int refreshFlag = -1;

  @override
  void notifyListeners({bool refreshVM = true}) {
    if (!disposed) {
      if(refreshVM) refreshFlag++;
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}

/// 网络状态检查的功能类
/// * 尤其子类混入，以增加网络检查的功能
mixin NetStatusCheckBinding on ViewStateModel{
  ///检查网络状态
  Future<bool> checkNet()async{
    debugPrint('检查网络');
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.none;
  }
}
