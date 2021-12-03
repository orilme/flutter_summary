import 'package:flutter/material.dart';
import 'package:flutter_demo/widget/sliver_stickyTabBarDelegate.dart';

class SliverAppBarAndHeaderPage extends StatefulWidget {
  @override
  _SliverAppBarAndHeaderPageState createState() => _SliverAppBarAndHeaderPageState();
}

class _SliverAppBarAndHeaderPageState extends State<SliverAppBarAndHeaderPage> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    this.tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            // floating: true, /// 设置为true时，向下滑动时，即使当前CustomScrollView不在顶部，SliverAppBar也会跟着一起向下出现
            pinned: true,
            elevation: 0,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("SliverAppBar SliverPersistentHeader"),
              background: Image.network(
                'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverPersistentHeader(
            // shouldRebuild表示是否需要更新，如果内容需要变化需要设置为true。
            pinned: true,
            delegate: StickyTabBarDelegate(
              child: TabBar(
                labelColor: Colors.black,
                controller: this.tabController,
                tabs: <Widget>[
                  Tab(text: 'Home'),
                  Tab(text: 'Profile'),
                ],
              ),
            ),
          ),
          /// SliverFillRemaining是sliver系列组件之一，此组件充满视口剩余空间，通常用于最后一个sliver组件，以便于没有任何剩余控件
          SliverFillRemaining(
            child: TabBarView(
              controller: this.tabController,
              children: <Widget>[
                Icon(
                  Icons.sentiment_very_satisfied,
                  size: 75,
                  color: Colors.blue[900],
                ),
                Icon(
                  Icons.sentiment_very_satisfied,
                  size: 75,
                  color: Colors.red[900],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}