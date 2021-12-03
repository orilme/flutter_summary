import 'package:flutter/material.dart';
import 'package:flutter_demo/index.dart';

class WidgetPage extends StatefulWidget {
  @override
  _WidgetPageState createState() => _WidgetPageState();
}

class _WidgetPageState extends State<WidgetPage> {

  final Map<String, Widget> pageMap = {
    'CustomScrollView': CustomScrollViewPage(),
    'SingleChildScrollView': SingleChildScrollViewPage(),
    'ListView/header悬浮': ListViewPage(),
    'ListViewSeparated': ListViewSeparatedPage(),
    'Sliver': SliverPage(),
    'SliverFillViewport': SliverFillViewportPage(),
    'SliverAppBar/SliverFillRemaining': SliverAppBarAndHeaderPage(),
    'SliverPersistentHeader': SliverPersistentHeaderPage(),
    'SliverToBoxAdapter': SliverToBoxAdapterPage(),
    'SliverAnimatedList': SliverAnimatedListPage(),
    'ExpansionPanelList': ExpansionPanelListPage(),
    'gridView': GridViewPage(),
    'staggeredGridView': StaggeredGridViewPage(),
    'TextPage': TextPage(),
    'Flexible': FlexiblePage(),
    'FlowPage': FlowPage(),
    'WarpPage': WarpPage(),
    'SizeBox': SizeBoxPage(),
    '容器组件': ContainerPage(),
    'Button': ButtonPage(),
    'Icon': IconPage(),
    'Stack': StackPage(),
    'OverflowBox': OverflowBoxPage(),
    'Border': BorderPage(),
    'Tooltip': TooltipPage(),
    'SnackBar': SnackBarPage(),
    'TurnBoxPage': TurnBoxPage(),
    'PreferredSize': PreferredSizePage(),
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      // 设置滚动方向
      scrollDirection: Axis.vertical,
      // 设置列数
      crossAxisCount: 2,
      // 设置内边距
      padding: EdgeInsets.all(5),
      // 设置横向间距
      crossAxisSpacing: 10,
      // 设置主轴间距
      mainAxisSpacing: 10,
      // 宽高比
      childAspectRatio: 10 / 2,
      children: _addBtton(),
    );
  }

  List<Widget> _addBtton() {
    List<Widget> list = [];
    pageMap.forEach((key, value) {
      list.add(
        OutlinedButton(
          child: Text("$key", style: TextStyle(color: Colors.lightBlueAccent, fontSize: 17)),
          onPressed: () {
            _itemClick(value);
          },
        ),
      );
    });
    return list;
  }

  void _itemClick(Widget page) {
    Navigator.of(context).push(
        MaterialPageRoute(builder:(BuildContext context){
          return page;
        })
    );
  }
}