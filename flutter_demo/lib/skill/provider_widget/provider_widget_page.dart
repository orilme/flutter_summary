import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_demo/skill/provider_widget/provider_widget.dart';
import 'package:flutter_demo/skill/provider_widget/provider_widget_vm.dart';

class ProviderWidgetPage extends StatefulWidget {
  @override
  _ProviderWidgetPageState createState() => _ProviderWidgetPageState();
}

class _ProviderWidgetPageState extends State<ProviderWidgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ProviderWidget"),
          backgroundColor: Colors.green,
        ),
        body: ProviderWidget<ProviderWidgetViewModel>(
            model: ProviderWidgetViewModel(),
            onModelReady: (vm) {
              vm.setBusy();
              vm.refresh(init: true).then((value) {
                if (value == null || value.isEmpty) {
                  vm.setEmpty();
                } else {
                  print("111---setIdle");
                  vm.setIdle();
                }
              });
            },
            pageStatusFactory: null,
            builder: (_, vm, child) {
              return SafeArea(
                child: Column(children: [
                  _buildList(vm),
                ]),
              );
            }),
    );
  }

  Widget _buildList(ProviderWidgetViewModel vm) {
    return Expanded(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: SmartRefresher(
          onRefresh: vm.refresh,
          controller: vm.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onLoading: vm.loadMore,
          physics: BouncingScrollPhysics(),
          child: StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemCount: vm.list.length,
            padding: EdgeInsets.only(left: 12, right: 12, top: 12),
            staggeredTileBuilder: (index) => StaggeredTile.fit(1),
            itemBuilder: (ctx, index) {
              return Container(
                height: 60,
                color: Colors.green,
                child: Text('哈哈：${index}'),
              );
            },
          ),
        ),
      ),
    );
  }
}
