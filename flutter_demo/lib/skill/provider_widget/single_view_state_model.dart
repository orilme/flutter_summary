import 'dart:developer';
import 'view_state_model.dart';

/// 单个接口的ViewModel基类
abstract class SingleViewStateModel<T> extends ViewStateModel with NetStatusCheckBinding {
  T? data;

  initData() async {
    setBusy();
    if(await checkNet()) {
      setNoNet();
      return;
    }
    await fetchData(fetch: true);
  }

  fetchData({bool fetch = false}) async {
    try {
      T? temp = await loadData();
      if (temp == null) {
        setEmpty();
      } else {
        data = temp;
        onCompleted(temp);
        if (fetch) {
          setIdle();
        } else {
          notifyListeners();
        }
      }
    } catch (e, s) {
      log('SingleViewStateModel fetchData error: ${e.toString()}');
      log('SingleViewStateModel fetchData error stack: ${s.toString()}');
    }
  }

  Future<T> loadData();

  onCompleted(T data);
}
