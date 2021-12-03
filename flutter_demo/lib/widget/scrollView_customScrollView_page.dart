import 'package:flutter/material.dart';

/*
ScrollPhysics:
滚动组件（CustomScrollView、ScrollView、GridView、ListView等）的physics参数表示此属性，
AlwaysScrollableScrollPhysics(默认): 总是可以滑动
NeverScrollableScrollPhysics: 禁止滚动
BouncingScrollPhysics: 内容超过一屏 上拉有回弹效果
ClampingScrollPhysics: 包裹内容 不会有回弹
PageScrollPhysics：用于PageView的滚动特性，停留在页面的边界
FixedExtentScrollPhysics: 滚动条直接落在某一项上，而不是任何位置，类似于老虎机，只能在确定的内容上停止，而不能停在2个内容的中间，用于可滚动组件的FixedExtentScrollController。
 */

class CustomScrollViewPage extends StatefulWidget {
  @override
  _CustomScrollViewPageState createState() => _CustomScrollViewPageState();
}

class _CustomScrollViewPageState extends State<CustomScrollViewPage> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // 监听滚动位置
    _scrollController.addListener(() {
      print('scroll---${_scrollController.position}');
    });

  }

  _startScroll() {
    // 滚动到指定位置
    _scrollController.animateTo(200.0, duration: Duration(milliseconds: 1000), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: PageScrollPhysics(),
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 230.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('复仇者联盟'),
            background: Image.network(
              'http://img.haote.com/upload/20180918/2018091815372344164.jpg',
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        SliverGrid.count(crossAxisCount: 4,children: List.generate(8, (index){
          return Container(
            color: Colors.primaries[index%Colors.primaries.length],
            alignment: Alignment.center,
            child: OutlinedButton(
              onPressed: () {
                _startScroll();
              },
              child: Text('$index',style: TextStyle(color: Colors.white,fontSize: 20)),
            ),
          );
        }).toList(),),
        SliverList(
          delegate: SliverChildBuilderDelegate((content, index) {
            return Container(
              height: 85,
              alignment: Alignment.center,
              color: Colors.primaries[index % Colors.primaries.length],
              child: Text('$index',style: TextStyle(color: Colors.white,fontSize: 20),),
            );
          }, childCount: 25),
        )
      ],
    );
  }
}
