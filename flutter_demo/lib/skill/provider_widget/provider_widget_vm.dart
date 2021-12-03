import 'dart:async';
import 'package:flutter_demo/skill/provider_widget/refresh_list_view_state_model.dart';

class ProviderWidgetViewModel extends RefreshListViewStateModel<String> {

  int numpage = 1;
  @override
  onCompleted(List<String> data) {
  }

  @override
  Future<List<String>?> loadData({int? pageNum}) {
    return Future.delayed(Duration(milliseconds: 10), () {
      List<String> list = [];
      int num = numpage * 20;
      for (int i = 0; i < num; i++) {
        list.add("value:${i}");
      }
      numpage++;
      return list;
    });
  }

}