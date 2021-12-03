import 'dart:developer';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'list_view_state_model.dart';

/// 带下拉刷新的ViewModel基类
abstract class RefreshListViewStateModel<T> extends ListViewStateModel<T> {
  RefreshController _refreshController = RefreshController();

  RefreshController get refreshController => _refreshController;

  /// 当前页码
  int _currentPageNum = 1;

  get currentPageNum => pageNumFirst;

  /// 每页加载数量
  get pageDataSize => pageSize;

  /// 下拉刷新
  Future<List<T>?> refresh({bool init = false}) async {
    try {
      _currentPageNum = pageNumFirst;
      var data = await loadData(pageNum: pageNumFirst);
      if (data == null) {
        if (init) {
          list.clear();
          setEmpty();
        } else {
          refreshController.refreshFailed();
        }
      } else if (data.isEmpty) {
        list.clear();
        setEmpty();
      } else {
        list = data;
        onCompleted(data);
        refreshController.refreshCompleted();
        if (data.length < pageSize) {
          refreshController.loadNoData();
        } else {
          //防止上次上拉加载更多失败,需要重置状态
          refreshController.loadComplete();
        }
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
      return data;
    } catch (e, s) {
      refreshController.refreshFailed();
      log('RefreshListViewStateModel refresh error: ${e.toString()}');
      log('RefreshListViewStateModel refresh error stack: ${s.toString()}');
      return null;
    }
  }

  /// 上拉加载更多
  Future<List<T>?> loadMore() async {
    try {
      var data = await loadData(pageNum: ++_currentPageNum);
      if (data == null) {
        _currentPageNum--;
        refreshController.loadFailed();
      } else if (data.isEmpty) {
        _currentPageNum--;
        refreshController.loadNoData();
      } else {
        list.addAll(data);
        onCompleted(data);
        if (data.length < pageSize) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
        notifyListeners();
      }
      return data;
    } catch (e, s) {
      _currentPageNum--;
      refreshController.loadFailed();
      log('RefreshListViewStateModel loadMore error: ${e.toString()}');
      log('RefreshListViewStateModel loadMore error stack: ${s.toString()}');
      return null;
    }
  }

  // 加载数据
  @override
  Future<List<T>?> loadData({int? pageNum});

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
