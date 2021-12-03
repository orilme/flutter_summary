import 'dart:developer';
import 'view_state_model.dart';

/// 列表ViewModel基类
abstract class ListViewStateModel<T> extends ViewStateModel with NetStatusCheckBinding {
  /// 分页第一页页码
  final int pageNumFirst = 1;

  /// 分页条目数量
  int pageSize = 10;

  /// 页面数据
  List<T> list = [];

  /// 第一次加载
  bool firstInit = true;

  /// 第一次进入页面loading skeleton
  initData() async {
    setBusy();
    if (await checkNet()) {
      setNoNet();
      return;
    }
    await refresh(init: true);
  }

  /// 下拉刷新
  refresh({bool init = false}) async {
    try {
      List<T>? data = await loadData();
      if (data == null) {
        setError('');
      } else if (data.isEmpty) {
        setEmpty();
      } else {
        list = data;
        onCompleted(data);
        if (init) {
          firstInit = false;
          //改变页面状态为非加载中
          setIdle();
        } else {
          if (empty) {
            setIdle();
          } else {
            notifyListeners();
          }
        }
        onRefreshCompleted();
      }
    } catch (e, s) {
      log('ListViewStateModel refresh error: ${e.toString()}');
      log('ListViewStateModel refresh error stack: ${s.toString()}');
    }
  }

  /// 加载数据
  Future<List<T>?> loadData();

  /// 数据获取后会调用此方法,此方法在notifyListeners()之前
  onCompleted(List<T> data) {}

  /// 状态刷新后会调用此方法，此方法在notifyListeners()之后
  onRefreshCompleted() {}
}
